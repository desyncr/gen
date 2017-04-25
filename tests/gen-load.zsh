setopt shwordsplit
_ROOT_=${0:A:h:h}
SHUNIT_PARENT=$0
source ${_ROOT_}/gen.zsh

oneTimeSetUp()
{
  GEN_PLUGINS="/tmp/gen-test"
  mkdir -p $GEN_PLUGINS
}

setUp()
{
  
}

testGenLoad()
{
  typeset -A plugin;
  local plugin_dir=$(mktemp -d "${GEN_PLUGINS}/plugin-XXXXX")
  touch $plugin_dir/plugin.zsh
  plugin=(path $plugin_dir)
  
  typeset -a strategies=(location dot-plugin zsh)
  typeset -Ua list; list=();
  gen\load\auto 'list' $strategies
  assertEquals "$plugin_dir/plugin.zsh" "${list[1]}"
}

testGenLoadLocationStrategy()
{
  typeset -A plugin;
  local plugin_dir=$(mktemp -d "${GEN_PLUGINS}/plugin-XXXXX")
  touch $plugin_dir/base.plugin.zsh
  touch $plugin_dir/base.zsh
  plugin=(path $plugin_dir)
  
  typeset -a strategies=(location dot-plugin zsh)
  typeset -Ua list;
  gen\load\auto 'list' $strategies
  assertEquals "$plugin_dir/base.plugin.zsh" "${list[1]}"
}


testGenLoadLocationLocation()
{
  typeset -A plugin;
  local plugin_dir=$(mktemp -d "${GEN_PLUGINS}/plugin-XXXXX")
  touch $plugin_dir/base
  plugin=(path $plugin_dir loc base)
  
  typeset -a strategies=(location dot-plugin zsh)
  typeset -a list;
  gen\load\auto 'list' $strategies
  assertEquals "$plugin_dir/base" "${list[1]}"

  touch $plugin_dir/base.plugin.zsh
  plugin=(path $plugin_dir loc base)
  
  typeset -a strategies=(location dot-plugin zsh)
  typeset -a list; list=()
  gen\load\auto 'list' $strategies
  assertEquals "$plugin_dir/base.plugin.zsh" "${list[1]}"
}

source ${_ROOT_}/shunit2/source/2.1/src/shunit2
