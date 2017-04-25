# Clones a plugin locally
gen\clone () {
  typeset -A plugin; plugin=($@)
  if [[ -d ${plugin[path]} ]]; then    
    return 1
  fi
  git clone -- "${plugin[url]}" "${plugin[path]}"
}

# Load a given plugin by sourcing it
gen\load () {
  typeset -A plugin; plugin=($@)

  # should be configurable, ie: form theme context should only look for .zsh-theme,
  # or loc, for plugin context should only look for .plugin.zsh or loc, if given
  # a loc it should fail when no $loc/$loc.plugin.zsh/$loc.zsh-theme/$loc.zs etc
  # do no exist
  typeset -a strategies=(location init) # dot-plugin zsh-theme zsh sh)
  typeset -a list;
  gen\load\list $strategies

  for line in $list; do
    source "$line"
    return 0
  done
  
  return 1
}

# Load list
gen\load\list () {
  gen\load\strategy\location () {
    typeset -A plugin; plugin=($@)
    if [[ ${plugin[loc]} == '/' ]]; then
      return
    fi

    local files=("${plugin[path]}/${plugin[loc]}.plugin.zsh"
      "${plugin[path]}/${plugin[loc]}.zsh-theme"
      "${plugin[path]}/${plugin[loc]}.zsh"
      "${plugin[path]}/${plugin[loc]}"
    )

    local file
    for file in $files; do
      if [[ -f $file ]]; then
        list+=$file
        break;
      fi
    done
  }

  gen\load\strategy\dot-plugin () {
    typeset -A plugin; plugin=($@)
    list+=(${plugin[path]}/*.plugin.zsh(N[1]))
  }

  gen\load\strategy\init () {
    typeset -A plugin; plugin=($@)
    local file="${plugin[path]}/init.zsh"
    if [[ -f $file ]]; then
      list+=$file
    fi
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
  gen\clone ${(kv)plugin}
}
