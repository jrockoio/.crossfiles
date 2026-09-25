#!/bin/zsh

if command -v starship >/dev/null 2>&1 && [[ -z ${__STARSHIP_ZSH_INITED:-} ]]; then
  typeset -g __STARSHIP_ZSH_INITED=1
  eval "$(starship init zsh)"
fi
