# ============================================================================
# 0. 初始化和兼容性修复
##
# ============================================================================

[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && \
  builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

if [[ "$TERM_PROGRAM" == "vscode" || "$TERM_PROGRAM" == "cursor" ]]; then
  return
fi

[[ -f ~/.zprofile ]] && source ~/.zprofile

# ── 提前初始化补全系统，避免 compdef not found ──
fpath=(/Users/jackdaw/.docker/completions $fpath)
autoload -Uz compinit
compinit

# ============================================================================
# 1. 提示符和主题
# ============================================================================

# Starship: 现代化、快速的提示符替代品
# 优点: 启动快 (10-50ms)，支持跨 Shell，配置清晰
# 配置文件: ~/.config/starship.toml
eval "$(starship init zsh)"

# ============================================================================
# 2. 历史记录配置
# ============================================================================

# 历史文件存储位置
HISTFILE=$HOME/.history

# 跨终端共享历史记录 (多个 Tab 自动同步)
setopt SHARE_HISTORY

# 历史记录大小
HISTSIZE=50000
SAVEHIST=50000

# ============================================================================
# 3. Shell 工具初始化
# ============================================================================

# zsh-syntax-highlighting: 实时命令着色
# 安装: brew install zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# autojump: 快速目录跳转 (学习常用目录)
# 安装: brew install autojump
# 使用: j <目录名>
# [[ -f /opt/homebrew/etc/profile.d/autojump.sh ]] && . /opt/homebrew/etc/profile.d/autojump.sh

# fzf: 模糊查找工具 (Ctrl+R 搜索历史、Ctrl+T 搜索文件)
# 安装: brew install fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# zoxide: 智能目录导航，比 autojump 更快
# 安装: brew install zoxide
# 使用: z <目录> 或 z <query>
eval "$(zoxide init zsh)"

# Yazi: 现代 TUI 文件管理器集成
# 安装: brew install yazi
# 使用: y 打开文件管理器
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ============================================================================
# 4. Python 环境管理
# ============================================================================

# uv: 统一的 Python 版本 + 包 + 环境管理器
# 安装: curl -LsSf https://astral.sh/uv/install.sh | sh
eval "$(uv generate-shell-completion zsh 2>/dev/null)" || true

# ============================================================================
# 5. 别名 - 基础工具
# ============================================================================

# 清屏
alias c='clear'

# 文件操作 (安全模式: 确认覆盖)
alias cp='cp -i'     # 复制时确认
alias mv='mv -i'     # 移动时确认
alias rm='rm -rf'    # 删除目录和文件

# ls 别名 (使用 eza 替代传统 ls)
# 安装: brew install eza
alias ls='eza --hyperlink'              # 基础列表
alias ll='ls -l --icons'                # 详细列表 + 图标
alias l='ll'                            # 快捷方式
alias la='l -a'                         # 显示隐藏文件
alias lh='l -h'                         # 人类可读大小
alias lha='l -ha'                       # 隐藏文件 + 大小
alias lt='eza -T -L 2'                 # 树状显示

# 文件管理器
alias y='yazi'                         # 打开 Yazi 文件管理器

# ============================================================================
# 6. 别名 - Git 工作流
# ============================================================================

# 基础 Git 命令
alias g='git'                           # Git 快捷方式
alias ginit='git init'                  # 初始化仓库
alias ga='git add'                      # 添加文件
alias gadd='git add'                    # (同义词)
alias gs='git status -s'                # 简洁状态显示
alias gc='git commit'                   # 提交更改
alias gcommit='git commit'              # (同义词)

# Git 日志和历史
alias gl="git log --color --graph"      # 带分支树的日志
alias gt='git tag -a'                   # 创建带注释的标签

# Git 远程操作
alias gf='git fetch'                    # 获取远程数据
alias gpull='git pull origin'           # 拉取当前分支
alias gpush='git push origin'           # 推送当前分支
alias gremote='git remote'              # 管理远程仓库

# Git 分支管理
alias gcheckout='git checkout'          # 切换分支
alias gbranch='git branch'              # 列出分支
# FZF 交互式选择分支并切换
alias gcb="git branch | fzf --preview 'git show --color=always {-1}' | cut -c 3- | xargs git checkout"

# Git 提交和历史
alias gshow='git show'                  # 查看提交详情
alias greset='git reset'                # 重置提交
alias gmerge='git merge'                # 合并分支
alias gcherry='git cherry-pick'         # 精选提交到当前分支
alias gclone='git clone'                # 克隆仓库

# Git 暂存区
alias gstash='git stash'                # 暂存未提交的改动
alias gpop='git stash pop'              # 恢复暂存的改动

# ============================================================================
# 7. 别名 - Docker
# ============================================================================

# 基础 Docker 命令
alias d='docker'                        # Docker 快捷方式
alias dp='docker ps'                    # 列出运行中的容器
alias dpa='docker ps -a'                # 列出所有容器
alias de='docker exec -it'              # 进入容器交互模式
alias di='docker inspect'               # 查看容器详细信息

# Docker 图形工具
# 安装: brew install lazydocker
alias ld='lazydocker'                   # 启动 Lazydocker TUI

# ============================================================================
# 8. 别名 - Kubernetes
# ============================================================================

# Kubernetes 基础命令
alias k='kubectl'                       # kubectl 快捷方式

# 切换命名空间 (更改当前上下文的默认命名空间)
alias kcd='kubectl config set-context $(kubectl config current-context) --namespace'

# Pod 管理
alias kp='kubectl get pods'             # 获取 Pod 列表
alias kl='kubectl logs'                 # 查看 Pod 日志
alias klf='kubectl logs -f --tail=100'  # 实时日志 (最后 100 行)
alias kd='kubectl describe pod'         # 查看 Pod 详细信息
alias ke='kubectl exec -it'             # 进入 Pod 交互模式

# ============================================================================
# 9. 别名 - 开发工具
# ============================================================================

# 编辑器
alias vim='nvim'                        # 使用 Neovim 替代 Vim
alias v='nvim'                          # Neovim 快捷方式

# Git 图形工具
# 安装: brew install lazygit
alias lg='lazygit'                      # 启动 Lazygit (Git TUI)

# SSH 管理
# 安装: brew install lazyssh
# alias s='lazyssh'                       # 启动 Lazyssh (SSH 连接管理)

# AI 和 LLM
# 安装: brew install ollama
# alias o='ollama'                        # Ollama (本地大语言模型)

# 媒体播放
# 安装: brew install musicfox
# alias m='musicfox'                      # Musicfox (网易云音乐 TUI)

# 数据库工具
# alias sp='sql-param'                    # SQL 参数处理工具

# 文本处理
# macOS 需要: brew install gnu-sed
# alias sed='gsed'                        # 使用 GNU sed 替代 BSD sed

# 剪贴板
alias pb='pbcopy'                       # 复制到剪贴板

# Tmux 会话管理
# 安装: brew install tmux
alias tnew='tmux new -s'                # 创建新 Tmux 会话
alias ta='tmux a -t'                    # 附加到现有会话

# Homebrew 包管理
# 更新所有包、清理缓存
alias brew14all='brew update && brew upgrade && brew cleanup --prune=all && rm -rf $(brew --cache)'

# ============================================================================
# 10. 别名 - 网络代理
# ============================================================================

# ClashX 本地代理 (需要 ClashX 运行在后台)
# 启用代理
# alias pon='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890'

# 禁用代理
# alias poff='unset https_proxy; unset http_proxy; unset all_proxy;'

# ============================================================================
# 11. 环境变量 - Java 和 JVM 工具
# ============================================================================

# Maven: Java 项目构建工具
export M2_HOME='/opt/homebrew/opt/maven'

# Java: 多个版本管理
# 支持 JDK 8, 11, 17 多个版本，通过别名快速切换
export JDK8_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_361.jdk/Contents/Home'
export JDK11_HOME='/Library/Java/JavaVirtualMachines/jdk-11.jdk/Contents/Home'
export JDK17_HOME='/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home'

# 默认使用 JDK 17
export JAVA_HOME=$JDK17_HOME

# Java 版本快速切换别名
alias jdk8='export JAVA_HOME=$JDK8_HOME && java -version'
alias jdk11='export JAVA_HOME=$JDK11_HOME && java -version'
alias jdk17='export JAVA_HOME=$JDK17_HOME && java -version'

# ============================================================================
# 12. 环境变量 - 其他编程语言
# ============================================================================

# Go: 编程语言
# export GO_HOME='/usr/local/go'

# Rust: 系统编程语言
# 通过 rustup 安装: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# export RUST_HOME='/Users/jackdaw/.cargo'

# Groovy: JVM 脚本语言
# export GROOVY_HOME='/opt/homebrew/opt/groovy/libexec'

# ============================================================================
# 13. 环境变量 - 数据库
# ============================================================================

# MySQL Client: 数据库客户端工具
# export MYSQL_CLIENT_HOME='/opt/homebrew/opt/mysql-client@8.4'

# MySQL 命令提示符格式
# 格式: username@hostname [database]> 
# export MYSQL_PS1="\u@\h [\d]> "

# ============================================================================
# 14. 环境变量 - Node.js
# ============================================================================

# NVM: Node Version Manager (Node.js 版本管理)
# 安装: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Volta: 更快的 Node.js 版本切换 (推荐)
# 安装: https://docs.volta.sh/guide/getting-started
# 特点: 自动管理项目所需的 Node/npm/yarn 版本
export VOLTA_HOME='/Users/jackdaw/.volta'

# ============================================================================
# 15. 环境变量 - 其他工具
# ============================================================================

# tldr: 简化的 man 文档工具
# 禁用自动更新检查 (可选)
# export TLDR_AUTO_UPDATE_DISABLED=1

# Antigravity: 自定义工具
# export PATH="/Users/jackdaw/.antigravity/antigravity/bin:$PATH"

# InfluxDB: 时序数据库工具
# export PATH="/Users/jackdaw/.influxdb/:$PATH"

# ============================================================================
# 16. PATH 配置
# ============================================================================

# Homebrew (macOS 包管理器)
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# 开发工具 PATH 组合
# 注意: 路径的顺序很重要，前面的路径优先级更高
export PATH=$VOLTA_HOME/bin:$PATH:$M2_HOME/bin:$JAVA_HOME/bin:$GO_HOME/bin:$RUST_HOME/bin:$MYSQL_CLIENT_HOME/bin

# ============================================================================
# 17. Shell 补全配置
# ============================================================================


# ============================================================================
# 18. 清理和最后的初始化
# ============================================================================

# 取消设置 Homebrew 镜像 (如果之前设置过)
unset HOMEBREW_BOTTLE_DOMAIN

# OpenClaw 补全 (可选，如果已安装)
# [[ -f "/Users/jackdaw/.openclaw/completions/openclaw.zsh" ]] && \
#  source "/Users/jackdaw/.openclaw/completions/openclaw.zsh"

# Kiro CLI 后置块 (保持在文件底部)
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && \
  builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

# ============================================================================
# 文件结束
# ============================================================================
