#! /usr/bin/env zsh
readonly PREFIX="${HOME}/.local"
readonly BIN_DIR="${PREFIX}/bin"
readonly COMPLETION_DIR="${PREFIX}/share/zsh/functions/Completion"

readonly ARCH=$(uname -m)
arch=${ARCH}
if [[ ${arch} = "x86_64" ]] arch="amd64"
if [[ ${arch} = "aarch64" ]] arch="arm64"

mkdir -p ${BIN_DIR}
mkdir -p ${COMPLETION_DIR}

readonly base_func='_user_install'

http () {
  local url=${1}
  local file=${2}

  if [[ -z ${file} ]]; then
    file='-'
  else
    mkdir -p $(dirname ${file})
  fi

  if (( ${+commands[curl]} )); then
    curl -fsSLo ${file} ${url}
  elif (( ${+commands[wget]} )); then
    wget -qO ${file} ${url}
  fi
}

github_release_urls () {
  local repo=${1}
  readonly url="https://api.github.com/repos/${repo}/releases/latest"
  http ${url} | grep -F "browser_download_url" | cut -d '"' -f 4
}

${base_func}_bat () {
  readonly url=$(github_release_urls 'sharkdp/bat' | grep -F "${ARCH}-unknown-linux-musl.tar.gz")

  http ${url} | tar zxC ${tmp_dir}

  mv ${tmp_dir}/*/${pkg} ${bin_path}
  ${bin_path} --completion zsh >| ${completion_path}
}

${base_func}_direnv () {
  http 'https://direnv.net/install.sh' | env bin_path=${BIN_DIR} bash
}

${base_func}_eza () {
  readonly urls=($(github_release_urls 'eza-community/eza' | grep -F '.tar.gz'))

  readonly bin_url=$(printf "%s\n" ${urls} | grep -F "eza_${ARCH}-unknown-linux-gnu")
  http ${bin_url} | tar zxC ${BIN_DIR}
  chmod a+x ${bin_path}

  readonly completion_url=$(printf "%s\n" ${urls} | grep -F "completions-")
  http ${completion_url} | tar zxC ${tmp_dir}

  mv ${tmp_dir}/*/*/_eza ${completion_path}
}

${base_func}_fd () {
  readonly url=$(github_release_urls 'sharkdp/fd' | grep -F -- "${ARCH}-unknown-linux-musl")
  http ${url} | tar zxC ${tmp_dir}
  mv ${tmp_dir}/*/${pkg} ${bin_path}
  mv ${tmp_dir}/*/autocomplete/_${pkg} ${completion_path}
}

${base_func}_fzf () {
  readonly url=$(github_release_urls 'junegunn/fzf' | grep -F "linux_${arch}.tar.gz")
  http ${url} | tar zxC ${BIN_DIR}
}

${base_func}_jq () {
  readonly url=$(github_release_urls 'jqlang/jq' | grep -F "jq-linux-${arch}")
  http ${url} ${bin_path}

  chmod a+x ${bin_path}
}

${base_func}_rg () {
  readonly url=$(github_release_urls 'BurntSushi/ripgrep' | grep "${ARCH}-unknown-linux-gnu.*\.tar\.gz$")
  http ${url} | tar zxC ${tmp_dir}

  mv ${tmp_dir}/*/${pkg} ${bin_path}
  ${bin_path} --generate complete-zsh >| ${completion_path}
}

${base_func}_stow () {
  http 'https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz' | tar zxC ${tmp_dir}
  cd ${tmp_dir}/*/ || return
  ./configure --quiet --prefix=${PREFIX}
  make install
  cd - || return
}

${base_func}_zoxide () {
  http 'https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh' | sh
}

${base_func} () {
  readonly pkg=${1}
  readonly bin_path="${BIN_DIR}/${pkg}"
  readonly completion_path="${COMPLETION_DIR}/_${pkg}"
  readonly tmp_dir=$(mktemp --tmpdir -d "${pkg}.XXXX")

  if [[ $(uname -s) = "Darwin" ]]; then
    if [[ ${pkg} = "rg" ]]; then
      brew install ripgrep
    else
      brew install ${pkg}
    fi
  else
    ${base_func}_${pkg}
  fi

  rm -rf ${tmp_dir}
}

main () {
  readonly install_functions=(${(kM)functions%${base_func}_*})
  readonly all_pkgs=(${install_functions#${base_func}_})

  local -aU pkgs
  for pkg in $@; do
    if [[ ${pkg} = "all" ]]; then
      pkgs+=(${all_pkgs})
    else
      pkgs+=(${pkg})
    fi
  done

  for pkg in ${pkgs}; do
    ${base_func} ${pkg}
  done
}

if [[ -z ${ZSH_SCRIPT} ]]; then
  main ${(s:,:)pkgs}
else
  main ${@}
fi
