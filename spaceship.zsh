SPACESHIP_DIR_TRUNC_REPO=false


# Setting prefix and suffix for docker_context section
SPACESHIP_DOCKER_CONTEXT_PREFIX="🐳 "
SPACESHIP_DOCKER_CONTEXT_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"

spaceship remove gcloud
# Replacing docker with docker_context
spaceship remove docker
spaceship add docker_context

spaceship add kubectl
spaceship remove ansible
