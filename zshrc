export ZSH=~/.oh-my-zsh

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/zcompdump"

DISABLE_AUTO_UPDATE=true
zstyle ':completion:*' rehash true

autoload -Uz compinit
compinit -C

eval "$(/opt/homebrew/bin/brew shellenv)"

zstyle ':omz:update' mode disabled

eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

fpath=(/usr/local/share/zsh/site-functions $fpath)
plugins=(alias-finder fzf-tab zoxide sudo git kubectl)

export PATH="$PATH:~/.local/bin"
source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='nvim'
else
	export EDITOR='vim'
fi

eval "$(fzf --zsh)"

export LC_ALL=en_US.UTF-8
export KEYTIMEOUT=1

### Golang settings
export GOPATH=$HOME/golang
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

### Golang utils
function go_coverage() {
	tmp=$(mktemp)
	go test -coverprofile=$tmp ./... && go tool cover -html=$tmp && rm $tmp
}

### Nice aliases
alias flush_dns='sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder'
alias self_signed='openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes'
alias unescape_html='python3 -c "import sys; import html; print(html.unescape(sys.stdin.read()))"'
alias unset_docker='unset DOCKER_TLS_VERIFY DOCKER_HOST DOCKER_CERT_PATH DOCKER_MACHINE_NAME'
alias vim=nvim
alias zshconfig="nvim ~/.zshrc"
alias mtr="sudo mtr"
alias ssh-tor='ssh -o "ProxyCommand nc -X 5 -x 127.0.0.1:9050 %h %p"'
alias ssh='TERM=xterm ssh'
alias gphm='git push && hub pull-request -b master'
alias isonow='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias unixnow='date +%s'
alias kctx='kubectx'
alias kns='kubens'
alias ls='lsd'
alias lt='ls --tree'

### Utility functions
function ppjson() {
	python -c "import json;import sys; print(json.dumps(json.loads(sys.stdin.read()), ensure_ascii=False, indent=4))" | pygmentize -l json
}


### Work related
. ~/.zshrc_private

### Miscellaneous
export KUBE_EDITOR=nvim

export HOMEBREW_NO_ENV_HINTS=1

export BAT_THEME="Catppuccin-mocha"

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

# Added by LM Studio CLI (lms)
export PATH="$PATH:~/.cache/lm-studio/bin"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi
