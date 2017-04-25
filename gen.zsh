# vim: set sw=2 ts=2 et
source ${0:h}/genlib.zsh

# Clones a plugin locally
gen\clone () {
  typeset -A plugin; plugin=($@)
  if [[ -d ${plugin[path]} ]]; then
    return 0
  fi
  git clone -- "${plugin[url]}" "${plugin[path]}"
}

# Parse cli arguments [user/plugin] [location]
gen\parse () {
  local var=$1
  shift

  local name="$1"
  local loc="$2"

  typeset -A args
  args[url]="https://github.com/${name}.git"
  if [[ -n "$loc" ]]; then
    args[loc]="$loc"
  fi

  args[path]="$GEN_PLUGINS/${name}"

  eval "${var}=(${(kv)args})"
}

gen () {
  GEN_PLUGINS=${GEN_PLUGINS:-$HOME/.gen}

  typeset -A plugin
  gen\parse 'plugin' "$@"
  if gen\clone ${(kv)plugin}; then
    gen\load ${(kv)plugin}
  fi
}
