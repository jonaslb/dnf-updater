#!/usr/bin/bash
#
# Nag the user about available updates
# Idea from galliumos-update-notifier.
# However simplified a lot
# assume the system updates the cache and just nag the user for any updates.
#

[ "$(groups | grep -w wheel)" ] || exit 0
[ "$1" = '--delay' ] && sleep 10

dnf -q -C check-update

[ "$?" == "100" ] && {
    echo "Notifying for updates"
    notify-send -t 1800 -u critical -a Updates -i software-update-urgent "Updates available!"
} || {
    echo "Not notifying for updates"
}
