# ============================================================================
# ~/.zprofile - Zsh Login Shell 环境配置文件
# 最后更新: 2026-05
# ============================================================================
#
# 作用说明：
#   ~/.zprofile 只在 login shell 启动时读取。
#
# 适合放：
#   - Homebrew 初始化
#   - 全局语言环境
#   - EDITOR / VISUAL
#   - Node / Rust / Bun 等基础环境变量
#   - PATH 基础配置
#
# 不适合放：
#   - alias
#   - shell prompt
#   - 补全系统
#   - fzf / zoxide / syntax highlighting
#   - 交互式函数
#
# 这些交互体验相关内容应放到 ~/.zshrc。
# ============================================================================


# ============================================================================
# 1. Homebrew 环境初始化
# ============================================================================

# Homebrew 官方推荐初始化方式。
# 作用：
#   - 设置 HOMEBREW_PREFIX
#   - 设置 HOMEBREW_CELLAR
#   - 设置 HOMEBREW_REPOSITORY
#   - 把 /opt/homebrew/bin 和 /opt/homebrew/sbin 加入 PATH
#
# 注意：
#   Apple Silicon Mac 默认路径通常是 /opt/homebrew。
#   Intel Mac 默认路径通常是 /usr/local。
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi


# ============================================================================
# 2. 语言和字符编码
# ============================================================================

# 设置默认字符编码，避免终端、脚本、CLI 工具在处理中英文时出现乱码。
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# ============================================================================
# 3. 默认编辑器
# ============================================================================

# 设置默认编辑器为 VS Code。
#
# --wait 的作用：
#   让调用方等待 VS Code 窗口关闭后再继续执行。
#
# 典型场景：
#   - git commit 不带 -m 时打开编辑器
#   - kubectl edit
#   - crontab -e
#   - 其他需要外部编辑器的 CLI 工具
export EDITOR='code --wait'
export VISUAL='code --wait'


# 4. Node.js / Rust / Bun 等语言工具环境变量
# ============================================================================

# Volta：Node.js 版本管理器。
# 特点：
#   - 启动快
#   - 支持按项目自动切换 Node / npm / pnpm / yarn 版本
export VOLTA_HOME="$HOME/.volta"

# Rust：通过 rustup 安装时，默认目录为 ~/.cargo。
export RUST_HOME="$HOME/.cargo"

# Bun：JavaScript runtime / package manager / bundler。
export BUN_INSTALL="$HOME/.bun"

# Go：
# 如果通过官方安装包安装，可以按需取消注释。
# export GO_HOME='/usr/local/go'

# Groovy：
# 如果需要 Groovy，可以按需取消注释。
# export GROOVY_HOME='/opt/homebrew/opt/groovy/libexec'

# MySQL Client：
# 如果需要独立 MySQL 客户端，可以按需取消注释。
# export MYSQL_CLIENT_HOME='/opt/homebrew/opt/mysql-client@8.4'


# ============================================================================
# 5. PATH 配置
# ============================================================================

# zsh 原生数组 path 与 PATH 绑定。
#
# typeset -U 的作用：
#   - 自动去重
#   - 保留第一次出现的路径
#   - 避免 PATH 在多次启动 shell 后无限膨胀
typeset -U path PATH

# 安全追加 PATH 的辅助函数。
#
# 只在满足以下条件时才加入 PATH：
#   1. 参数非空
#   2. 目录真实存在
#
# 这样可以避免未定义变量导致奇怪路径进入 PATH。
_prepend_path() {
  [[ -n "$1" && -d "$1" ]] && path=("$1" $path)
}

# Homebrew 基础路径。
_prepend_path "/opt/homebrew/bin"
_prepend_path "/opt/homebrew/sbin"

# 各语言和工具路径。
#
# ${VAR:+...} 的含义：
#   只有 VAR 已定义且非空时，才展开后面的路径。
#
# 这可以避免：
#   "$GO_HOME/bin"
#
# 在 GO_HOME 未定义时错误展开成：
#   "/bin"
_prepend_path "${MYSQL_CLIENT_HOME:+$MYSQL_CLIENT_HOME/bin}"
_prepend_path "${RUST_HOME:+$RUST_HOME/bin}"
_prepend_path "${GO_HOME:+$GO_HOME/bin}"
_prepend_path "${VOLTA_HOME:+$VOLTA_HOME/bin}"
_prepend_path "${BUN_INSTALL:+$BUN_INSTALL/bin}"

# Antigravity CLI。
_prepend_path "$HOME/.antigravity/antigravity/bin"

# 清理辅助函数，避免污染 shell 环境。
unset -f _prepend_path

# 显式导出 PATH，供子进程继承。
export PATH


# ============================================================================
# 6. Homebrew 镜像源清理
# ============================================================================

# 如果之前配置过国内 Homebrew bottle 镜像源，
# 取消该变量可以恢复使用官方源。
unset HOMEBREW_BOTTLE_DOMAIN
