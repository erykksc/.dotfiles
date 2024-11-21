eval "$(starship init zsh)"

export LANG=en_US.UTF-8
export EDITOR='nvim'
export MANPAGER="nvim +Man!"

alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias vc='nvim .'

alias y='yazi'
alias sgpt='python3 -m sgpt'
alias s='~/.dotfiles/scripts/tmux-client.sh'
alias monitor='~/.dotfiles/scripts/monitor.sh'

# GIT ALIASES
alias gs='git status'
alias gc='git commit'
alias gdv='git diff | vim'
alias ga='git add'
alias gaa='git add .'
alias tupdate='~/.dotfiles/scripts/theme-update.sh'
alias ls='eza --icons=auto'

bindkey -e

# FZF
eval "$(fzf --zsh)"
# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_CTRL_T_OPTS="--bind 'ctrl-d:reload(fd --type d --hidden --strip-cwd-prefix),ctrl-f:reload(eval $FZF_CTRL_T_COMMAND)'"
export FZF_ALT_C_COMMAND="fd --type d --hidden ."

# Enable completions
fpath=(/opt/homebrew/share/zsh/site-functions $HOME/.nix-profile/share/zsh/site-functions $fpath)
autoload -Uz compinit
compinit

# ZSH PLUGINS
if [[ "$OSTYPE" == "darwin"* ]]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
