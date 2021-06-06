#!/bin/bash

DEV=/dev/sdc                    # where your 'Live USB' mounted. Use fdisk for more info
USER=`whoami`                   #
PASSWD=kali                     # user password. You can change it for more security
BOX_DIR=/media/$USER/box        # path to additional partition for saving data

BOX_DEVPART="$DEV"3
BOX_HOME=$BOX_DIR/home/$USER
BOX_BRW_DIR=$BOX_DIR/home/.config/chromium
BOX_LOCAL=$BOX_HOME/.local
BOX_PATH=$BOX_DIR/bin:$BOX_LOCAL/bin
VERSION=2.0

BOX_ROOT=(
    $BOX_DIR/bin
    $BOX_DIR/var
    $BOX_DIR/etc
    $BOX_DIR/home
)
BOX_DIRS=(
    # user dirs
    $BOX_HOME/cockroach               # my private place
    $BOX_HOME/food                    # data that I can lose if it stays on my machine
    $BOX_HOME/dump                    # git repo where I save unfinished projects

    $BOX_HOME/git                     # rest of git repos
    $BOX_HOME/shared                  # shared directory with my local server
    $BOX_HOME/Downloads               # to not lose downloaded data after reboot machine
    $BOX_HOME/priv                    # my private zone for credentials, data, etc
    $BOX_HOME/garbage                 # to store garbage files and peice of code
    $BOX_HOME/.local                  # user programs
    $BOX_HOME/.ssh                    # ssh keys
    $BOX_HOME/.config/chromium        # browser metadata
    $BOX_HOME/.config/sublime-text-3  # IDE metadata
    $BOX_HOME/.anydesk
)
BOX_FILES=(
    $BOX_HOME/.box-credentials  # config file for my box program
    $BOX_HOME/.git-credentials
    $BOX_HOME/.gitconfig
    $BOX_HOME/.wreck            # config file for my util program
)


particle_init()
{
    _init_user_prompt && test $? -eq 0 || exit 1

    echo "  Make disk partitioin"
    sudo wipefs --all --force $BOX_DEVPART
    echo -e 'n\n \n \n \n \n p\n w\n' | sudo fdisk $DEV
    sudo mkfs.ext4 $BOX_DEVPART
    sudo e2label $BOX_DEVPART box
    test -e $BOX_DIR || sudo mkdir -p $BOX_DIR
    sudo mount $BOX_DEVPART $BOX_DIR
    sudo chown $USER:$USER -R $BOX_DIR
    rm -rf $BOX_DIR/*

    _init_fs_struct 0 && test $? -eq 0 || exit 1

    _init_save_git_creden
    _init_save_new_passwd

    _init_install_particles
}


_init_install_particles ()
{

	# box
    echo "    [-] box  is saved"
	cp box/box* $BOX_DIR/bin # box and box.sh (helper)

	# redb
	cp redb/redb* $BOX_LOCAL/bin
    echo "    [-] redb is saved"

    # wd
    make -C wd
    cp wd/_wd $BOX_LOCAL/bin
    cp wd/wd.sh $BOX_LOCAL/bin

    # nuke


	echo
}


_init_user_prompt()
{
    echo "Init disk partition"
    test -z $_DEV || DEV=$_DEV && test -b $DEV # && echo "OK $DEV" || echo "ERR $DEV"

    if [[ $? -eq 1 ]]; then
        echo -e "  Error: no such disk device \`$DEV'"
        return 1
    fi

    printf "  Do you want to format \`box\` disk partition? [y/N] " && read anw
    if [[ $anw != 'yes' ]]; then
        echo "Abort" && return 1
    fi

    if [[ -d $BOX_DIR ]]; then
        echo "  Warning: \`box\` partitioin exists already."
        printf "  Do you want to format \`box\` partitioin anyway? [y/N] " && read anw
        if [[ $anw != 'yes' ]]; then
            echo "Abort"
            return 1
        fi
        echo -e "\n  Format disk partitioin"
    fi
    return 0;
}

_init_fs_struct()
{
    if [[ $# -eq 0 ]]; then
        echo "Error: missing argument in _init_fs_struct"
        return 1
    fi

    if [[ $1 -eq 0 ]]; then
        echo "  Make system directories"
        for item in ${BOX_ROOT[@]}; do
            echo "$item" && mkdir -p $item;
        done
    fi

    echo "  Make user directories"
    for item in ${BOX_DIRS[@]}; do
        echo "$item" && mkdir -p $item;
    done

    for item in ${BOX_FILES[@]}; do
        echo "$item" && touch $item
    done
    echo
}


_init_save_new_passwd()
{
    printf "Default password: " && read _DEF_PASSWD
    printf "New password: "     && read _NEW_PASSWD

    if [[ $_DEF_PASSWD == '' || $_NEW_PASSWD == '' ]]; then
        echo -e "Error: password is empty\n"
        _init_save_new_passwd
    fi
    echo "$_DEF_PASSWD:$_NEW_PASSWD" > $BOX_HOME/.box-credentials
}



particle_init
