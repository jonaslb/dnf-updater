#!/usr/bin/bash
#
# Dnf update based on galliumos-update
#

ANSI_RED='\x1b[31m'
ANSI_CYA='\x1b[36m'
ANSI_WHT='\x1b[37m'
ANSI_HI='\x1b[1m'
ANSI_RST='\x1b[0m'

echo_banner() {
/bin/echo -e ${ANSI_CYA}${ANSI_HI}
# Generated via
# https://patorjk.com/software/taag/#p=testall&h=3&v=0&f=Alpha&t=dnf%20updater
cat << 'EOBANNER'
     _        __                   _       _            
    | |      / _|                 | |     | |           
  __| |_ __ | |_   _   _ _ __   __| | __ _| |_ ___ _ __ 
 / _` | '_ \|  _| | | | | '_ \ / _` |/ _` | __/ _ | '__|
| (_| | | | | |   | |_| | |_) | (_| | (_| | ||  __| |   
 \__,_|_| |_|_|    \__,_| .__/ \__,_|\__,_|\__\___|_|   
                        | |                             
                        |_|                             
EOBANNER
    /bin/echo -e "   ${ANSI_RST}${ANSI_WHT}${VERSION}${ANSI_RST}"
}

echo_cmd()   { /bin/echo -e "${ANSI_CYA}${*}${ANSI_RST}"; }
echo_err()   { /bin/echo -e "${ANSI_RED}${*}${ANSI_RST}"; }
echo_title() { /bin/echo -e "\n${ANSI_HI}${ANSI_WHT}${*}${ANSI_RST}"; }

sudo_dnf() {
    cmd="sudo dnf $*"
    echo_cmd $cmd

    /bin/echo -e "${ANSI_WHT}\c"
    eval "$cmd"
    rc=$?
    /bin/echo -e "${ANSI_RST}\c"
    [ "$rc" -ne 0 ] && echo_err "\"$cmd\" returned an error. Proceed with caution." && return $rc
    return 0
}

hold() {
    echo_title "Press [enter] to close window: ${ANSI_RST}\c"
    read cr
}

echo_banner

if [ "$(id -u)" -eq 0 -o "$(groups | grep -w wheel)" ]; then
    echo_title "Updating packages..."
    sudo_dnf update
    RET_VAL=$(($RET_VAL+$?))
else
    echo_err "\n$(basename $0): fatal: must be root or in \"wheel\" group."
fi

hold

exit $RET_VAL