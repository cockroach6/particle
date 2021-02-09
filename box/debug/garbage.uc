ARCH=x32
DEV=/dev/sdc
USER=`whoami`
PASSWD=kali
BOX_DIR=/media/`whoami`/box

BOX_DEVPART="$DEV"3
BOX_HOME=$BOX_DIR/home
BOX_BRW_DIR=$BOX_DIR/home/.config/chromium
BOX_LOCAL=$BOX_HOME/.local
BOX_PATH=$BOX_DIR/bin:$BOX_LOCAL/bin:\$PATH
BOX=$(echo $(pwd)$(find . -type f -name 'box') | tr -d '.')
VERSION=2.3

BOX_ROOT=(
	$BOX_DIR/bin
	$BOX_DIR/var
	$BOX_DIR/etc
	$BOX_DIR/home
)
BOX_DIRS=(
	$BOX_HOME/Downloads
	$BOX_HOME/git
	$BOX_HOME/dump
	$BOX_HOME/.local
	$BOX_HOME/.ssh
	$BOX_HOME/.config/chromium
	$BOX_HOME/xunison
	$BOX_HOME/shared
)
BOX_FILES=(
	$BOX_HOME/.box-credentials
	$BOX_HOME/.git-credentials
	$BOX_HOME/.gitconfig
	$BOX_HOME/.wreck
)


# system part
if [[ `uname -m` == 'i686' ]]; then
	ARCH=x32
else
	ARCH=x64
fi


_usage()
{
	echo "Usage: box [option]"
	echo "Options:"
	echo " -i                    init box environment"
	echo " -s                    set box environment extensions"
	echo " -c                    clean machine RAM"
	echo " -d                    debug box to improve it"
	echo " -H                    wrapper for command shutdown"
	echo " -p                    download, compile and install user packages"
	echo " -u                    user utils: conn, send"
	echo " -h                    give this help list"
	echo " -v                    show box version"
}


box_init()
{
	printf "Device (default /dev/sdc): "   && read _DEV
	test -z $_DEV || DEV=$_DEV
	test -e $DEV  || (echo -e "\nError: no such disk device \`$DEV'" && exit)

	echo "[*] init disk partition"
	printf "[!] Do you want to format \`box\` disk partition? [y/N] " && read anw
	test $anw = yes || (echo "Abort" && exit)

	test -e $BOX_DIR
	if [[ $? -eq 0 ]]; then
		echo   "[~] Warning: \`box\` partitioin already exists"
		printf "[!] Do you want to format  \`box\` partitioin anyway? [y/N] " && read anw
		test $anw = yes && echo "    [-] Formating disk partitioin" || (echo "Abort" && exit)
	fi

	echo "    [-] make partitioin"
	sudo wipefs --all --force $BOX_DEVPART
	echo -e 'n\n \n \n \n \n p\n w\n' | sudo fdisk $DEV
	sudo mkfs.ext4 $BOX_DEVPART
	sudo e2label $BOX_DEVPART box
	test -e $BOX_DIR || sudo mkdir -p $BOX_DIR
	sudo mount $BOX_DEVPART $BOX_DIR
	sudo chown $USER:$USER -R $BOX_DIR
	rm -rf $BOX_DIR/*

	echo "    [-] make root dir structure"
	for item in ${BOX_ROOT[@]}; do
		mkdir -p $item;
	done
	echo "    [-] make user dir structure"
	for item in ${BOX_DIRS[@]}; do
		echo "$item"
		mkdir -p $item;
	done
	for item in ${BOX_FILES[@]}; do
		echo "$item"
		touch $item
	done

	_save_git_credentials
	_save_new_passwd
	_save_box_itself
}

_save_new_passwd()
{
	echo "    [-] save new password"
	printf "Default password: "            && read _DEF_PASSWD
	printf "New password: "                && read _NEW_PASSWD
	if [[ $_DEF_PASSWD != '' ]]; then
		printf "$_DEF_PASSWD"":" > $BOX_HOME/.box-credentials
	fi
	if [[ $_NEW_PASSWD != '' ]]; then
		echo $_NEW_PASSWD >> $BOX_HOME/.box-credentials
	fi
}
_save_git_credentials()
{
	echo "    [-] init git credentials"
	git config --global user.email "hon.mechanic@gmail.com"
	git config --global user.name "qcockroach"
	git config --global credential.helper store
}
_save_box_itself()
{
	echo "    [-] box saving"
	cp $BOX $BOX_DIR/bin
	echo
}


box_set()
{
	echo "[*] set date and time"
	DATE=$(curl -sI google.com | grep -i date | cut -f 3,4,5,6 -d ' ')
	printf "    [-] Date and Time: " && sudo date --set="$DATE" && echo

	_set_passwd && _datalinks && _setdevs

	# update bash session
	test $SHLVL -le 2 && exec $SHELL
}

# set non-default passwd for more security
_set_passwd()
{
	echo "[*] set new password"
	echo
}

# make symbolic links
_datalinks()
{
	echo "[*] datalinks"
	echo "    [-] update .bashrc file"
	echo -e "\n\n# box's change" >> ~/.bashrc
	echo "PATH=$BOX_PATH && export PATH" >> ~/.bashrc
	test -e $BOX_LOCAL/bin/wd.sh && echo "source $BOX_LOCAL/bin/wd.sh" >> ~/.bashrc
	sudo cp ~/.bashrc /root

	# delete some dirs
	rm -rf $HOME/.local
	rm -rf $HOME/Downloads

	for d in ${BOX_DIRS[@]}; do
		DEST=${d#"$BOX_HOME/"}
		test -e $HOME/$DEST || ln -s $BOX_HOME/$DEST $HOME/$DEST
		echo "    [@] $DEST"
	done
	for f in ${BOX_FILES[@]}; do
		DEST=${f#"$BOX_HOME/"}
		test -e $HOME/$DEST || ln -s $BOX_HOME/$DEST $HOME/$DEST
		echo "    [@] $DEST"
	done
	echo
}

# set user's device parameters
# on keyboard, monitor, mic, stereo, etc
_setdevs()
{
	echo "[*] set user's devices parameters"
	echo "    [-] keyboard"
	setxkbmap -option grp:alt_shift_toggle us,ru

	echo "    [-] monitor"
	xset s off # don't activate screensaver
	xset -dpms # disable DPMS (Energy Star) features.
	#xset s noblank # don't blank the video device
	xrandr | grep 'VGA-1 disconnected' -q
	if [[ $? -eq 1 ]];then
		xrandr --output LVDS-1 --off
	fi

	echo "    [-] stereo"
	pactl set-sink-mute   alsa_output.pci-0000_00_1b.0.analog-stereo 0
	pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo 70%
	echo
}

# download and install user pkgs
_pkgs()
{
	echo "[*] user pkgs"
	SUBLIME_TEXT_URL=https://download.sublimetext.com
	SUBLIME_TEXT_TAR=sublime_text_3_build_3211_x32.tar.bz2
	TELEGRAM_URL=https://telegram.org/dl/desktop/linux32
	TELEGRAM_TAR=telegram.tar.xz
	PARTICLE_URL=https://github.com/qcockroach/particle/archive/main.zip
	PARTICLE_TAR=particle-main


	if [[ $ARCH != 'x32' ]]; then
		SUBLIME_TEXT_TAR=sublime_text_3_build_3211_x64.tar.bz2
		TELEGRAM_URL=https://telegram.org/dl/desktop/linux
	fi

	mkdir -p $BOX_LOCAL/bin

	wget -q --show-progress $SUBLIME_TEXT_URL/$SUBLIME_TEXT_TAR --output-document $SUBLIME_TEXT_TAR 
	tar -xf $SUBLIME_TEXT_TAR && rm -rf $SUBLIME_TEXT_TAR
	(mv sublime_text_3/* $BOX_LOCAL/bin || echo "app's already installed") && rm -rf sublime_text_3

	wget -q --show-progress $TELEGRAM_URL --output-document $TELEGRAM_TAR
	tar -xf $TELEGRAM_TAR && rm -rf $TELEGRAM_TAR
	(mv Telegram/* $BOX_LOCAL/bin || echo "app's already installed") && rm -rf Telegram && echo

	wget -q --show-progress $PARTICLE_URL --output-document $PARTICLE_TAR.zip
	unzip -q $PARTICLE_TAR && cd $PARTICLE_TAR/wd
	make -s init && make -s && make -s install && cd ../..
	rm -rf $PARTICLE_TAR*

	printf "sshpass"
	sudo apt-get install sshpass
	echo
}


_user_utils()
{
	SERVIP=192.168.0.103
	SERVPASS=server98
	SERVDIR=/home/server/dgarb/shared

	case $1 in
		conn )
			sshpass -p "server98" ssh server@$SERVIP
			test $? -eq 6 && ssh server@$SERVIP
			;;
		send )
			printf "Enter file path: " && read filepath

			if [[ -d $filepath || -f $filepath ]]; then
				sshpass -p $SERVPASS scp -r $filepath server@$SERVIP:$SERVDIR
			else
				echo "scp: cannot access '$filepath': No such file or directory" && exit
			fi
	esac
}


box_clean()
{
	echo "[*] clean unnecessary garbage"

	echo "PageCashe, Dentries and inodes"
	sudo sysctl vm.drop_caches=$1

	echo "Browser metadata"
}


box_debug()
{
	echo "[*] debug box"
}


box_halt()
{
	echo '[*] halt machine'
	sudo shutdown now
}


# Interface
while getopts ":isc:Hdpu:hv" opt; do
	case ${opt} in
		i)
			box_init ;;
		s)
			box_set ;;
		c)
			box_clean $OPTARG;;
		d)
			box_debug ;;
		H)
			box_halt ;;
		p)
			_pkgs ;;
		u)
			_user_utils $OPTARG ;;
		h)
			_usage ;;
		v)
			echo "box (particle) $VERSION" ;;
		:)
			echo "Option -$OPTARG requires argument" ;;
	   \?)
			echo "Unknown option character \`-$OPTARG'";;
	esac
	exit
done
echo "box gets one necessary option. Type \`box -h' for more information"
