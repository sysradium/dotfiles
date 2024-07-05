export ZSH=~/.oh-my-zsh


eval "$(starship init zsh)"

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
plugins=(fzf-tab colorize helm golang python colorize sudo pip sudo git gitfast docker docker-compose brew encode64 httpie kubectl)
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:~/.local/bin"

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='nvim'
else
	export EDITOR='vim'
fi

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

export LC_ALL=en_US.UTF-8
export KEYTIMEOUT=1

### Golang settings
export GOPATH=$HOME/golang
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

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
alias copyid="ssh-copy-id -i ~/.ssh/id_rsa"
#alias dokku='bash $HOME/.dokku/contrib/dokku_client.sh'
alias consul="docker run --rm -p 8301:8301 -p 8302:8301 -p 8500:8500 -p 8600:8600 -p 8300:8300 consul"
alias postgres="docker run -p 127.0.0.1:5432:5432 --rm -e POSTGRES_PASSWORD=postgres postgres"
alias mysql="docker run -p 127.0.0.1:3306:3306 --rm -e MYSQL_ROOT_PASSWORD=password mysql:8"
alias ssh-tor='ssh -o "ProxyCommand nc -X 5 -x 127.0.0.1:9050 %h %p"'
alias ssh='TERM=xterm ssh'
alias gphm='git push && hub pull-request -b master'
alias isonow='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias unixnow='date +%s'
alias kctx='kubectx'
alias kns='kubens'
alias ls='lsd'
alias lt='ls --tree'

source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
source '/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh'


### Utility functions
function ppjson() {
	python -c "import json;import sys; print(json.dumps(json.loads(sys.stdin.read()), ensure_ascii=False, indent=4))" | pygmentize -l json
}

# autoload -U compinit && compinit
### Work related
. ~/.zshrc_private

### Miscellaneous
export KUBE_EDITOR=nvim

# The next line updates PATH for Yandex Cloud CLI.
if [ -f "$HOME/yandex-cloud/path.bash.inc" ]; then source "$HOME/yandex-cloud/path.bash.inc"; fi

# The next line enables shell command completion for yc.
if [ -f "$HOME/yandex-cloud/completion.zsh.inc" ]; then source "$HOME/yandex-cloud/completion.zsh.inc"; fi

export HOMEBREW_NO_ENV_HINTS=1

export BAT_THEME="Catppuccin-mocha"
eval "$(zoxide init zsh)"

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
