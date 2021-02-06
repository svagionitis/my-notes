# Add existing user to an existing group

If you want to add user `stavros` to group `postgres`, you do `usermod -a -G postgres stavros`.
See the example below

```
$ groups stavros
stavros : stavros adm dialout cdrom floppy sudo audio dip video plugdev netdev lpadmin scanner lxd sambashare vboxsf
$ sudo usermod -a -G postgres stavros
$ groups stavros
stavros : stavros adm dialout cdrom floppy sudo audio dip video plugdev netdev lpadmin scanner lxd sambashare vboxsf postgres
```

## Resources

* https://www.howtogeek.com/50787/add-a-user-to-a-group-or-second-group-on-linux/
