
❯ cat .zshrc       
## HISTORY
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
setopt HIST_EXPIRE_DUPS_FIRST
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS



export SWIG_BUILD=/home/heini/repos/swig/build
export CMAKE_BUILD=/home/heini/repos/CMake/build
export NINJA_BUILD=/home/heini/repos/ninja/build
export RE2C_BUILD=/home/heini/repos/re2c/build
export VCPKG=/home/heini/repos/vcpkg
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share/zinit}"
export GEM_DIR=/home/heini/.local/share/gem/ruby/3.0.0/bin
export CARGO_TARGET_DIR=$HOME/.cargo
export REPOS=$HOME/repos
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR=$HOME/.nvm
export FZF_DIR=$HOME/.fzf
export EMACS_LISP=$HOME/.emacs.d/lisp/
export YARN_DIR=$HOME/.yarn
export YARN_GLOBAL_FOLDER=$YARN_DIR/global_packages
export NINJA_DIR=$REPOS/ninja/build
export CARGO_BIN=$HOME/.cargo/bin
export BAT_STYLE="default"
export FZF_BIN=$REPOS/fzf/bin
export NEOVIM_BIN=/usr/bin/nvim
export BAT_DIR=$REPOS/bat/target/release
export FD_DIR=$REPOS/fd/target/release
export PATH=$SWIG_BUILD:$CMAKE_BUILD:$NINJA_BUILD:$RE2C_BUILD:$VCPKG:$NVM_DIR:$ZINIT_HOME:/home/heini/.local/bin:$GEM_DIR:$HOME/.personalBin:$REPOS/vcpkg:$HOME/bin:/usr/local/bin:$HOME/.local/share:$NINJA_DIR:$CARGO_BIN:$FZF_BIN:$BAT_DIR:$FD_DIR:$PATH
export FZF_DEFAULT_OPTS='--color=bg+:#3F3F3F,bg:#4B4B4B,border:#6B6B6B,spinner:#98BC99,hl:#719872,fg:#D9D9D9,header:#719872,info:#BDBB72,pointer:#E12672,marker:#E17899,fg+:#D9D9D9,preview-bg:#3F3F3F,prompt:#98BEDE,hl+:#98BC99'
export ZPROFILE=$HOME/.zshrc
#autoload -Uz compinit
#if [ "$(date +'%j')" != "$(stat --format='%y' ~/.zcompdump 2>/dev/null | cut -d ' ' -f 1 | date -f - +'%j' 2>/dev/null)" ]; then
#  compinit
#else
#  compinit -C
#fi



export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_DK.UTF-8
export LANGUAGE=en_DK.UTF-8


ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zdharma-continuum/zinit-annex-bin-gem-node

zinit for \
    light-mode \
  zsh-users/zsh-autosuggestions \
    light-mode \
  zdharma-continuum/fast-syntax-highlighting \
  zdharma-continuum/history-search-multi-word \
    light-mode \
    pick"async.zsh" \
    src"pure.zsh" \
  sindresorhus/pure




zi ice \
  as"program" \
  atclone"rm -f src/auto/config.cache; ./configure" \
  atpull"%atclone" \
  make \
  pick"src/vim"
zi light vim/vim

zi ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zi light trapd00r/LS_COLORS

zi ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' src"zhook.zsh"
zi light direnv/direnv


autoload -Uz compinit
compinit

zi as'null' lucid sbin wait'1' for \
  Fakerr/git-recall \
  davidosomething/git-my \
  iwata/git-now \
  paulirish/git-open \
  paulirish/git-recent \
    atload'export _MENU_THEME=legacy' \
  arzzen/git-quick-stats \
    make'install' \
  tj/git-extras \
    make'GITURL_NO_CGITURL=1' \
    sbin'git-url;git-guclone' \
  zdharma-continuum/git-url

# -q is for quiet; actually run all the `compdef's saved before `compinit` call
# (`compinit' declares the `compdef' function, so it cannot be used until
# `compinit' is ran; Zinit solves this via intercepting the `compdef'-calls and
# storing them for later use with `zinit cdreplay')

zinit cdreplay -q

zinit light Aloxaf/fzf-tab


zi for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
  zsh-users/zsh-completions

# Load starship theme

zi wait lucid for \
  z-shell/zsh-fancy-completions

zinit light z-shell/F-Sy-H

zinit pack for ls_colors

zinit \
    atclone'[[ -z ${commands[dircolors]} ]] &&
      local P=${${(M)OSTYPE##darwin}:+g};
      ${P}sed -i '\''/DIR/c\DIR 38;5;63;1'\'' LS_COLORS;
      ${P}dircolors -b LS_COLORS >! clrs.zsh' \
    atload'zstyle '\'':completion:*:default'\'' list-colors "${(s.:.)LS_COLORS}";' \
    atpull'%atclone' \
    git \
    id-as'trapd00r/LS_COLORS' \
    lucid \
    nocompile'!' \
    pick'clrs.zsh' \
    reset \
  for @trapd00r/LS_COLORS

export LANGUAGE=en_DK.UTF-8



sudo ryzenadj --max-performance > /dev/null 2>&1 # enabling max performance

alias freshZsh='source $HOME/.zshrc'
alias editZsh='sudo nano $HOME/.zshrc'
alias nvimZsh='sudo nvim $HOME/.zshrc'
alias freshBash='source $HOME/.bashrc'
alias editBash='sudo nano $HOME/.bashrc'
alias nvimBash='sudo nvim $HOME/.bashrc'
alias sudoyay='yay --batchinstall --sudoloop --asdeps'
alias autoyay='yay --batchinstall --sudoloop --asdeps --noconfirm'
alias vimZsh='sudo vim ~/.zshrc'
alias getip="ip addr | grep 'inet ' \
	| grep -v '127.0.0.1' | awk '{print \$2}' | cut -d/ -f1"
alias fzfind='fzf --print0 | xargs -0 -o nvim'
alias zsh_profile='/home/heini/.zshrc'
alias nvimInit='nvim ~/.config/nvim/init.lua'


# functions


function clone() {
    local repo=$1
    local target_dir=$REPOS

    # Define the build directory for AUR packages
    local build_dir=~/build_src_dir
    mkdir -p "$build_dir"

    # Clone AUR packages
    if [[ $repo == http* ]]; then
        if [[ $repo == *aur.archlinux.org* ]]; then
            # Clone the AUR repository
            git -C "$build_dir" clone "$repo"
            local repo_name=$(basename "$repo" .git)
            pushd "$build_dir/$repo_name" > /dev/null

            # Build or install based on the second argument
            if [[ $target_dir == "build" ]]; then
                makepkg --syncdeps
            elif [[ $target_dir == "install" ]]; then
                makepkg -si
            fi

            popd > /dev/null
        else
            # Clone non-AUR links
            git clone "$repo" "$target_dir"
        fi
    else
        # Clone GitHub repos given in the format username/repository
        # Ensure the target directory for plugins exists
        # mkdir -p "$target_dir"
        git -C "$REPOS" clone "https://github.com/$repo.git" --recurse-submodules
    fi
}

function addalias() {
    echo "alias $1='$2'" | sudo tee -a ~/.zshrc
    freshZsh
}


export host1=$(getip)
#host2="heini@192.168.1.71"

function scp_transfer() {
    local direction=$1
    local src_path=$2
    local dest_path=$3
    local host_alias=$4

    # Retrieve the actual host address from the alias
    local host_address=$(eval echo "\$$host_alias")

    if [[ $direction == "TO" ]]; then
        scp $src_path ${host_address}:$dest_path
    elif [[ $direction == "FROM" ]]; then
        scp ${host_address}:$src_path $dest_path
    else
        echo "Invalid direction. Use TO or FROM."
    fi
}

function check_and_install_packages() {
  local missing_packages=()

  # Check which packages are not installed
  for package in "$@"; do
    if ! pacman -Qi "$package" &> /dev/null; then
      missing_packages+=("$package")
    else
      echo "Package '$package' is already installed."
    fi
  done

  # If there are missing packages, ask the user if they want to install them
  if [ ${#missing_packages[@]} -ne 0 ]; then
    echo "The following packages are not installed: ${missing_packages[*]}"
    read -p "Do you want to install them? (Y/n) " -n 1 -r
    echo    # Move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
      for package in "${missing_packages[@]}"; do
        yes | sudo pacman -S "$package"
        if [ $? -ne 0 ]; then
          echo "Failed to install $package. Aborting."
          exit 1
        fi
      done
    else
      echo "The following packages are required to continue:\
      ${missing_packages[*]}. Aborting."
      exit 1
    fi
  fi
}

function check_if_pyEnv_exists() {
    local my_zshrc_dir=~/.zshrc
    local my_virtEnv_dir=~/virtualPyEnvs
    local py_env_name=pyEnv
    local pkg1=python-virtualenv
    local pkg2=python-virtualenvwrapper
    sudo pacman -S --needed --noconfirm $pkg1 $pkg2
    # Check if the virtual environment directory exists
    if [ ! -d "$my_virtEnv_dir" ]; then
        echo "Python Virtualenv and directory doesn't exist, creating it ..."
        sleep 1
        mkdir -p $my_virtEnv_dir
        # Use $1 to check if a custom environment name is provided
        local env_name=${1:-$py_env_name}
        echo "Creating virtual environment: $env_name"
        virtualenv $my_virtEnv_dir/$env_name --system-site-packages --symlinks
	echo "alias startEnv='source /home/$USER/'virtualPyEnvs/pyEnv/bin/activate" >> ~/.zshrc
    else
        echo "Python virtualenv directory exists ..."
        # Check if the standard pyEnv exists or if a custom name is provided
        if [ -z "$1" ] && [ -e "$my_virtEnv_dir/$py_env_name/bin/activate" ]; then
            echo "pyenv directory exists, and no argument, exiting.."
            sleep 2
            exit 1
        else
            # Create a virtual environment with the provided name or the default one
            local env_name=${1:-$py_env_name}
            echo "Creating virtual environment: $env_name"
            virtualenv $my_virtEnv_dir/$env_name --system-site-packages --symlinks
        fi
    fi
}




[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#. /usr/share/LS_COLORS/dircolors.sh
#source /usr/share/LS_COLORS/dircolors.sh
alias ls='lsd'
source /home/heini/.local/share/lscolors.sh
alias startPyEnv='source virtualPyEnvs/pyEnv/bin/activate'
