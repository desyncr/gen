# vim: set sw=2 ts=2 et
# Clones a plugin locally
gen\clone () {
  typeset -A plugin; plugin=($@)
  if [[ -d ${plugin[path]} ]]; then
    return 0
  fi
  git clone -- "${plugin[url]}" "${plugin[path]}"
}

# Load a given plugin by sourcing it
gen\load () {
  typeset -A plugin; plugin=($@)

  typeset -a strategies=(dot-plugin location init) # zsh-theme zsh sh
  typeset -a list;
  gen\load\list $strategies

  if ! gen\load\strategy\source $list; then
    return 1
  fi

  return 0
}

gen\load\strategy\source () {
  local list=$1
  source "${line[0]}" && return 0
  return 1
}


# Load list
gen\load\list () {
  gen\load\strategy\location () {
    typeset -A plugin; plugin=($@)
    if [[ ${plugin[loc]} == "" || ${plugin[loc]} == "/" ]]; then
      return
    fi

    list=(${plugin[path]}/${plugin[loc]}.plugin.zsh(N)
      ${plugin[path]}/${plugin[loc]}.zsh-theme(N)
      ${plugin[path]}/${plugin[loc]}.zsh(N)
      ${plugin[path]}/${plugin[loc]}(N)
    )
  }

  gen\load\strategy\dot-plugin () {
    typeset -A plugin; plugin=($@)
    list+=(${plugin[path]}/*.plugin.zsh(N[1]))
  }

  gen\load\strategy\init () {
    typeset -A plugin; plugin=($@)
    list=(${plugin[path]}/init.zsh(N))
  }

  gen\load\strategy\zsh-theme () {
    typeset -A plugin; plugin=($@)
    list+=(${plugin[path]}/*.zsh-theme(N[1]))
  }

  gen\load\strategy\zsh () {
    typeset -A plugin; plugin=($@)
    list+=(${plugin[path]}/*.zsh(N))
  }

  gen\load\strategy\sh () {
    typeset -A plugin; plugin=($@)
    list+=(${plugin[path]}/*.sh(N))
  }

  for strategy in $strategies; do
    eval gen\load\strategy\\$strategy ${(kv)plugin}
    if [[ ! "${#list}" == 0 ]]; then
      break;
    fi
  done
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
