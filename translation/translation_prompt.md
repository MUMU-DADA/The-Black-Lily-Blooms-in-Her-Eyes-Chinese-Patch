# 交给下一翻译模型的任务上下文

你正在继续制作《黑百合在她眼中绽放》的简体中文汉化补丁。

必须遵守：

1. **翻译源语言是日文，不是英文。** 日文原文位于 `chinese-patch/source/data/scenario/ja/`；英文目录只作结构参考。
2. 中文目标文件位于 `chinese-patch/source/data/scenario/zh-CN/`，相对路径必须与日文目录完全一致。
3. 翻译要连续、通顺，并符合人物性格、叙事视角和当前剧情语境；不能逐句机械直译。
4. 保留 TyranoScript 标签、变量、宏、函数、文件名、资源路径、条件表达式和数值。尤其不能破坏 `[p]`、`[r]`、`[ruby]`、`[emb]`、`[if]`、`[jump]`。
5. 使用 UTF-8 无 BOM 保存 `.ks` 文件。不要修改原始 `resources/app.asar`。
6. 新术语先写入 `chinese-patch/translation/glossary.md`，再用于正文。
7. 每完成一个文件，在 `chinese-patch/translation/progress.md` 记录状态和待确认问题。

当前工程状态：

- ASAR 可编辑资源已提取到 `chinese-patch/source/`。
- `zh-CN` 目录已经按日文目录建立，当前内容仍是待翻译副本。
- 已归档字体：`chinese-patch/fonts/OTF/SimplifiedChinese/SourceHanSansSC-Regular.otf` 及许可证。
- 已有工具：`chinese-patch/tools/asar_tool.ps1`。
- 用户不要求本阶段进行实机测试，完成后由用户自行验证。

推荐起点：先翻译 `source/data/scenario/ja/story/chapter1s1.ks`，完成后再按章节顺序推进。翻译前先通读该文件，并参考 `translation/translation_rules.md` 和 `translation/glossary.md`。
