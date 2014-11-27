#!/usr/bin/env bash

app_name="OnceVim"
app_dir="$HOME/.OnceVim"
[ -z "$git_uri" ] && git_uri="https://github.com/OnceMore2020/OnceVim.git"
[ -z "$VUNDLE_URI" ] && VUNDLE_URI="https://github.com/gmarik/vundle.git"

msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" -eq '0' ]; then
    msg "\e[32m[✔]\e[0m ${1}${2}"
    fi
}

error() {
    msg "\e[31m[✘]\e[0m ${1}${2}"
    exit 1
}

lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
    ret="$?"
}

clone_repo() {
   git clone "$git_uri" "$app_dir"
   ret="$?"
   success "$1"
}

clone_vundle() {
    if [ ! -e "$HOME/.vim/bundle/vundle" ]; then
        git clone $VUNDLE_URI "$HOME/.vim/bundle/vundle"
    else
        upgrade_repo "vundle"   "Successfully updated vundle"
    fi
    ret="$?"
    success "$1"
}

create_symlinks() {
    endpath="$app_dir"
    if [ ! -d "$endpath/.vim/bundle" ]; then
        mkdir -p "$endpath/.vim/bundle"
    fi
    lnif "$endpath/.vimrc"              "$HOME/.vimrc"
    lnif "$endpath/.vimrc.bundles"      "$HOME/.vimrc.bundles"
    lnif "$endpath/.vim"                "$HOME/.vim"
    ret="$?"
    success "$1"
}

setup_vundle() {
    system_shell="$SHELL"
    export SHELL='/bin/sh'
    vim \
        -u "$app_dir/.vimrc.bundles" \
        "+set nomore" \
        "+BundleInstall!" \
        "+BundleClean" \
        "+qall"
    export SHELL="$system_shell"
    success "$1"
}

clone_repo      "克隆 $app_name 到本地."
create_symlinks "创建软链接"
clone_vundle    "配置Vundle"
setup_vundle    "开始安装"
msg             "\n感谢使用$app_name."
