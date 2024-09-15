eval "$(starship init zsh)"

export LANG=en_US.UTF-8
export EDITOR='nvim'

export MANPAGER="nvim +Man!"

alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
alias funshell='nix-shell --command zsh -p pipes-rs asciiquarium cmatrix cowsay fortune sl figlet htop cbonsai'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias vc='nvim .'

alias y='yazi'

alias s='~/.dotfiles/scripts/tmux-client.sh'

# GIT ALIASES
alias gs='git status'
alias gc='git commit'
alias gdv='git diff | vim'
alias ga='git add'
alias gaa='git add .'
alias tupdate='~/.dotfiles/scripts/theme-update.sh'
alias ls='eza --icons=auto'

# CONFIGURE Vi-Mode
bindkey -v
export KEYTIMEOUT=1
function zle-keymap-select {
  case $KEYMAP in
    vicmd) echo -ne '\e[1 q' ;; # Block cursor
    main|viins) echo -ne '\e[6 q' ;; # Vertical bar cursor
  esac
}

function zle-line-init {
  echo -ne '\e[6 q' # Set to vertical bar initially
}

zle -N zle-keymap-select
zle -N zle-line-init

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

bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line

# ZSH PLUGINS
if [[ "$OSTYPE" == "darwin"* ]]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
