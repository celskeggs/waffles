# waffles

A tool for quickly installing fully-configured Arch systems.

WIP, and very much optimized for the main author.

Usage:

    # gpg --keyserver pgp.mit.edu --recv-keys EEA31BFF444304ABB246A0B6C634D0420F825B91
    # gpg --fingerprint
    # curl web.mit.edu/cela/waffles/waffles.tgz.gpg | gpg --decrypt - >waffles.tgz
    # tar -xf waffles.tgz
    # ./init_disks.sh
