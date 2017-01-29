# Saltstack Formula: lsyncd

This formula configures a continously running rsync daemon called [lsyncd](https://axkibe.github.io/lsyncd/).


## Features
- Install the required packages
- Configure the configration file for lsyncd from pillars
- Manage the lsyncd service


## Formula Usage

**Setup pillar**
Copy the `pillar.example` directory from this git repository to `/srv/pillar/lsyncd` and put define it in `/srv/pillar/top.sls`

**Apply the formula**
To apply the configuration defined in `/srv/pillar/lsyncd/init.sls` run:
```
salt 'minion' state.sls lsyncd
```

## Requirements

**Passwordless SSH**  
This formula requires the user running `lsyncd` to have passwordless SSH access configured to the client machine.
The [Blunix GmbH SSH Formula](https://github.com/blunix/formula-ssh) can be used to set up a SSH keypair on the `lsyncd`
machine, pushing the public key to the mine to then install it on the "client" machine.

**Sysctl settings**  
As `lsyncd` `inotifywatch`'es the `source` directory for changes. `/proc/sys/fs/inotify/max_user_watches` may have to be increased accordingly, which SaltStack can take care of by using our [Blunix GmbH Server Formula](https://github.com/blunix/formula-server), which includes options for setting sysctl settings. Increasing this may be required to prevent the message:
```
lsyncd: Error, Terminating since out of inotify watches.#012Consider increasing /proc/sys/fs/inotify/max_user_watches
```

You should set a number higher than the amount of subdirectories in the directory that is to be kept in sync, for example:
```
root@web0.example.com ~ # find /var/www -type d | wc -l | tail -n 1
25410
root@web1.example.com /var $ cat /proc/sys/fs/inotify/max_user_watches
8192
root@web1.example.com /var $ echo '8192 * 8' | bc
65536
root@web1.example.com /var $ echo 65536 > /proc/sys/fs/inotify/max_user_watches
```

in `/var/log/syslog`. The `lsyncd` status logfile `/var/log/lsyncd-status.log` will also give you this information:
```
root@web0.example.com ~ # cat /var/log/lsyncd-status.log | grep Inotify
Inotify watching 25410 directories
```


## Testing in Vagrant
Run the following commands:
```
git clone git@github.com:blunix/vagrant_saltstack.git
cd vagrant_saltstack
vagrant up utility
vagrant ssh utility
sudo -Es
```

In the vagrant box, open `/srv/pillar/top.sls` with your favorite editor add add:
```
base:
  '*'
    - lsyncd
```

Take a look at `/srv/pillar/lsyncd/init.sls` and edit it to your requirements. To refresh the pillars and setup the formula:
```
salt 'utility' saltutil.refresh_pillar
salt 'utility' state.sls lsyncd
```

# Contributing
Contributions and bug reports are very welcome!

Please follow these steps to get your changes merged by us:

1. Create an issue describing your change in human language
2. File a pull-request linked to that issue.

# Supported Operating-Systems
- Debian 8
- Ubuntu 14.04
- Ubuntu 16.04

# Enterprise Support
Support for Linux network filesystems, Vagrant Development Environments, Saltstack and more is available at:

Blunix GmbH - Professional Linux Service  
Web: <a href="https://www.blunix.org/" target="_blank">www.blunix.org</a>  
Mail: <mailto:service@blunix.org>

