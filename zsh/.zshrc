
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# ============================================================================
# ~/.zshrc - Zsh Shell 配置文件
# 最后更新: 2026-04
# ============================================================================


# ============================================================================
# 0. 初始化和兼容性修复
# ============================================================================

# [FIX] 开启扩展通配符，确保 Section 0 的 24h 补全缓存判断生效
setopt EXTENDED_GLOB

# 加载 .zprofile（login shell 的环境变量，非 login shell 不会自动加载）
[[ -f ~/.zprofile ]] && source ~/.zprofile

# ── 补全系统初始化 ──────────────────────────────────────────────────────────
# [FIX] 添加 24h 缓存机制：
#   - compinit 每次都扫描 fpath 生成补全缓存，在插件多时较慢
#   - 检查 ~/.zcompdump 的修改时间，超过 24h 才重新生成，否则直接加载缓存
#   - 效果：启动时间可减少 100-300ms

# Docker 补全（如果目录存在才添加，避免 fpath 里出现无效路径）
# [FIX] 原来没有目录存在检查，Docker 未安装时会静默失败或报警告
[[ -d "${HOME}/.docker/completions" ]] && fpath=("${HOME}/.docker/completions" $fpath)

# 自定义补全目录（用于存放手动生成的静态补全文件，如 uv）
[[ -d "${HOME}/.zsh/completions" ]] && fpath=("${HOME}/.zsh/completions" $fpath)

# 按天缓存补全，24h 内直接加载缓存（-C），超过则重新生成
autoload -Uz compinit
if [[ -n "${ZDOTDIR:-$HOME}/.zcompdump"(#qN.mh-24) ]]; then
  compinit -C
else
  compinit
fi


# ============================================================================
# 1. 提示符和主题
# ============================================================================

# Starship：现代化、快速的跨 Shell 提示符
#   - 显示 Git 分支、语言版本、命令耗时、退出码等信息
#   - 启动耗时约 10-50ms，比 Oh-My-Zsh 快很多
#   - 配置文件：~/.config/starship.toml
#   - 安装：brew install starship
eval "$(starship init zsh)"


# ============================================================================
# 2. 历史记录配置
# ============================================================================

# 历史文件路径
HISTFILE="$HOME/.history"

# 内存中保留的历史条数
HISTSIZE=5000

# 写入磁盘的历史条数
SAVEHIST=5000

# 多终端窗口之间实时共享历史记录
# 效果：在一个窗口执行的命令，其他窗口按 Ctrl+R 可以立即找到
setopt SHARE_HISTORY

# 重复命令只保留最新一条（去重）
setopt HIST_IGNORE_ALL_DUPS

# 写入历史时忽略前导空格的命令（敏感命令前加空格可防止记录）
setopt HIST_IGNORE_SPACE


# ============================================================================
# 3. Shell 工具初始化
# ============================================================================

# ── fzf ─────────────────────────────────────────────────────────────────────
# 模糊搜索工具，增强以下快捷键：
#   Ctrl+R：模糊搜索命令历史
#   Ctrl+T：模糊搜索当前目录下的文件
#   Alt+C ：模糊搜索并跳转子目录
# 安装：brew install fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# ── zoxide ──────────────────────────────────────────────────────────────────
# 智能目录导航，记忆访问频率，比 autojump 更快
# 使用：z <目录关键词>（支持模糊匹配）
#       zi <关键词>（交互式选择，结合 fzf）
# 安装：brew install zoxide
eval "$(zoxide init zsh)"

# ── Yazi ────────────────────────────────────────────────────────────────────
# 现代 TUI 文件管理器，支持预览图片/视频/代码
# [FIX] 保留函数版本（退出 Yazi 后自动 cd 到最后浏览的目录）
#       删除了第 5 节重复的 `alias y='yazi'`，两者会冲突
# 使用：y（打开文件管理器，退出后自动跳转到最后访问的目录）
# 安装：brew install yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ── uv 补全 ─────────────────────────────────────────────────────────────────
# uv：统一的 Python 版本 + 包 + 环境管理器（pip/pyenv/virtualenv 的替代品）
# 安装：curl -LsSf https://astral.sh/uv/install.sh | sh
#
# [OPT] 原来每次启动都执行 eval "$(uv generate-shell-completion zsh)"，耗时较长
#       改为生成一次静态文件，之后 source 静态文件（compinit 会自动加载）
#
# 首次使用或 uv 升级后，执行以下命令重新生成：
#   mkdir -p ~/.zsh/completions && uv generate-shell-completion zsh > ~/.zsh/completions/_uv
#
# 如果 ~/.zsh/completions/_uv 不存在，则降级为动态生成（兼容首次安装）
if [[ ! -f "${HOME}/.zsh/completions/_uv" ]]; then
  eval "$(uv generate-shell-completion zsh 2>/dev/null)" || true
fi


# ============================================================================
# 4. 编辑器环境变量
# ============================================================================

# [ADD] 设置默认编辑器为 VS Code
# 以下工具会读取这些变量自动调用正确的编辑器：
#   - git commit（无 -m 时打开编辑器）
#   - kubectl edit
#   - crontab -e
#   - visudo
#   - 各类 CLI 工具
export EDITOR='code'
export VISUAL='code'   # 部分工具优先读取 VISUAL（GUI 场景），回退到 EDITOR


# ============================================================================
# 5. 别名 - 基础工具
# ============================================================================

# 清屏
alias c='clear'

# 文件操作（安全模式）
alias cp='cp -i'      # 覆盖前确认
alias mv='mv -i'      # 移动前确认

# [FIX] rm 不再直接删除，改为移入废纸篓
#   原来：alias rm='rm -rf'  ← 无法恢复，极其危险
#   现在：使用 trash 命令，文件进入 macOS 废纸篓，可从 Finder 恢复
#   安装：brew install trash
alias rm='trash'

# ── ls 替代品（eza）────────────────────────────────────────────────────────
# eza 是 exa 的维护分支，支持图标、Git 状态、超链接等
# 安装：brew install eza
alias ls='eza --hyperlink'         # 基础列表，路径显示为可点击超链接
alias ll='ls -l --icons'           # 详细列表 + 文件类型图标
alias l='ll'                       # 快捷方式
alias la='l -a'                    # 显示隐藏文件（. 开头）
alias lh='l -h'                    # 人类可读的文件大小（KB/MB）
alias lha='l -ha'                  # 隐藏文件 + 可读大小
alias lt='eza -T -L 2'            # 树状显示，最多展开 2 层

# 注意：y（Yazi 文件管理器）定义在第 3 节的函数中，此处不重复定义

# ============================================================================
# 6. 别名 - Git 工作流
# ============================================================================

# 基础操作
alias g='git'                           # Git 快捷方式
alias ginit='git init'                  # 初始化仓库
alias ga='git add'                      # 添加到暂存区
alias gadd='git add'                    # （同义词）
alias gs='git status -s'                # 简洁状态（短格式）
alias gc='git commit'                   # 提交（会打开 $EDITOR）
alias gcommit='git commit'              # （同义词）

# 查看差异
# [ADD] 新增查看 diff 的别名
alias gd='git diff'                     # 查看工作区的未暂存改动
alias gdc='git diff --cached'           # 查看已暂存（staged）的改动，提交前必看

# 日志和历史
alias gl="git log --color --graph --oneline --decorate"   # 带分支树的精简日志
alias gshow='git show'                  # 查看某次提交的详细改动

# 远程操作
alias gf='git fetch'                    # 获取远程数据（不合并）
alias gpull='git pull origin'           # 拉取当前分支的远程更新
alias gpush='git push origin'           # 推送当前分支到远程
alias gremote='git remote'              # 管理远程仓库（add/remove/show）
alias gclone='git clone'                # 克隆仓库

# 分支管理
alias gcheckout='git checkout'          # 切换分支或恢复文件
alias gbranch='git branch'              # 列出本地分支
alias gmerge='git merge'                # 合并分支
alias gt='git tag -a'                   # 创建带注释的标签

# [ADD] FZF 交互式切换分支（带预览）
# 执行后弹出分支列表，右侧实时预览该分支最新提交，回车确认切换
alias gcb="git branch | fzf --preview 'git show --color=always {-1}' | cut -c 3- | xargs git checkout"

# 撤销和回退
alias greset='git reset'                # 重置（默认 --mixed，保留工作区改动）
alias gcherry='git cherry-pick'         # 将指定提交应用到当前分支

# [ADD] 撤销最后一次提交，改动退回工作区（未 push 时的后悔药）
alias gundo='git reset HEAD~1'

# 暂存区管理（临时保存未完成的改动，切换分支时很有用）
alias gstash='git stash'                # 暂存当前改动
alias gpop='git stash pop'              # 恢复最近一次暂存

# [ADD] 快速保存当前工作进度（WIP = Work In Progress）
# 使用场景：需要临时切换分支处理紧急问题，但当前工作不想 stash
alias gwip='git add -A && git commit -m "WIP: work in progress"'


# ============================================================================
# 7. 别名 - Docker
# ============================================================================

alias d='docker'                        # Docker 快捷方式
alias dp='docker ps'                    # 列出运行中的容器
alias dpa='docker ps -a'                # 列出所有容器（包括已停止的）
alias de='docker exec -it'              # 进入容器交互模式（后跟容器名和 shell）
alias di='docker inspect'               # 查看容器/镜像的详细配置信息

# Lazydocker：Docker 的 TUI 管理界面，可查看日志、状态、资源占用
# 安装：brew install lazydocker
alias ld='lazydocker'


# ============================================================================
# 8. 别名 - Kubernetes
# ============================================================================

alias k='kubectl'                       # kubectl 快捷方式（高频使用）

# 切换当前上下文的默认命名空间
# 使用：kcd <namespace>
alias kcd='kubectl config set-context $(kubectl config current-context) --namespace'

# Pod 管理
alias kp='kubectl get pods'             # 列出当前命名空间的 Pod
alias kl='kubectl logs'                 # 查看 Pod 日志
alias klf='kubectl logs -f --tail=100'  # 实时追踪日志（最后 100 行起）
alias kd='kubectl describe pod'         # 查看 Pod 详细信息（排查问题常用）
alias ke='kubectl exec -it'             # 进入 Pod 的交互式 Shell


# ============================================================================
# 9. 别名 - 开发工具
# ============================================================================

# 编辑器（使用 Neovim 替代系统 Vim）
alias vim='nvim'
alias v='nvim'

# Git TUI（Lazygit：键盘驱动的 Git 图形界面）
# 安装：brew install lazygit
alias lg='lazygit'

# 剪贴板（将命令输出复制到剪贴板）
# 用法：cat file.txt | pb
alias pb='pbcopy'

# Tmux 会话管理
# 安装：brew install tmux
alias tnew='tmux new -s'                # 创建新命名会话：tnew <name>
alias ta='tmux a -t'                    # 附加到已有会话：ta <name>

# Homebrew 全量更新（更新索引 + 升级所有包 + 清理旧版本和缓存）
alias brew14all='brew update && brew upgrade && brew cleanup --prune=all && command rm -rf "$(brew --cache)"/*'

# Claude Code
alias cc='claude'
alias cds="claude --dangerously-skip-permissions"

# Codex
alias cx='codex'


# ============================================================================
# 10. 环境变量 - Java 和 JVM 工具
# ============================================================================

# Maven：Java 项目构建工具
export M2_HOME='/opt/homebrew/opt/maven'

# [FIX] Java 多版本路径改为动态查询
#   原来：硬编码 jdk1.8.0_361.jdk，升级 JDK 小版本后路径失效
#   现在：通过 macOS 内置的 java_home 工具按主版本号查找，自动适配升级
#   /usr/libexec/java_home -v <version> 返回对应 JDK 的 Home 路径
export JDK8_HOME=$(/usr/libexec/java_home -v 1.8 2>/dev/null)
export JDK11_HOME=$(/usr/libexec/java_home -v 11 2>/dev/null)
export JDK17_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null)

# 默认使用 JDK 17
export JAVA_HOME=$JDK17_HOME

# Java 版本快速切换（切换后立即打印版本号确认）
alias jdk8='export JAVA_HOME=$JDK8_HOME && java -version'
alias jdk11='export JAVA_HOME=$JDK11_HOME && java -version'
alias jdk17='export JAVA_HOME=$JDK17_HOME && java -version'


# ============================================================================
# 11. 环境变量 - Node.js（Volta）
# ============================================================================

# Volta：比 NVM 更快的 Node.js 版本管理器
#   特点：按项目自动切换版本（读取 package.json 中的 volta 字段）
#         不需要手动 nvm use，切换零感知
# 安装：https://docs.volta.sh/guide/getting-started
# [FIX] 替换硬编码路径为 $HOME
export VOLTA_HOME="$HOME/.volta"


# ============================================================================
# 12. 其他编程语言（按需取消注释）
# ============================================================================

# Go
# export GO_HOME='/usr/local/go'

# Rust（通过 rustup 安装）
# export RUST_HOME="$HOME/.cargo"

# Groovy
# export GROOVY_HOME='/opt/homebrew/opt/groovy/libexec'


# ============================================================================
# 13. 数据库工具（按需取消注释）
# ============================================================================

# MySQL Client 8.4
# export MYSQL_CLIENT_HOME='/opt/homebrew/opt/mysql-client@8.4'

# MySQL 命令行提示符格式：username@hostname [database]>
# export MYSQL_PS1="\u@\h [\d]> "


# ============================================================================
# 14. PATH 配置
# ============================================================================

# ── Homebrew ─────────────────────────────────────────────────────────────────
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# ── 按需追加 PATH 的辅助函数 ─────────────────────────────────────────────────
# [FIX] 原来把所有工具路径拼成一条长 PATH，其中引用了未定义的变量
#       （GO_HOME、RUST_HOME 等被注释掉了，但 PATH 里仍然引用它们）
#       未定义变量展开为空字符串，导致 PATH 里出现裸 :/bin，有安全隐患
#
#       改为：只在目录真实存在时才追加，避免无效路径污染 PATH
_prepend_path() {
  [[ -n "$1" && -d "$1" ]] && export PATH="$1:$PATH"
}

# 各工具 bin 路径（按优先级从低到高追加，后追加的优先级更高）
_prepend_path "$MYSQL_CLIENT_HOME/bin"   # MySQL Client（如未定义则跳过）
_prepend_path "$RUST_HOME/bin"           # Rust cargo（如未定义则跳过）
_prepend_path "$GO_HOME/bin"             # Go（如未定义则跳过）
_prepend_path "$JAVA_HOME/bin"           # Java（已定义）
_prepend_path "$M2_HOME/bin"             # Maven（已定义）
_prepend_path "$VOLTA_HOME/bin"          # Volta Node.js（已定义，优先级最高）

# 清理辅助函数（避免污染 Shell 环境）
unset -f _prepend_path

# ============================================================================
# 15. 网络代理（按需取消注释）
# ============================================================================

# ClashX / Clash Verge 本地代理（需要代理软件在后台运行）
# 启用代理
# alias pon='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890'
# 禁用代理
# alias poff='unset https_proxy; unset http_proxy; unset all_proxy'


# ============================================================================
# 16. 清理和最后的初始化
# ============================================================================

# 取消 Homebrew 镜像源设置（如果之前配置过国内镜像，换回官方源时取消此行注释）
unset HOMEBREW_BOTTLE_DOMAIN

# Bun 配置 (已去重) 
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# Added by Antigravity
export PATH="/Users/jackdaw/.antigravity/antigravity/bin:$PATH"

# ============================================================================
#
# 【维护备忘】
#   uv 补全首次生成（或 uv 升级后重新生成）：
#     mkdir -p ~/.zsh/completions && uv generate-shell-completion zsh > ~/.zsh/completions/_uv
#
#   compinit 缓存失效强制刷新：
#     rm -f ~/.zcompdump && exec zsh
#
#   测量 Shell 启动时间：
#     time zsh -i -c exit
# ============================================================================


# ── zsh-syntax-highlighting ─────────────────────────────────────────────────
# 实时命令着色：合法命令绿色，未知命令红色，参数高亮
# 安装：brew install zsh-syntax-highlighting
[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
