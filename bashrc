# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
PS1='$(cat /sys/class/power_supply/BAT1/capacity) ${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias proxy='source /usr/local/bin/set_proxy.sh'
alias unproxy='unset http_proxy'
function brighness()
{
  location="/sys/class/backlight/intel_backlight/brightness"
  if [[ $1 == "set" ]];then
    echo $2 > $location
  fi

  if [[ $1 == "up" ]];then
    echo $(expr `cat $location` + 1250) > $location
  fi

  if [[ $1 == "down" ]];then
    echo $(expr `cat $location` - 1250) > $location
  fi
}

function arduino()
{
cat <<EOF > `pwd`/Makefile
# Arduino Make file. Refer to https://github.com/sudar/Arduino-Makefile

BOARD_TAG    = nano328
include /usr/src/arduino/Arduino.mk
EOF
}
