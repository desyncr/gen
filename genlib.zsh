# Load a given plugin using configurable load and sourcing strategies
#
# Usage:
#  gen\load $plugin
#
# Where `$plugin` is an assoc array in the form:
#    path /path/to/plugin loc=subdir/in/plugin/path
gen\load () {
  typeset -A plugin; plugin=($@)

  typeset -a strategies=(location dot-plugin init) # zsh-theme zsh sh
  typeset -Ua list; list=()
  gen\load\auto 'list' $strategies

  if ! gen\load\strategy\default $list; then
    return 1
  fi

  return 0
}

# Default sourcing strategy: source
gen\load\strategy\default () {
  local list=($@)
  source "${list[1]}" 2>/dev/null && return 0
  return 1
}


# Load plugin automatically
gen\load\auto () {
  local var=$1; shift
  if [[ $var != "list" ]]; then
    typeset -Ua list; list=()
  fi

  for strategy in $strategies; do
    eval gen\load\strategy\\$strategy ${(kv)plugin}
  done

  if [[ $var != "list" ]]; then
    eval "${var}=($items)"
  fi
}

# Load from location (dot-plugin, zsh-theme, zsh, loc)
# TODO load $loc.sh?
gen\load\strategy\location () {
  typeset -A plugin; plugin=($@)
  local loc=${plugin[path]}/${plugin[loc]}
  list+=(${loc}.plugin.zsh(N) ${loc}.zsh-theme(N) ${loc}.zsh(N) ${loc}(N.))
}

# Load first found dot-plugin
gen\load\strategy\dot-plugin () {
  typeset -A plugin; plugin=($@)
  list+=(${plugin[path]}/*.plugin.zsh(N[1]))
}

# Load init.zsh
# TODO If init.zsh is located in a subdir? -- location may handle it
gen\load\strategy\init () {
  typeset -A plugin; plugin=($@)
  list+=(${plugin[path]}/init.zsh(N))
}

# Load first found zsh-theme
gen\load\strategy\zsh-theme () {
  typeset -A plugin; plugin=($@)
  list+=(${plugin[path]}/*.zsh-theme(N[1]))
}

# Load all zsh found
# TODO How can I load all zsh from a given loc, ie loc=bin/tools
gen\load\strategy\zsh () {
  typeset -A plugin; plugin=($@)
  list+=(${plugin[path]}/*.zsh(N))
}

# Load all sh found
gen\load\strategy\sh () {
  typeset -A plugin; plugin=($@)
  list+=(${plugin[path]}/*.sh(N))
}

