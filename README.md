# dotfiles

> 个人 macOS 开发环境配置，基于 LazyVim 的 Neovim 配置 + 全套终端工具链。

## 目录

- [概览](#概览)
- [快速开始](#快速开始)
- [配置清单](#配置清单)
- [目录结构](#目录结构)
- [快捷键参考](#快捷键参考)
- [脚本说明](#脚本说明)
- [维护与更新](#维护与更新)

---

## 概览

本仓库包含完整的 macOS 开发环境配置，涵盖：

| 类别 | 工具 |
|------|------|
| **终端** | Kitty（多布局 + 光标轨迹特效） |
| **Shell** | Zsh + Starship 提示符 + zoxide |
| **编辑器** | Neovim（基于 LazyVim）+ Cursor + VS Code |
| **复用器** | Tmux（Oh My Tmux! + 电池/主机名状态栏） |
| **文件管理** | Yazi（终端文件管理器） |
| **版本控制** | Git + Lazygit |
| **容器** | Docker + Lazydocker |
| **包管理** | Homebrew（Brewfile 一键安装） |

---

## 快速开始

### 新机器初始化

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/optiplex331/dotfiles/main/scripts/setup.sh)"
```

该脚本会依次执行：

1. 检查并配置 GitHub SSH 密钥
2. 安装 Homebrew（如未安装）
3. 克隆本仓库至 `~/Code/dotfiles`
4. 执行 `restore.sh` 创建所有软链接
5. 执行 `brew bundle` 安装所有软件

### 已有仓库恢复配置

```bash
bash ~/Code/dotfiles/scripts/restore.sh
```

该脚本会将所有配置目录软链接到家目录，已存在的文件自动备份至 `~/.dotfiles_backup/`。

---

## 配置清单

### Shell (Zsh)

- **提示符**: Starship（自定义 git 状态、云环境、50+ 语言模块）
- **高亮**: zsh-syntax-highlighting（实时命令着色）
- **导航**: zoxide（智能 `cd`，学习常用目录）
- **模糊查找**: fzf（`Ctrl+R` 历史搜索、`Ctrl+T` 文件搜索）
- **文件列表**: eza 替代 ls（图标 + 超链接）
- **Python**: uv（统一的版本 + 包 + 环境管理）
- **Node.js**: Volta（版本管理）
- **Java**: JDK 8 / 11 / 17 快速切换别名

#### 常用别名

**文件操作**

| 别名 | 命令 | 说明 |
|------|------|------|
| `ls` | `eza --hyperlink` | 基础列表 |
| `ll` | `ls -l --icons` | 详细列表 + 图标 |
| `la` | `l -a` | 显示隐藏文件 |
| `lt` | `eza -T -L 2` | 树状显示（2层） |
| `y` | `yazi` | 打开文件管理器 |
| `c` | `clear` | 清屏 |
| `pb` | `pbcopy` | 复制到剪贴板 |

**编辑器**

| 别名 | 命令 | 说明 |
|------|------|------|
| `v` | `nvim` | 打开 Neovim |
| `vim` | `nvim` | 使用 Neovim 替代 vim |

**Git**

| 别名 | 命令 | 说明 |
|------|------|------|
| `g` | `git` | Git 快捷方式 |
| `gs` | `git status -s` | 简洁状态 |
| `ga` | `git add` | 暂存文件 |
| `gc` | `git commit` | 提交 |
| `gl` | `git log --color --graph` | 图形化日志 |
| `gpull` | `git pull origin` | 拉取 |
| `gpush` | `git push origin` | 推送 |
| `gcb` | fzf 分支切换 | 模糊搜索切换分支 |
| `gstash` | `git stash` | 暂存改动 |
| `gpop` | `git stash pop` | 恢复改动 |
| `lg` | `lazygit` | Git TUI |

**Docker / Kubernetes**

| 别名 | 命令 | 说明 |
|------|------|------|
| `d` | `docker` | Docker 快捷方式 |
| `dp` | `docker ps` | 运行中的容器 |
| `de` | `docker exec -it` | 进入容器 |
| `ld` | `lazydocker` | Docker TUI |
| `k` | `kubectl` | kubectl 快捷方式 |
| `kp` | `kubectl get pods` | 获取 Pod 列表 |
| `kl` | `kubectl logs` | Pod 日志 |
| `klf` | `kubectl logs -f --tail=100` | 实时日志 |
| `ke` | `kubectl exec -it` | 进入 Pod |

**Tmux**

| 别名 | 命令 | 说明 |
|------|------|------|
| `tnew` | `tmux new -s` | 新建会话 |
| `ta` | `tmux a -t` | 附加到会话 |

**JDK 切换**

| 别名 | 说明 |
|------|------|
| `jdk8` | 切换到 JDK 8 |
| `jdk11` | 切换到 JDK 11 |
| `jdk17` | 切换到 JDK 17（默认） |

---

### Neovim

- **框架**: LazyVim
- **插件管理**: lazy.nvim
- **语言**: Lua
- **主题**: TokyoNight Moon（透明背景）

#### 插件列表

| 插件 | 用途 |
|------|------|
| `akinsho/bufferline.nvim` | 顶部 Buffer 标签栏 |
| `folke/tokyonight.nvim` | 配色主题（Moon 风格）|
| `neovim/nvim-lspconfig` | LSP 配置（含 rust-analyzer）|
| `mistweaverco/kulala.nvim` | HTTP 客户端（`<Leader>Rs` 发送请求）|
| `mg979/vim-visual-multi` | 多光标编辑 |
| `nvim-mini/mini.surround` | 快速添加/修改/删除包围符 |
| `godlygeek/tabular` | 文本对齐（`<Leader>t`）|
| `stevearc/conform.nvim` | 按文件类型格式化 |
| `keaising/im-select.nvim` | macOS 输入法自动切换 |
| `snacks.nvim` | 工具集（滚动动画已关闭）|

#### 已禁用默认插件

- `folke/flash.nvim`
- `ggandor/flit.nvim`
- `mini.ai`

#### LazyVim Extras

- `lazyvim.plugins.extras.coding.mini-surround`
- `lazyvim.plugins.extras.lang.markdown`

---

### Kitty

- **字体**: Menlo 14pt
- **背景色**: `#282c34`（One Dark 风格）
- **光标**: Block 形状，带轨迹残影特效
- **功能**: 鼠标选中自动复制
- **布局**: fat / tall / stack / grid / vertical / horizontal（`Ctrl+Shift+L` 切换）
- **标签栏**: 底部，`┃` 分隔符风格

#### 标签快捷键

| 快捷键 | 功能 |
|--------|------|
| `Cmd + T` | 新建标签页 |
| `Cmd + W` | 关闭标签页 |
| `Cmd + Shift + I` | 重命名标签页 |
| `Ctrl + Shift + ]` | 下一个标签页 |
| `Ctrl + Shift + [` | 上一个标签页 |
| `Cmd + 1~9` | 跳转到指定标签页 |

---

### Tmux

- **框架**: Oh My Tmux!（`.tmux.conf.local` 覆盖默认配置）
- **前缀键**: `Ctrl-b`（默认）
- **鼠标**: 启用
- **状态栏左侧**: 会话名 ❐ + 系统运行时间
- **状态栏右侧**: 前缀指示 ⌨ + 电池状态 + 时间 + 用户名 + 主机名
- **电池**: 渐变色进度条（◼◻），充电 ↑ / 放电 ↓ 状态图标
- **时钟**: 24 小时制

---

### Starship

- 支持 50+ 语言/工具模块（AWS、Python、Node、Go、Rust、Java、Kotlin 等）
- **目录**: 显示完整路径，不截断，只读目录显示 󰌾
- **Git 分支**: ` ` 图标前缀
- **Git 状态**: `✘` 冲突 / `!` 修改 / `?` 未跟踪 / `+` 暂存 / `⇡⇣` 领先/落后
- **代理**: 自动显示 `all_proxy` 环境变量
- **命令耗时**: 显示执行时间较长的命令耗时

---

### Yazi

- **布局**: 三栏比例 1:4:4
- **排序**: 字母序，目录优先
- **显示**: 隐藏文件默认关闭，显示软链接目标
- **行信息**: 文件大小
- **标题**: `Yazi: {cwd}`
- **鼠标**: 支持点击和滚动
- **滚动边距**: 5 行

---

### Git

- **用户**: Qin Zeng / optiplex331@gmail.com
- **全局 ignore**: `.claude/settings.local.json`

---

### Codex

- **配置文件**: `~/.codex/config.toml`
- **管理方式**: 仓库内 `codex/` 目录保存 Codex 配置模板；`scripts/restore.sh` 会渲染 `config.toml` 中的 `{{DOTFILES_DIR}}` 占位符为当前仓库目录

---

### Lazygit

- **布局**: 左侧面板占 1/3 屏宽，弹性分割模式
- **鼠标**: 启用
- **标签宽度**: 4 空格
- **主题色**: 绿色激活边框（`bold`），青色搜索边框

---

### Cursor

- **主题**: IntelliJ Neo Dark
- **字体**: JetBrains Mono 15pt，Monaco 兜底
- **行号**: 相对行号（配合跳转使用）
- **格式化**: 保存时自动格式化 + 整理 import
  - 默认：Prettier
  - Python：Ruff
  - Terraform：官方插件
- **光标**: 呼吸式闪烁，平滑移动动画
- **外部终端**: Kitty
- **AI 补全**: Markdown 中关闭

---

### VS Code

- **主题**: IntelliJ Neo Dark
- **图标**: Material Icon Theme
- **字号**: 15pt，行高 1.6
- **Minimap**: 关闭
- **格式化**: 保存时自动格式化
  - 默认：Prettier
  - Python：YAPF
  - Java：Red Hat 扩展
- **自动保存**: 失去焦点时保存
- **终端**: 继承父进程环境变量
- **Code Runner**: 配置 20+ 语言的一键运行命令
- **遥测**: 全部关闭（VS Code / Red Hat / Julia 扩展）

---

## 目录结构

```
.
├── claude/                 # Claude 全局短入口与 statusline
│   ├── CLAUDE.md
│   └── statusline.sh
├── codex/                  # Codex 配置模板
│   └── config.toml
├── cursor/                 # Cursor 编辑器配置
│   ├── settings.json
│   └── keybindings.json
├── vscode/                 # VS Code 编辑器配置
│   └── settings.json
├── git/                    # Git 全局配置
│   ├── gitconfig
│   └── ignore
├── ghostty/                # Ghostty 终端配置
│   └── config
├── kitty/                  # Kitty 终端
│   └── kitty.conf
├── lazydocker/             # Lazydocker Docker TUI
│   └── config.yml
├── lazygit/                # Lazygit Git TUI
│   └── config.yml
├── nvim/                   # Neovim 配置 (LazyVim)
│   ├── init.lua
│   ├── lazyvim.json
│   └── lua/
│       ├── config/
│       │   ├── autocmds.lua
│       │   ├── keymaps.lua
│       │   ├── lazy.lua
│       │   └── options.lua
│       └── plugins/
│           ├── bufferline.lua
│           ├── colorschema.lua
│           ├── disabled.lua
│           ├── format.lua
│           ├── input-method.lua
│           ├── kulala.lua
│           ├── lsp.lua
│           ├── multi-cursor.lua
│           ├── surround.lua
│           └── tabular.lua
├── scripts/                # 自动化脚本
│   ├── setup.sh            # 新机器一键初始化
│   └── restore.sh          # 软链接恢复脚本
├── starship/               # Starship 提示符
│   └── starship.toml
├── tmux/                   # Tmux 终端复用器
│   └── tmux.conf.local
├── vim/                    # Vim 配置
│   └── vimrc
├── yazi/                   # Yazi 文件管理器
│   ├── yazi.toml
│   ├── keymap.toml
│   └── theme.toml
├── zsh/                    # Zsh Shell 配置
│   └── zshrc
└── Brewfile                # Homebrew 软件清单
```

---

## 快捷键参考

### Neovim

**窗口分割**

| 快捷键 | 功能 |
|--------|------|
| `sh` | 向左垂直分割 |
| `sj` | 向下水平分割 |
| `sk` | 向上水平分割 |
| `sl` | 向右垂直分割 |

**窗口导航**

| 快捷键 | 功能 |
|--------|------|
| `<Leader> h/j/k/l` | 聚焦左/下/上/右窗口 |
| `<up/down>` | 增减窗口高度 ±5 |
| `<left/right>` | 增减窗口宽度 ±5 |

**光标移动**

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+H/L` | 跳到行首/行尾 |
| `Ctrl+J/K` | 向下/上跳 5 行 |
| `J / K` | 向下/上滚屏 5 行 |
| `H / L` | 向左/右平移 50 列 |
| `vie` | 选中全文 |

**编辑**

| 快捷键 | 功能 |
|--------|------|
| `S` | 保存文件（`:w`） |
| `q` | 关闭 Buffer（`:bd`） |
| `Q` | 退出（`:q`） |
| `U` | 重做（`Ctrl+r`） |
| `` ` `` | 切换大小写 |
| `sm` | 录制宏（`q`） |
| `<Leader>;` | 行末补全分号 |
| `<Leader>t` | 文本对齐（Tabular） |
| `Ctrl+Enter` | 发送 HTTP 请求（kulala.nvim） |

**剪贴板（macOS）**

| 快捷键 | 功能 |
|--------|------|
| `Cmd+C`（可视模式） | 复制到系统剪贴板 |
| `Cmd+V` | 从系统剪贴板粘贴 |

---

## 脚本说明

| 脚本 | 用途 |
|------|------|
| `scripts/setup.sh` | 新机器一键初始化（SSH + Homebrew + 克隆 + 恢复 + brew bundle） |
| `scripts/restore.sh` | 幂等软链接创建，渲染路径敏感配置，已有文件自动备份至 `~/.dotfiles_backup/` |

---

## 维护与更新

### 更新软件

```bash
# 更新 Homebrew 及所有软件
brew update && brew upgrade && brew cleanup --prune=all

# 更新 Neovim 插件
:Lazy update

# 更新 Treesitter 解析器
:TSUpdate
```

### 添加新软件

编辑 `Brewfile` 后执行：

```bash
brew bundle --file=~/Code/dotfiles/Brewfile
```

### 新增配置文件

1. 将文件/目录放入仓库对应工具目录
2. 在 `scripts/restore.sh` 中添加对应 `link` 行
3. 重新运行 `bash scripts/restore.sh`

### 配置立即生效

```bash
# 重新运行恢复脚本（会重建软链接）
bash ~/Code/dotfiles/scripts/restore.sh
```
