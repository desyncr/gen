# gen

Barebones zsh plugin manager.

## Install

    curl -L git.io/gen > gen.zsh
    source gen.zsh

## Commands

There is only one available command: `gen`, example:

    gen zsh-users/zsh-syntax-highlighting

Above command will clone and load the given plugin.


### Syntax

    gen [user/repo] [location]

### Usage

In order to load an specific file:

    gen vifon/deer deer


## Example configuration

```.zshrc

gen rupa/z z.sh
gen zdharma/fast-syntax-highlighting
gen zsh-users/zsh-autosuggestions
gen zsh-users/zsh-completions
gen psprint/zsh-navigation-tools
gen hlissner/zsh-autopair
gen robbyrussell/oh-my-zsh plugins/wd/wd # oh-my-zsh plugin
gen Tarrasch/zsh-autoenv
gen frmendes/geometry # theme

```
