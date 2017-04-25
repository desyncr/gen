setopt shwordsplit
_ROOT_=${0:A:h:h}
SHUNIT_PARENT=$0
source ${_ROOT_}/gen.zsh

oneTimeSetUp()
{
  GEN_PLUGINS=${GEN_PLUGINS:-$HOME/.gen}
}

setUp()
{
  
}

testGenParsePath()
{
  typeset -A plugin
  gen\parse 'plugin' "desyncr/zsh-ctrlp"
  
  assertEquals 'https://github.com/desyncr/zsh-ctrlp.git' "${plugin[url]}"
}

testGenParseLocation()
{
  typeset -A plugin
  gen\parse 'plugin' "desyncr/zsh-ctrlp" "zsh-ctrlp.zsh"
  
  assertEquals 'https://github.com/desyncr/zsh-ctrlp.git' "${plugin[url]}"
  assertEquals 'zsh-ctrlp.zsh' "${plugin[loc]}"
}

testGenParsePath()
{
  typeset -A plugin
  gen\parse 'plugin' "desyncr/zsh-ctrlp" "zsh-ctrlp.zsh"

  assertEquals 'https://github.com/desyncr/zsh-ctrlp.git' "${plugin[url]}"
  assertEquals 'zsh-ctrlp.zsh' "${plugin[loc]}"
  assertEquals "${GEN_PLUGINS}/desyncr/zsh-ctrlp" "${plugin[path]}"
}

source ${_ROOT_}/shunit2/source/2.1/src/shunit2
