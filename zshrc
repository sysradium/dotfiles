export ZSH=~/.oh-my-zsh

ZSH_THEME="robbyrussell"
plugins=(python vagrant colorize sudo pip zsh_reload sudo git docker boot2docker docker-compose brew encode64 httpie osx heroku battery)

export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='nvim'
else
	export EDITOR='vim'
fi

export PATH="$HOME/.pyenv/bin:/usr/local/opt/python@2/libexec/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export LC_ALL=en_US.UTF-8
export KEYTIMEOUT=1

### Golang settings
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

### Golang utils
function go_coverage() {
	tmp=$(mktemp)
	go test -coverprofile=$tmp ./... && go tool cover -html=$tmp && rm $tmp
}

function magnet-info() {
	hash=$(echo "$1" | ggrep -oP "(?<=btih:).*?(?=&)")
	echo "Magnet hash: $hash"
	aria2c --bt-metadata-only=true --bt-save-metadata=true -q "$1"
	aria2c "$hash.torrent" -S
	rm "$hash.torrent"
}

### Nice aliases
alias docker_gc="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc spotify/docker-gc"
alias flush_dns='sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder'
alias self_signed='openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes'
alias unescape_html='python3 -c "import sys; import html; print(html.unescape(sys.stdin.read()))"'
alias unset_docker='unset DOCKER_TLS_VERIFY DOCKER_HOST DOCKER_CERT_PATH DOCKER_MACHINE_NAME'
alias vim=nvim
alias zshconfig="nvim ~/.zshrc"
alias top='top -o -cpu'
alias mtr="sudo mtr"
alias copyid="ssh-copy-id -i ~/.ssh/id_rsa"
alias dokku='bash $HOME/.dokku/contrib/dokku_client.sh'
alias consul="docker run --rm -p 8301:8301 -p 8302:8301 -p 8500:8500 -p 8600:8600 -p 8300:8300 consul"

source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'


### Utility functions
function ppjson() {
	python3 -c "import json;import sys; print(json.dumps(json.loads(sys.stdin.read()), ensure_ascii=False, indent=4))" | pygmentize -l json
}

autoload -U +X bashcompinit && bashcompinit
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

### Spacheship configuration
source "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme"

spaceship_docker() {
	[[ $SPACESHIP_DOCKER_SHOW == false ]] && return

	_exists docker || return

	# Show Docker status only for Docker-specific folders
	[[ -f Dockerfile || -f docker-compose.yml ]] || return

	local docker_version=""

	if [[ -n $DOCKER_MACHINE_NAME ]]; then
		docker_version+="($DOCKER_MACHINE_NAME)"
	else
		docker_version+="(localhost)"
	fi

	_prompt_section \
		"$SPACESHIP_DOCKER_COLOR" \
		"$SPACESHIP_DOCKER_PREFIX" \
		"${SPACESHIP_DOCKER_SYMBOL} ${docker_version}" \
		"$SPACESHIP_DOCKER_SUFFIX"
}

SPACESHIP_PROMPT_ORDER=(
time          # Time stampts section
user          # Username section
host          # Hostname section
dir           # Current directory section
git           # Git section (git_branch + git_status)
docker        # Docker section
kubecontext
pyenv         # Pyenv section
line_sep      # Line break
jobs          # Backgound jobs indicator
exit_code     # Exit code section
char          # Prompt character
)


source "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme"

### Miscellaneous
KUBE_EDITOR=vim

complete -o nospace -C /usr/local/bin/vault vault

### Work related
. ~/.zshrc_work
. ~/.zshrc_private

