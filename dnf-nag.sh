#!/usr/bin/bash
#
# Nag the user about available updates
# Idea from galliumos-update-notifier.
# However simplified a lot
# assume the system updates the cache and just nag the user for any updates.
#

[ "$(groups | grep -w wheel)" ] || exit 0
[ "$1" = '--delay' ] && sleep 10

dnf -q -C check-update > /dev/null

if [ "$?" == "100" ] ; then
    echo "Notifying for updates"
    notify-send \
        -t 1800 \
        -u critical \
        -a "DNF Updater" \
        -i system-software-update \
        "Updates available!" \
        "Run DNF Updater to update the system."
else
    echo "Not notifying for updates"
fi
