# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# ============================================================================
# ~/.zshrc - Zsh 统一配置文件
# 最后更新: 2026-05
# ============================================================================
#
# 所有 shell 配置统一在此文件管理，不再拆分 .zprofile。
#
# 结构：
#   第一部分 — 环境变量与 PATH
#   第二部分 — 交互式 Shell 配置（补全、prompt、alias、工具）
#
# 不适合放这里的：
#   - 非交互式场景也需要的变量（如 scp、rsync）→ 放 ~/.zshenv
#
# 注意：
#   不再维护 .zprofile，避免两份配置的同步负担。
# ============================================================================


# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                    第一部分：环境变量与 PATH                              ║
# ╚═══════════════════════════════════════════════════════════════════════════╝


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


# ============================================================================
# 4. 语言和工具环境变量
# ============================================================================

# Maven：独立安装，不依赖 Homebrew 的 OpenJDK formula。
export M2_HOME="$HOME/Library/Maven/apache-maven-3.9.15"

# Gradle：独立安装，不依赖 Homebrew 的 OpenJDK formula。
export GRADLE_HOME="$HOME/Library/Gradle/gradle-9.5.1"

# Go：如果通过官方安装包安装，可以按需取消注释。
# export GO_HOME='/usr/local/go'

# Groovy：如果需要 Groovy，可以按需取消注释。
# export GROOVY_HOME='/opt/homebrew/opt/groovy/libexec'

# MySQL Client：如果需要独立 MySQL 客户端，可以按需取消注释。
# export MYSQL_CLIENT_HOME='/opt/homebrew/opt/mysql-client@8.4'

# Java：默认使用本机已安装的 Java 21 LTS。
if [[ -x /usr/libexec/java_home ]]; then
  _java_home_21="$(/usr/libexec/java_home -v 21 2>/dev/null)"
  [[ -n "$_java_home_21" ]] && export JAVA_HOME="$_java_home_21"
  unset _java_home_21
fi


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
_prepend_path "${JAVA_HOME:+$JAVA_HOME/bin}"
_prepend_path "${M2_HOME:+$M2_HOME/bin}"
_prepend_path "${GRADLE_HOME:+$GRADLE_HOME/bin}"
_prepend_path "${GO_HOME:+$GO_HOME/bin}"

# uv（Python 版本 + 包管理）。
_prepend_path "$HOME/.local/bin"

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


# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                    第二部分：交互式 Shell 配置                            ║
# ╚═══════════════════════════════════════════════════════════════════════════╝


# ============================================================================
# 7. 初始化和兼容性修复
# ============================================================================

# 开启扩展通配符。
#
# 用途：
#   允许使用 zsh 的高级 glob qualifier。
#
# 这里会用于 .zcompdump 的 24 小时缓存判断：
#   "${ZDOTDIR:-$HOME}/.zcompdump"(#qN.mh-24)
setopt EXTENDED_GLOB

# zsh 原生数组去重。
#
# path  与 PATH  绑定。
# fpath 与补全函数搜索路径相关。
#
# typeset -U 可以避免重复路径不断累积。
typeset -U path PATH fpath


# ============================================================================
# 8. 补全系统
# ============================================================================

# Docker 补全目录。
#
# 只有目录真实存在时才加入 fpath，
# 避免 Docker 未安装或路径不存在时污染补全搜索路径。
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)

# 自定义补全目录。
#
# 可用于存放手动生成的静态补全文件，例如：
#   - uv
#   - 自定义 CLI
#   - 内部工具
[[ -d "$HOME/.zsh/completions" ]] && fpath=("$HOME/.zsh/completions" $fpath)

# uv 补全文件缓存。
#
# 如果 uv 已安装，但补全文件不存在，则生成一次静态补全文件。
#
# 好处：
#   - 避免每次启动 shell 都 eval 动态补全
#   - 启动更快
#   - 补全行为更稳定
if command -v uv >/dev/null 2>&1 && [[ ! -f "$HOME/.zsh/completions/_uv" ]]; then
  mkdir -p "$HOME/.zsh/completions"
  uv generate-shell-completion zsh > "$HOME/.zsh/completions/_uv"
fi

# 初始化 zsh 补全系统。
#
# compinit -C：
#   使用已有缓存，不重新安全检查补全文件。
#
# 逻辑：
#   - 如果 .zcompdump 在 24 小时内更新过，使用缓存
#   - 否则重新初始化补全系统
autoload -Uz compinit
if [[ -n "${ZDOTDIR:-$HOME}/.zcompdump"(#qN.mh-24) ]]; then
  compinit -C
else
  compinit
fi


# ============================================================================
# 9. 提示符和主题
# ============================================================================

# Starship：现代化、快速的跨 shell prompt。
#
# 配置文件：
#   ~/.config/starship.toml
#
# 安装：
#   brew install starship
#
# 加 command -v 判断，避免未安装时启动 shell 报错。
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"


# ============================================================================
# 10. 历史记录配置
# ============================================================================

# 历史文件路径。
HISTFILE="$HOME/.history"

# 内存中保留的历史条数。
HISTSIZE=5000

# 写入磁盘的历史条数。
SAVEHIST=5000

# 记录命令执行时间戳和耗时。
setopt EXTENDED_HISTORY

# 追加写入历史文件，而不是覆盖。
setopt APPEND_HISTORY

# 命令执行后立即写入历史文件。
setopt INC_APPEND_HISTORY

# 多终端窗口共享历史记录。
#
# 效果：
#   一个窗口执行的命令，其他窗口可以较快通过历史搜索找到。
setopt SHARE_HISTORY

# 重复命令只保留最新一条。
setopt HIST_IGNORE_ALL_DUPS

# 保存历史时去重。
setopt HIST_SAVE_NO_DUPS

# 历史记录中压缩多余空格。
setopt HIST_REDUCE_BLANKS

# 忽略以空格开头的命令。
#
# 用途：
#   执行敏感命令时，可以在命令前加一个空格，避免写入历史。
setopt HIST_IGNORE_SPACE

# 对历史展开结果先展示确认，而不是直接执行。
#
# 例如：
#   !!
#
# 会先展开成上一条命令，确认后再执行。
setopt HIST_VERIFY


# ============================================================================
# 11. Shell 工具初始化
# ============================================================================

# ── fzf ─────────────────────────────────────────────────────────────────────
#
# fzf：模糊搜索工具。
#
# 常用快捷键：
#   Ctrl+R：模糊搜索历史命令
#   Ctrl+T：模糊搜索当前目录下的文件
#   Alt+C ：模糊搜索并跳转目录
#
# 安装：
#   brew install fzf
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"


# ── Yazi ────────────────────────────────────────────────────────────────────
#
# yazi：现代 TUI 文件管理器。
#
# 函数 y 的作用：
#   - 打开 yazi
#   - 退出 yazi 后自动 cd 到最后访问的目录
#
# 安装：
#   brew install yazi
y() {
  local tmp cwd

  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"

  if cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi

  rm -f -- "$tmp"
}


# ============================================================================
# 12. 编辑器快捷方式
# ============================================================================

# 使用 Neovim 替代系统 Vim。
#
# 安装：
#   brew install neovim
alias vim='nvim'
alias v='nvim'


# ============================================================================
# 13. 别名 - 基础工具
# ============================================================================

# 清屏。
alias c='clear'

# 文件操作安全模式。
#
# cp -i：
#   覆盖文件前确认。
#
# mv -i：
#   覆盖目标前确认。
alias cp='cp -i'
alias mv='mv -i'

# rm 安全替代。
#
# 优先使用 trash，把文件移入 macOS 废纸篓。
# 如果未安装 trash，则退回 rm -i，删除前确认。
#
# 安装 trash：
#   brew install trash
if command -v trash >/dev/null 2>&1; then
  alias rm='trash'
else
  alias rm='rm -i'
fi


# ============================================================================
# 14. 别名 - ls 替代品
# ============================================================================

# eza：exa 的维护分支。
#
# 特点：
#   - 支持图标
#   - 支持 Git 状态
#   - 支持超链接
#   - 输出更现代
#
# 安装：
#   brew install eza
#
# 如果 eza 未安装，则保留系统 ls，避免 alias 指向不存在的命令。
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --hyperlink'
  alias ll='ls -l --icons'
  alias l='ll'
  alias la='l -a'
  alias lh='l -h'
  alias lha='l -ha'
  alias lt='eza -T -L 2'
else
  alias ll='ls -l'
  alias l='ll'
  alias la='ls -la'
  alias lh='ls -lh'
  alias lha='ls -lha'
fi


# ============================================================================
# 15. 别名 - Git 工作流
# ============================================================================

# 基础操作。
alias g='git'
alias ginit='git init'
alias ga='git add'
alias gadd='git add'
alias gs='git status -s'
alias gc='git commit'
alias gcommit='git commit'

# 查看差异。
alias gd='git diff'
alias gdc='git diff --cached'

# 日志和历史。
alias gl='git log --color --graph --oneline --decorate'
alias gshow='git show'

# 远程操作。
alias gf='git fetch'
alias gpull='git pull origin'
alias gpush='git push origin'
alias gremote='git remote'
alias gclone='git clone'

# 分支管理。
alias gcheckout='git checkout'
alias gbranch='git branch'
alias gmerge='git merge'
alias gt='git tag -a'

# FZF 交互式切换分支。
#
# 作用：
#   - 列出本地分支
#   - 用 fzf 选择目标分支
#   - 右侧预览该分支最近一次提交
#   - 回车后 checkout
#
# 写成函数比 alias 更稳：
#   - 更容易处理空选择
#   - 更容易扩展
#   - 引号行为更安全
gcb() {
  local branch

  branch=$(
    git branch --format='%(refname:short)' |
      fzf --preview 'git log -1 --color=always --decorate --stat {}'
  ) || return

  git checkout "$branch"
}

# 撤销和回退。
alias greset='git reset'
alias gcherry='git cherry-pick'

# 撤销最后一次提交。
#
# 注意：
#   该命令会撤销 commit，但保留工作区改动。
#   适合未 push 前修改最后一次提交。
alias gundo='git reset HEAD~1'

# 暂存区管理。
alias gstash='git stash'
alias gpop='git stash pop'

# 快速保存当前工作进度。
#
# 注意：
#   这会真的创建一个 commit。
#   如果团队不希望出现 WIP commit，使用前需要确认工作流。
alias gwip='git add -A && git commit -m "WIP: work in progress"'


# ============================================================================
# 16. 别名 - Docker
# ============================================================================

# Docker 快捷方式。
alias d='docker'

# 列出运行中的容器。
alias dp='docker ps'

# 列出所有容器，包括已停止容器。
alias dpa='docker ps -a'

# 进入容器交互模式。
#
# 用法：
#   de <container> <command>
#
# 示例：
#   de my-container bash
alias de='docker exec -it'

# 查看容器或镜像详细信息。
alias di='docker inspect'

# Lazydocker：Docker TUI 管理工具。
#
# 安装：
#   brew install lazydocker
alias ld='lazydocker'


# ============================================================================
# 17. 别名 - Kubernetes
# ============================================================================

# kubectl 快捷方式。
alias k='kubectl'

# 切换当前 context 的默认 namespace。
#
# 用法：
#   kcd <namespace>
alias kcd='kubectl config set-context $(kubectl config current-context) --namespace'

# Pod 管理。
alias kp='kubectl get pods'
alias kl='kubectl logs'
alias klf='kubectl logs -f --tail=100'
alias kd='kubectl describe pod'
alias ke='kubectl exec -it'


# ============================================================================
# 18. 别名 - 开发工具
# ============================================================================

# Lazygit：Git TUI 工具。
#
# 安装：
#   brew install lazygit
alias lg='lazygit'

# 剪贴板。
#
# 用法：
#   cat file.txt | pb
alias pb='pbcopy'

# Tmux 会话管理。
#
# 安装：
#   brew install tmux
alias tnew='tmux new -s'
alias ta='tmux a -t'

# Homebrew 全量更新。
#
# 包含：
#   - 更新 Homebrew 索引
#   - 升级所有包
#   - 清理旧版本
#   - 清理下载缓存
alias brew14all='brew update && brew upgrade && brew cleanup --prune=all && command rm -rf "$(brew --cache)"/*'

# Claude Code。
alias cc='claude --dangerously-skip-permissions'

# Codex。
alias cx='codex'


# 19. 网络代理
# ============================================================================

# ClashX / Clash Verge 本地代理。
#
# 需要代理软件在后台运行。
#
# 启用代理：
# alias pon='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890'
#
# 禁用代理：
# alias poff='unset https_proxy; unset http_proxy; unset all_proxy'


# ============================================================================
# 20. zoxide
# ============================================================================

# zoxide：智能目录导航工具。
#
# 用法：
#   z <目录关键词>
#   zi <目录关键词>
#
# 安装：
#   brew install zoxide
#
# 加 command -v 判断，避免未安装时报错。
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"


# ============================================================================
# 21. zsh-syntax-highlighting
# ============================================================================

# zsh-syntax-highlighting：实时命令着色。
#
# 效果：
#   - 合法命令高亮
#   - 未知命令提示
#   - 参数和路径着色
# 安装：
#   brew install zsh-syntax-highlighting
#
[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
