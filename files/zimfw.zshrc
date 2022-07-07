#! /bin/zsh
ZDOTDIR=$HOME/.zdotdir
ZSHENV=$ZDOTDIR/.zshenv
ZSHRC=$ZDOTDIR/.zshrc

ZIMRC=$ZDOTDIR/.zimrc
ZIM=$ZDOTDIR/.zim
ZIMFW=$ZIM/zimfw.zsh
ZIM_MODULES=$ZIM/modules

rm -rf "$ZDOTDIR"
mkdir -p "$ZDOTDIR"

[[ -d "$HOME/anaconda3" ]] && : ${CONDA_DIR:="$HOME/anaconda3"}
[[ -d "$HOME/miniconda3" ]] && : ${CONDA_DIR:="$HOME/miniconda3"}
[[ -d "$HOME/.local/opt/miniconda3" ]] && : ${CONDA_DIR:="$HOME/.local/opt/miniconda3"}

[[ -x "$CONDA_DIR/bin/conda" ]] && : ${CONDA_BIN:="$CONDA_DIR/bin/conda"}

cat > "$ZIMRC" << EOF
zmodule archive
zmodule environment
zmodule input
zmodule termtitle
zmodule utility
zmodule steeef
$([[ -x "$CONDA_BIN" ]] && echo "" && echo "zmodule esc/conda-zsh-completion")
zmodule zsh-users/zsh-completions

zmodule completion
zmodule zsh-users/zsh-autosuggestions
zmodule zsh-users/zsh-syntax-highlighting
zmodule zsh-users/zsh-history-substring-search
zmodule rupa/z
zmodule romkatv/powerlevel10k
EOF

mkdir -p "$ZIM_MODULES"
sed -ne 's#^zmodule ##p' "$ZIMRC" | sed -E 's#^([^/]+)$#zimfw/\1#' \
  | xargs -P 32 -I {} \
  git -C "$ZIM_MODULES" clone --depth 1 "https://github.com/{}.git"

touch "$ZDOTDIR/.z"
cat > "$ZSHENV" << "EOF"
ZDOTDIR=${HOME}/.zdotdir
_Z_DATA=${ZDOTDIR}/.z
EOF

xargs -P 32 -I {} sh -c {} << EOF
wget -qO "$ZDOTDIR/.p10k.zsh" https://setup.rogeric.xyz/files/p10k.zsh
wget -qO "$ZIMFW" https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
wget -qO "$ZSHRC" https://raw.githubusercontent.com/zimfw/install/master/src/templates/zshrc
EOF

if [[ -f /etc/zsh/zshrc ]] && grep -q "skip_global_compinit" /etc/zsh/zshrc ; then
  echo "skip_global_compinit=1" >> "$ZSHENV"
fi

if [[ -x "$(command -v vim)" ]] ; then
  cat >> "$ZSHRC" << "EOF"
EDITOR='vim'
export EDITOR
EOF
fi

if [[ -x "$(command -v tmux)" ]] && [[ ! -e ~/.tmux.conf ]]; then
  cat >> ~/.tmux.conf << "EOF"
set -g default-terminal "screen-256color"
EOF
fi

if [[ -x "$(command -v dircolors)" ]] ; then
  dircolors >> "$ZSHRC"
fi

if [[ -d "/opt/ros" ]]; then
  echo "source $(find /opt/ros -mindepth 2 -maxdepth 2 -name setup.zsh)" >> "$ZSHRC"
fi

if [[ -x "$CONDA_BIN" ]] ; then
  env "HOME=$ZDOTDIR" "$CONDA_BIN" init zsh
fi

cat > "$ZSHRC.p10k" << "EOF"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.  # Initialization code that may require console input (password prompts, [y/n]
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

ln -sf .zdotdir/.zshenv ~/.zshenv
exec sh -c "rm -rf ~/.zshrc ~/.zcompdump; zsh \"$ZIMFW\" install; exec zsh"
