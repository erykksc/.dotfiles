export XDG_CONFIG_HOME="$HOME/.config"
export PATH=$HOME/go/bin:$PATH

eval "$(starship init zsh)"

export LANG=en_US.UTF-8
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias vc='nvim .'

alias gs='git status'
alias gdv='git diff | vim'
alias tupdate='~/.dotfiles/scripts/theme-update.sh'
alias sp='spotify_player'
alias ls='eza'

bindkey -v
export KEYTIMEOUT=1


# FZF
# Setup fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"
# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_ALT_C_COMMAND="fd --type d --hidden ."

# Enable completions
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit
compinit

bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line

# Enable syntax highlighting, should be kept at the end of the file
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
