eval "$(/opt/homebrew/bin/brew shellenv)"

eval "$(mise activate zsh --shims)"

### Completions
mkdir -p ~/.zfunc
fpath=(~/.zfunc $fpath)
fpath=("$(brew --prefix)/share/zsh-completions" $fpath)

# kubectl completion (cached in ~/.zfunc)
if (( $+commands[kubectl] )) && [[ ! -f ~/.zfunc/_kubectl ]]; then
  kubectl completion zsh >| ~/.zfunc/_kubectl
fi

autoload -Uz compinit
compinit -C

### sk (skim)
export SKIM_CTRL_R_OPTS="--scheme=history"
source /opt/homebrew/opt/sk/share/zsh/site-functions/key-bindings.zsh

source ~/dotfiles/zsh/plugins.zsh

eval "$(starship init zsh)"

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory hist_ignore_space
setopt hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups
setopt extended_history
setopt auto_cd

if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi

export LC_ALL=en_US.UTF-8
export KEYTIMEOUT=1

### Golang settings
export GOPATH=$HOME/golang
export PATH=$PATH:$GOPATH/bin
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

### PATH additions
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cache/lm-studio/bin"

### Completion styles
zstyle ':completion:*' rehash true
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select

export KUBE_EDITOR=nvim
export HOMEBREW_NO_ENV_HINTS=1
export BAT_THEME="Catppuccin-mocha"

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
alias wts='wt switch'
alias wtsc='wt switch --create'
alias wtl='wt list'

### Utility functions
function ppjson() {
	python -c "import json;import sys; print(json.dumps(json.loads(sys.stdin.read()), ensure_ascii=False, indent=4))" | pygmentize -l json
}

### Work related
. ~/.zshrc_private

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
