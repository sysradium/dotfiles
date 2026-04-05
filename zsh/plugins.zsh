### plugins.zsh — standalone replacement for oh-my-zsh plugins
### Replaces: alias-finder, zoxide, sudo, git, kubectl omz plugins

# ── 0. fzf-tab (fuzzy completion menu via sk) ─────────────────────────────────
# Must be sourced after compinit but before other plugins that wrap completion
source ~/dotfiles/zsh/fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' use-fzf-default-opts yes

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a"

# ── 1. Zoxide ─────────────────────────────────────────────────────────────────
# Provides: z <dir>, zi (interactive), z - (previous dir)
(( $+commands[zoxide] )) && eval "$(zoxide init --cmd z zsh)"

# ── 2. Arrow key history search (prefix-aware) ────────────────────────────────
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA'  up-line-or-beginning-search
bindkey '^[OB'  down-line-or-beginning-search

# ── 3. Alias-finder ───────────────────────────────────────────────────────────
alias-finder() {
  local cmd="${1:-}"
  local exact="${2:-}"
  if [[ -z "$cmd" ]]; then return; fi

  local -a tokens=("${(@s/ /)cmd}")
  local search="${tokens[*]}"
  local alias_name alias_value

  # Search from most-specific (full command) to least-specific (first word)
  while [[ ${#tokens} -gt 0 ]]; do
    search="${tokens[*]}"
    for alias_name alias_value in ${(kv)aliases}; do
      if [[ "$alias_value" == "$search" ]]; then
        print -r -- "${alias_name}='${search}'"
        [[ -n "$exact" ]] && return
      fi
    done
    tokens=("${tokens[@]:0:${#tokens}-1}")
  done
}

_alias_finder_preexec() {
  alias-finder "$1"
}
autoload -U add-zsh-hook
add-zsh-hook preexec _alias_finder_preexec

# ── 4. Git helper functions ───────────────────────────────────────────────────
function git_current_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

function git_main_branch() {
  local branch
  for branch in main trunk master; do
    if git show-ref --verify --quiet refs/heads/$branch 2>/dev/null; then
      echo $branch
      return
    fi
  done
  echo master
}

function git_develop_branch() {
  local branch
  for branch in dev devel develop development; do
    if git show-ref --verify --quiet refs/heads/$branch 2>/dev/null; then
      echo $branch
      return
    fi
  done
  echo develop
}

# ── 5. Git aliases ────────────────────────────────────────────────────────────

# add/commit
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gcmsg='git commit --message'
alias gc='git commit --verbose'
alias gca='git commit --verbose --all'
alias 'gca!'='git commit --verbose --all --amend'
alias 'gcan!'='git commit --verbose --all --no-edit --amend'
alias 'gc!'='git commit --verbose --amend'
alias gcam='git commit --all --message'

# status/diff
alias gst='git status'
alias gss='git status --short'
alias gsb='git status --short --branch'
alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gds='git diff --staged'
alias gdw='git diff --word-diff'

# push/pull
alias gp='git push'
alias gpf='git push --force-with-lease'
alias 'gpf!'='git push --force'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gl='git pull'
alias gpr='git pull --rebase'
alias gpra='git pull --rebase --autostash'
alias ggpull='git pull origin "$(git_current_branch)"'
alias ggpush='git push origin "$(git_current_branch)"'

# log
alias glog='git log --oneline --decorate --graph'
alias glo='git log --oneline --decorate'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'

# stash
alias gsta='git stash push'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gstc='git stash clear'
alias gstd='git stash drop'

# branch
alias gcm='git checkout $(git_main_branch)'
alias gcb='git checkout -b'
alias gco='git checkout'

# rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grbs='git rebase --skip'
alias grbm='git rebase $(git_main_branch)'

# reset
alias grhh='git reset --hard'

# ── 6. Kubectl completion + aliases ──────────────────────────────────────────
if (( $+commands[kubectl] )); then
  # basic
  alias k='kubectl'
  alias kaf='kubectl apply -f'
  alias kdel='kubectl delete'
  alias kdelf='kubectl delete -f'

  # pods/logs
  alias kgp='kubectl get pods'
  alias kgpa='kubectl get pods --all-namespaces'
  alias kgpw='kgp --watch'
  alias kgpwide='kgp -o wide'
  alias kdp='kubectl describe pods'
  alias kdelp='kubectl delete pods'
  alias kl='kubectl logs'
  alias klf='kubectl logs -f'
  alias kl1h='kubectl logs --since 1h'
  alias klf1h='kubectl logs --since 1h -f'

  # deployments
  alias kgd='kubectl get deployment'
  alias kgdw='kgd --watch'
  alias ked='kubectl edit deployment'
  alias kdd='kubectl describe deployment'
  alias kdeld='kubectl delete deployment'
  alias krrd='kubectl rollout restart deployment'

  # services
  alias kgs='kubectl get svc'
  alias kgsw='kgs --watch'
  alias kds='kubectl describe svc'

  # port-forward/exec/contexts
  alias kpf='kubectl port-forward'
  alias keti='kubectl exec -t -i'
  alias kcuc='kubectl config use-context'
  alias kcsc='kubectl config set-context'
  alias kcdc='kubectl config delete-context'
  alias kccc='kubectl config current-context'
  alias kcgc='kubectl config get-contexts'
fi

# ── 7. zsh-autosuggestions + zsh-syntax-highlighting ─────────────────────────
# (syntax-highlighting must be sourced last)
[[ -f /opt/homebrew/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /opt/homebrew/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f /opt/homebrew/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
