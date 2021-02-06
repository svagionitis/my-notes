# List groups on linux

## List groups that a user is member of

Use the `groups` command, for example for the logged in user `stavros` I get the following

```
$ groups
stavros adm dialout cdrom floppy sudo audio dip video plugdev netdev lpadmin scanner lxd sambashare vboxsf
```

You can specify the user like following, examples for user `stavros` and `postgres`

```
$ groups stavros
stavros : stavros adm dialout cdrom floppy sudo audio dip video plugdev netdev lpadmin scanner lxd sambashare vboxsf
$ groups postgres
postgres : postgres ssl-cert
```

## List all groups

All groups are on `/etc/group`, so if you do somthing like the following you can see all available groups

```
$ cat /etc/group
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:syslog,stavros
tty:x:5:syslog
disk:x:6:
lp:x:7:
mail:x:8:
news:x:9:
uucp:x:10:
man:x:12:
proxy:x:13:
kmem:x:15:
.
.
.

```

## Resources

* https://linuxize.com/post/how-to-list-groups-in-linux/
