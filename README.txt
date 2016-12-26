# waffles

A tool for quickly installing fully-configured Arch systems.

WIP, and very much optimized for the main author.

Usage:

    # loadkeys dvorak   # (if you use dvorak)

    # ip link
    Substitute the wireless link name (like wlp3s0 or wls3) below instead of WLS
    # ip link set WLS up
    Select between the next two options based on whether the network is open or secured with WPA.
    # iw dev WLS connect NETWORK_NAME
    # wpa_supplicant -D nl80211,wext -i WLS -c <(wpa_passphrase "SSID" "PASSWORD") &
    # dhcpcd WLS

    # wget web.mit.edu/cela/w.tgz && sha256sum w.tgz
    Now compare the fingerprint with a fingerprint you trust.
    # tar -xf w.tgz && ./init_disks.sh sda
    Passphrase: your disk and lock screen passphrase
    Pass again: the same

