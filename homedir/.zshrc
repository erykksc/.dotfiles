eval "$(starship init zsh)"

export LANG=en_US.UTF-8
export EDITOR='nvim'
export MANPAGER="nvim +Man!"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

alias bh='bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

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
alias gl='git log'
alias ga='git add'
alias gaa='git add .'
alias tupdate='~/.dotfiles/scripts/theme-update.sh'
alias ls='eza --icons=auto'

# KEYBINDINGS
bindkey -e

# HISTORY
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups

# FZF
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_CTRL_T_OPTS="--bind 'ctrl-d:reload(fd --type d --hidden --strip-cwd-prefix),ctrl-f:reload(eval $FZF_CTRL_T_COMMAND)'"
export FZF_ALT_C_COMMAND="fd --type d --hidden ."

# Enable completions
fpath=(
    /opt/homebrew/share/zsh/site-functions
    /usr/share/zsh/site-functions
    /usr/local/share/zsh/site-functions
    $fpath
)
autoload -Uz compinit
compinit

# PLUGINS
ZPLUGINDIR=${XDG_DATA_HOME:-$HOME/.local/share}/zsh-plugins
mkdir -p $ZPLUGINDIR

# zsh-autosuggestions
if [[ ! -d $ZPLUGINDIR/zsh-autosuggestions ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
            $ZPLUGINDIR/zsh-autosuggestions
fi
source $ZPLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

# zsh-syntax-highlighting
if [[ ! -d $ZPLUGINDIR/zsh-syntax-highlighting ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
            $ZPLUGINDIR/zsh-syntax-highlighting
fi
source $ZPLUGINDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
