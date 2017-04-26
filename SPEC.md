# Plugin structure

A plugin may be comprised of various artifacts (completions, binaries,
sourceables) that may be added to the environment.

A plugin loader (`genlib.zsh`) may load one or more of those artifacts based on
various environment settings and configurations.

# Requirements

Plugin meta-data required:

    path           -- Where in filesystem the plugin is located
    location       -- Where, inside the plugin directory, should load from

# Auto discover

Using the default load strategy will look for the following plugin entry points
in this specific order:

## location strategy

Use this strategy to load a plugin from the given `location`, where location is
a path to a file, ex: `path/to/loader.zsh`, `path/to/name.plugin.zsh`.

    ${path}/${location}

## dot-plugin strategy

Use this strategy to set the plugin entry point to a dot-plugin file:

    ${path}/${location}*.plugin.zsh

If multiple dot-plugin files are found in the given location it will list them
all.

If `$location` is defined it MUST be suffixed with slash (`/`).

## init strategy

Use this strategy to set the plugin entry point to a `init.zsh` file:

    ${path}/${location}init.zsh

If `$location` is defined it MUST be suffixed with slash (`/`).

## zsh-theme strategy

Same rules applies as `dot-plugin` strategy.

    ${path}/${location}*.zsh-theme

## zsh strategy

Same rules applies as `dot-plugin` strategy.

    ${path}/${location}*.zsh

## sh strategy

Same rules applies as `dot-plugin` strategy.

    ${path}/${location}*.sh

# Directory structure example

With these strategies you may load plugins from:

    file/path                     - handled by
    ---------                     - ----------
    plugin
        \- name.zsh               - location, zsh
        |- name.plugin.zsh        - location, dot-plugin, zsh
        |- name.sh                - location, sh
        |- name                   - location
        \ subdir
              \- name.zsh         - location, zsh
              |- name.plugin.zsh  - location, dot-plugin
              |- name.sh          - location, sh
              \- name             - location

