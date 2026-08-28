param(
    [Parameter(Mandatory=$true)][ValidateSet('list','extract')][string]$Command,
    [string]$AsarPath = '..\resources\app.asar',
    [string]$OutputDir = 'source'
)

$ErrorActionPreference = 'Stop'

function Read-AsarIndex([string]$Path) {
    $resolved = (Resolve-Path $Path).Path
    $stream = [IO.File]::OpenRead($resolved)
    if ($stream.Length -lt 16) { $stream.Dispose(); throw 'Invalid ASAR: file is too small.' }
    $prefix = [byte[]]::new(16)
    [void]$stream.Read($prefix, 0, 16)
    $headerLength = [BitConverter]::ToUInt32($prefix, 4)
    # ASAR stores a 16-byte pickle prefix, but the indexed file payload starts
    # after the 8-byte size prefix plus the JSON header length.
    $headerStart = 16
    $headerEnd = $headerStart + [int64]$headerLength - 1
    if ($headerEnd -ge $stream.Length) { $stream.Dispose(); throw 'Invalid ASAR: header exceeds file size.' }
    $headerBytes = [byte[]]::new($headerLength)
    $stream.Position = $headerStart
    [void]$stream.Read($headerBytes, 0, $headerBytes.Length)
    $headerText = [Text.Encoding]::UTF8.GetString($headerBytes)
    # Electron ASAR reserves a larger header area than the JSON payload and
    # may leave non-JSON padding after the terminating NUL byte.
    $nullIndex = $headerText.IndexOf([char]0)
    if ($nullIndex -ge 0) { $headerText = $headerText.Substring(0, $nullIndex) }
    $jsonEnd = $headerText.LastIndexOf('}')
    if ($jsonEnd -lt 0) { throw 'Invalid ASAR: JSON header not found.' }
    $headerText = $headerText.Substring(0, $jsonEnd + 1)
    $stream.Dispose()
    [PSCustomObject]@{
        AsarPath = $resolved
        PayloadOffset = 8 + [int64]$headerLength
        Index = ($headerText | ConvertFrom-Json)
    }
}

function Get-AsarFiles($Node, [string]$Prefix = '') {
    if (-not $Node.files) { return }
    foreach ($property in $Node.files.psobject.Properties) {
        $path = if ($Prefix) { "$Prefix/$($property.Name)" } else { $property.Name }
        $value = $property.Value
        if ($value.files) { Get-AsarFiles $value $path }
        else {
            [PSCustomObject]@{ Path = $path; Size = [int64]$value.size; Offset = [int64]$value.offset }
        }
    }
}

$asar = Read-AsarIndex $AsarPath
$files = @(Get-AsarFiles $asar.Index)

if ($Command -eq 'list') {
    $files | Sort-Object Path | Format-Table -AutoSize
    exit 0
}

$root = [IO.Path]::GetFullPath((Join-Path (Get-Location) $OutputDir))
New-Item -ItemType Directory -Force -Path $root | Out-Null
$selected = $files | Where-Object {
    $_.Path -match '\.(ks|js|css|html|json)$' -or
    $_.Path -match '^data/(image|fgimage)/.*(_en)?\.(png|jpg|gif)$' -or
    $_.Path -match '^data/others/font/.*\.(ttf|woff|woff2)$'
}

foreach ($file in $selected) {
    $target = Join-Path $root ($file.Path -replace '/', '\\')
    $targetDir = Split-Path -Parent $target
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    if ($file.Size -eq 0) { [IO.File]::WriteAllBytes($target, [byte[]]@()); continue }
    $input = [IO.File]::OpenRead($asar.AsarPath)
    $input.Position = $asar.PayloadOffset + $file.Offset
    $output = [IO.File]::Create($target)
    try {
        $remaining = $file.Size
        $buffer = [byte[]]::new(1048576)
        while ($remaining -gt 0) {
            $want = [int][Math]::Min($buffer.Length, $remaining)
            $read = $input.Read($buffer, 0, $want)
            if ($read -le 0) {
                # A few Electron-built archives reserve an 8-byte trailer in
                # the index. Preserve the bytes that are present and report it.
                Write-Warning "ASAR entry is shorter than indexed: $($file.Path)"
                break
            }
            $output.Write($buffer, 0, $read)
            $remaining -= $read
        }
    } finally { $output.Dispose(); $input.Dispose() }
}

$selected | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 (Join-Path $root 'asar-files.json')
Write-Output "Extracted $($selected.Count) files to $root"
