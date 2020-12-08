# borgcronic
A cron script to run Borg Backup

## Install with local repo

Install borg

    sudo apt install borgbackup            # On Debian / Ubuntu

Install borgcronic

    sudo ./borgcronic install /smb/borgserver/repo      # Local

Edit file `/etc/borgcronic.conf`. After editing the configuration, restart borgcronic daemon.

    sudo systemctl restart borgcronic

Check that it works

    sudo borgcronic exec list              # Get a list, say yes.
    sudo borgronic summon                  # Trigger backup

## Install with SSH server

In this setup, we connect to a remote borgbackup server through ssh.
Since borgbackup will run locally as root, we must create a new ssh profile
for root.

    su -

First create a new ssh key:

    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_borg_$HOSTNAME -N ""

Print the new key that we will add later to server authorized_keys:

    cat ~/.ssh/id_ed25519_borg_$HOSTNAME.pub

Then we create a new entry in ~/.ssh/config (replace `<user>`, `<server>` and `<hostname>` as necessary):

    Host borgbackup
        User           <user>
        HostName       <server>
        ServerAliveInterval 10
        ServerAliveCountMax 30
        IdentityFile   ~/.ssh/id_ed25519_borg_<hostname>

Install borg on client and server:

    sudo apt install borgbackup            # On Debian / Ubuntu

Install borgcronic on client:

    sudo ./borgcronic install borgbackup:/path/to/repo     # SSH

We must now add this new ssh key to the remote server. For added security (and in fact
the whole point of running a borg server), we restrict that ssh key to only run <code>borg serve</code>. 
Login into the remote server, and add to `~/.ssh/authorized_keys`:

    command="/usr/local/bin/borg serve --restrict-to-path /path/to/borg/",restrict <ssh-ed25519 AAAAC.... root@...>

Again, edit `/path/to/borg/` and `<ssh-ed25519 AAAAC.... root@...>` as necessary.

Edit file `/etc/borgcronic.conf`. After editing the configuration, restart borgcronic daemon.

    sudo systemctl restart borgcronic

Bootstrap and check that it works

    ssh borgbackup                         # Say 'yes'
    <ctrl-C>
    sudo borgcronic exec list              # Get a list, say 'yes'
    sudo borgronic summon                  # Trigger backup

We must connect once to add the remote server to `known_hosts`:

See also Borg documentation for [SSH config tips](https://borgbackup.readthedocs.io/en/stable/usage/serve.html).

## Status

    sudo borgcronic last

## View available archives

    sudo borgcronic exec list

## Extract an archive

    # Note: path DO NOT start with a trailing /
    sudo borgcronic exec extract /my/path/to/borg::machine_20190101_1234 home/myuser
