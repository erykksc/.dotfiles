export XDG_CONFIG_HOME="$HOME/.config"
export JAVA_HOME=$(/opt/homebrew/bin/brew --prefix openjdk)/libexec/openjdk.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$HOME/go/bin:$PATH

eval "$(starship init zsh)"

export LANG=en_US.UTF-8
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias vc='nvim .'

alias y='yazi'

# GIT ALIASES
alias gs='git status'
alias gc='git commit'
alias gdv='git diff | vim'
alias ga='git add'
alias gaa='git add .'
alias tupdate='~/.dotfiles/scripts/theme-update.sh'
alias ls='eza'

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


# Set initial cursor shape
echo -ne '\e[6 q'
# FZF
# Setup fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"
# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_ALT_C_COMMAND="fd --type d --hidden ."
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

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
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
