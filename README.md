# borgcronic
A cron script to run Borg Backup

## Install

    sudo ./borgcronic install

## Configure
Edit file `/etc/borgcronic.conf`.

After editing the configuration, the daemon must be restarted:

    sudo systemctl restart borgcronic

## Status

    sudo borgcronic last

## View available archives

    sudo borgcronic exec list

## Extract an archive

    sudo borgcronic exec extract /my/path/to/borg::machine_20190101_1234 home/myuser
