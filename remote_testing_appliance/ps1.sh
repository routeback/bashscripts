#!/bin/sh
#
# Name: ps1.sh
# Auth: Frank Cass
# Date: 20160214
# Desc: Quickly set the PS1 terminal prompt.
#
#	Usage: source ps1.sh
#
###

# Blue on White:
# export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[1;34m\]root\[\033[1;37m\]@System:'

# High Contrast Black on White:
# export PS1='\[\e]0;\u1\h: \w\a\]${^Cbian_chroot:+($debian_chroot)}\[\033[1;34m\]root\[\033[0;00m\]@System:'

if [ $0 != /bin/bash ]; then
       echo "[*] Exiting. Script must be sourced."
       echo "[*] Try: source ps1.sh"
       return 1
fi

function ps1_banner () {
echo ""
echo "	    root@YourInputHere:#"
echo "	             _       _     "
echo "	   _ __  ___/ |  ___| |__  "
echo "	  | '_ \/ __| | / __| '_ \ "
echo "	  | |_) \__ \ |_\__ \ | | |"
echo "	  | .__/|___/_(_)___/_| |_|"
echo "	  |_| "; echo ""
echo "	   Quick PS1 Prompt Changer"
echo ""
echo " \"He who rejects change is the architect of decay\""; echo "" # Quote by Harold Wilson
}

function ps1_config () {
echo "[*] Current configuration:" $PS1; echo ""
read -p "[*] Please input what you would like your prompt to display: " input
export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[1;34m\]$(whoami)\[\033[1;39m\]@$input:\[\033[00m\]\$ '
echo "[*] Updated PS1 Set!"
}

function greplscolors () {
read -p "[*] Would you like to change grep and ls colors too? [y/n] " yn; case $yn in
	[yY] | [yY][Ee][Ss] )
		export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=01;34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
		export GREP_COLOR='1;31'
		echo "[*] Grep and ls colors Set!"
                ;;

        [nN] | [n|N][O|o] )
		return 0
                ;;

	*)
                echo "[*] I do not understand"
                ;;
	esac
}

function append_to_bashrc () {
read -p "[*] Would you like to append your updated PS1, grep and ls colors to ~/.bashrc? [y/n] " yn; case $yn in
	[yY] | [yY][Ee][Ss] )
		echo "[*] Appending to ~/.bashrc"
		echo "# [*] New PS1 Configuration:" >> ~/.bashrc
		echo "export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[1;34m\]$(whoami)\[\033[1;39m\]@$input:\[\033[00m\]\$ ' " >> ~/.bashrc
		echo "export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=01;34:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:' " >> ~/.bashrc
		echo "export GREP_COLOR='1;31' " >> ~/.bashrc
		echo "[*] Exiting"
		;;

	[nN] | [n|N][O|o] )
		echo "[*] Exiting"
		;;

	*)
		echo "[*] I do not understand"
		;;
	esac
}

sourced
ps1_banner
ps1_config
greplscolors
append_to_bashrc
