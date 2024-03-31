SPACESHIP_DIR_TRUNC_REPO=false

DISABLED_SECTIONS=("azure" "bun" "conda""crystal" "dart" "deno" "dotnet" "elixit" "elm" "erlang" "gcloud" "imbcloud" "java" "lua" "mercurial" "ocaml" "perl" "php" "palumni" "rust" "scala" "swift" "zig")
for section in "${DISABLED_SECTIONS[@]}"; do
	spaceship remove $section
done

SPACESHIP_DOCKER_CONTEXT_PREFIX="🐳 "
SPACESHIP_DOCKER_CONTEXT_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"
spaceship remove docker
spaceship add docker_context

spaceship add kubectl
spaceship add python
