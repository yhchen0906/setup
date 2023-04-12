#! /bin/zsh
zmodload zsh/pcre
setopt REMATCH_PCRE

readonly -i NPROC=32

readonly ZDOTDIR=${HOME}/.zdotdir
readonly ZSHENV=${ZDOTDIR}/.zshenv ZSHRC=${ZDOTDIR}/.zshrc P10K=${ZDOTDIR}/.p10k.zsh

readonly ZIM_HOME=${ZDOTDIR}/.zim
readonly ZIMRC=${ZDOTDIR}/.zimrc ZIMFW=${ZIM_HOME}/zimfw.zsh ZIM_MODULES=${ZIM_HOME}/modules

get_conda_prefix() {
  readonly -a conda_prefixes=(
    "${HOME}/anaconda3"
    "${HOME}/miniconda3"
    "${HOME}/.local/opt/miniconda3"
    "${HOME}/mambaforge"
    "${HOME}/.local/opt/mambaforge"
  )

  for conda_prefix in ${conda_prefixes}; do
    if [[ -d "${conda_prefix}" ]]; then
      echo "${conda_prefix}"
      return 0
    fi
  done

  return 1
}

initialize_assets() {
  rm -rf "${ZDOTDIR}"

  mkdir -p "${ZIM_MODULES}"
  touch "${ZDOTDIR}/.z"

  xargs -P "${NPROC}" -L 1 wget -qO << EOF
"${P10K}" https://setup.rogeric.xyz/files/p10k.zsh
"${ZIMFW}" https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
"${ZSHRC}" https://raw.githubusercontent.com/zimfw/install/master/src/templates/zshrc
EOF

  if (( ${+commands[tmux]} )) && [[ ! -e ~/.tmux.conf ]]; then
    echo 'set -g default-terminal "screen-256color"' >| ~/.tmux.conf
  fi
}

generate_zshenv() {
  cat >| "$ZSHENV" << "EOF"
ZDOTDIR=${HOME}/.zdotdir
_Z_DATA=${ZDOTDIR}/.z
EOF
  grep -q "skip_global_compinit" /etc/zsh/zshrc > /dev/null 2>&1 && echo "skip_global_compinit=1" >> "$ZSHENV"
}

generate_zimrc() {
  local -a zmodules

  zmodules+=('environment' 'archive')
  (( ${+commands[fzf]} )) && zmodules+=('fzf')
  zmodules+=('git' 'input' 'termtitle' 'utility' 'ssh')
  [[ -x "${CONDA_EXE}" ]] && zmodules+=('esc/conda-zsh-completion')
  zmodules+=('zsh-users/zsh-completions' 'completion')
  zmodules+=(
    'zsh-users/zsh-syntax-highlighting'
    'zsh-users/zsh-history-substring-search'
    'zsh-users/zsh-autosuggestions'
  )
  zmodules+=(
    'rupa/z'
    'romkatv/powerlevel10k'
  )

  printf 'zmodule %s\n' ${zmodules} >| "${ZIMRC}"
}

download_zmodules() {
  while read -r line; do
    if [[ ${line} =~ '^zmodule (\S+)' ]]; then
      local repo=${match[1]}
      [[ ${repo} =~ '^[^\/]+$' ]] && repo="zimfw/${repo}"
      echo "https://github.com/${repo}.git"
    fi
  done < "${ZIMRC}" | \
  xargs -P "${NPROC}" -I {} git -C "${ZIM_MODULES}" clone --depth 1 {}
}

patch_zshrc_misc() {
  if (( ${+commands[direnv]} )) ; then
  cat >> "$ZSHRC" << "EOF"

eval "$(direnv hook zsh)"
EOF
  fi

  if (( ${+commands[vim]} )) ; then
  cat >> "$ZSHRC" << "EOF"

EDITOR='vim'
export EDITOR
EOF
  fi

  (( ${+commands[dircolors]} )) && echo >> "$ZSHRC" && dircolors >> "$ZSHRC"

  # systemctl completion hotfix
  # https://github.com/ohmyzsh/ohmyzsh/issues/8751
  if (( ${+commands[systemctl]} )); then
    cat >> "$ZSHRC" << "EOF"

_systemctl_unit_state () {
  typeset -gA _sys_unit_state
  _sys_unit_state=($(__systemctl list-unit-files "$PREFIX*" | awk '{print $1, $2}'))
}
EOF
  fi

  if [[ -d "/opt/ros" ]]; then
    echo "source $(find /opt/ros -mindepth 2 -maxdepth 2 -name setup.zsh)" >> "$ZSHRC"
  fi

  [[ -x "${MAMBA_EXE}" ]] && env "HOME=${ZDOTDIR}" "${MAMBA_EXE}" init zsh && return 0
  [[ -x "${CONDA_EXE}" ]] && env "HOME=${ZDOTDIR}" "${CONDA_EXE}" init zsh && return 0
}

patch_zshrc_p10k() {
  cat >| "$ZSHRC.p10k" << "EOF"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zdotdir/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

EOF

  cat "$ZSHRC" >> "$ZSHRC.p10k"

  cat >> "$ZSHRC.p10k" << "EOF"

# To customize prompt, run `p10k configure` or edit ~/.zdotdir/.p10k.zsh.
[[ ! -f ~/.zdotdir/.p10k.zsh ]] || source ~/.zdotdir/.p10k.zsh
EOF

  mv "$ZSHRC.p10k" "$ZSHRC"
}

readonly CONDA_PREFIX=$(get_conda_prefix)
readonly CONDA_EXE=${CONDA_PREFIX}/bin/conda
readonly MAMBA_EXE=${CONDA_PREFIX}/bin/mamba

initialize_assets
generate_zshenv
generate_zimrc
download_zmodules
patch_zshrc_misc
patch_zshrc_p10k

ln -sf .zdotdir/.zshenv ~/.zshenv
exec sh -c "rm -rf ~/.zshrc ~/.zcompdump; zsh \"$ZIMFW\" install; exec zsh"
