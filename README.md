# borgcronic
A cron script to run Borg Backup

## Install

    sudo ./borgcronic install

## Configure
Edit file `/etc/borgcronic.conf`.

After editing the configuration, the daemon must be restarted:

    sudo systemctl restart borgcronic

## Configure with remote borg server

In this setup, we connect to a remote borgbackup server through ssh.
Since borgbackup will run locally as root, we must create a new ssh profile
for root.

    su -

First create a new ssh key:

    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_borg_$HOSTNAME -N ""

Print the new key that we will add later to server authorized_keys:

    cat ~/.ssh/id_ed25519_borg_$HOSTNAME.pub

Then we create a new entry in ~/.ssh/config:

    Host borgbackup
        User           <borg user>
        HostName       <borg server>
        IdentityFile   ~/.ssh/id_ed25519_borg_<hostname>

Replace `<borg_user>`, `<borg_server>` and `<hostname>` as necessary.

We must now add this new ssh key to the remote server. For added security (and in fact
the whole point of running a borg server), we restrict that ssh key to only run <code>borg serve</code>. 
Login into the remote server, and add to `~/.ssh/authorized_keys`:

    command="/usr/local/bin/borg serve --restrict-to-path /path/to/borg/" <ssh-ed25519 AAAAC.... root@...>

Again, edit `/path/to/borg/` and `<ssh-ed25519 AAAAC.... root@...>` as necessary.

We must connect once to add the remote server to `known_hosts`:

    ssh borgbackup
    <ctrl-C>

Finally, edit `/etc/borgcronic.conf` to use the remote server. `/path/to/borg` must match
the path specified in file `~/.ssh/authorized_keys` on the server:

    ## BORG_REPO - mandatory
    BORG_REPO=borgbackup:/path/to/borg

After editing the configuration, the daemon must be restarted:

    sudo systemctl restart borgcronic

See also Borg documentation for [SSH config tips](https://borgbackup.readthedocs.io/en/stable/usage/serve.html).

## Status

    sudo borgcronic last

## View available archives

    sudo borgcronic exec list

## Extract an archive

    # Note: path DO NOT start with a trailing /
    sudo borgcronic exec extract /my/path/to/borg::machine_20190101_1234 home/myuser
