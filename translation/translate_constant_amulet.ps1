$p='C:\Users\pc\Desktop\TheBlackLilyBloomsinHerEyes\chinese-patch\source\data\scenario\constant\item.ks'
$pairs=@(
@('攻高守低の咒物','攻高守低之咒物'),@('攻高敏低の咒物','攻高敏低之咒物'),@('守高攻低の咒物','守高攻低之咒物'),@('守高敏低の咒物','守高敏低之咒物'),@('敏高攻低の咒物','敏高攻低之咒物'),@('敏高守低の咒物','敏高守低之咒物'),@('自身のファミリアの召喚時ATKLv+1、DEFLv-1。','我方使魔召唤时 ATK 等级 +1、DEF 等级 -1。'),@('自身のファミリアの召喚時ATKLv+1、SPDLv-1。','我方使魔召唤时 ATK 等级 +1、SPD 等级 -1。'),@('自身のファミリアの召喚時DEFLv+1、ATKLv-1。','我方使魔召唤时 DEF 等级 +1、ATK 等级 -1。'),@('自身のファミリアの召喚時DEFLv+1、SPDLv-1。','我方使魔召唤时 DEF 等级 +1、SPD 等级 -1。'),@('自身のファミリアの召喚時SPDLv+1、ATKLv-1。','我方使魔召唤时 SPD 等级 +1、ATK 等级 -1。'),@('自身のファミリアの召喚時SPDLv+1、DEFLv-1。','我方使魔召唤时 SPD 等级 +1、DEF 等级 -1。'),@('召喚フェイズ時のみ発動可能。召喚フェイズを終了し、','仅能在召唤阶段发动。结束召唤阶段，')
)
$lines=[System.Collections.Generic.List[string]](Get-Content $p -Encoding UTF8); foreach($i in 0..($lines.Count-1)){foreach($x in $pairs){$lines[$i]=$lines[$i].Replace($x[0],$x[1])}}; [IO.File]::WriteAllLines($p,$lines,[Text.UTF8Encoding]::new($false))
