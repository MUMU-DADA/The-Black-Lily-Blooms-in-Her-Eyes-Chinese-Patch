# 《黑百合在她眼中绽放》中文补丁开发目录

本目录用于维护中文补丁的源文件和构建工具。原始游戏文件位于上一级目录，开发过程不直接修改原始 `resources/app.asar`。

当前阶段已完成 ASAR 资源提取、`zh-CN` 目标语言目录、主要剧情与战斗/常量脚本汉化和翻译规则。翻译时以日文脚本为唯一源文本，英文脚本仅用于核对程序结构和已有专有名词。

## 目录

- `tools/asar_tool.ps1`：从原始 ASAR 提取脚本、界面资源和字体。
- `source/`：从 ASAR 提取出的可编辑资源（运行提取脚本后生成）。
- `translation/`：中文翻译稿和术语表。
- `translation/translation_rules.md`：交给翻译模型的完整工作规范。
- `translation/translation_prompt.md`：可直接复制给下一模型的任务上下文。
- `build/`：最终补丁输出目录。
- `fonts/`：已归档的思源黑体简体中文字体及许可证。

## 安装补丁

发布包是根目录覆盖包。完全退出游戏后，将
`BlackLily-ChinesePatch-root-20260828.zip` 直接解压到游戏根目录，并允许覆盖同名文件。
压缩包内的 `resources/app.asar` 会自动放到正确位置；不需要手动进入 `resources` 文件夹复制文件。

建议解压前将原来的 `resources/app.asar` 重命名为 `resources/app.asar.bak`，作为备份。
启动游戏后，在标题菜单的语言选项中选择“简体中文”。

安装后的目录结构应为：

```text
游戏目录/
  resources/
    app.asar
    app.asar.bak
```

如需还原，退出游戏后删除补丁版 `app.asar`，再将 `app.asar.bak` 重命名回 `app.asar` 即可。请不要直接修改或删除原始备份文件。

根目录发布包：`BlackLily-ChinesePatch-root-20260828.zip`
单文件归档：`build/app.asar`

## 提取资源

在 `chinese-patch` 目录执行：

```powershell
.\tools\asar_tool.ps1 -Command extract
```

脚本只提取 `.ks/.js/.css/.html/.json`、带文字的 PNG/JPG/GIF 和字体，不复制音频与大型背景素材。

## 翻译约定

详见 [`translation/translation_rules.md`](translation/translation_rules.md)。核心原则是：日文原文优先、按连续场景翻译、保留脚本结构、统一术语和人物口吻。
