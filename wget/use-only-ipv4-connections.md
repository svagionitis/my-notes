# Use only IPv4 connections

Either you create a `.wgetrc` file in your home directory and add the following

```
    inet4_only = on
```

which will be used in all the `wget` commands. Or you just add `--inet4-only` only for the specific command.

See the following for more info
* https://askubuntu.com/questions/944778/wget-and-ipv6-problem
* https://www.gnu.org/software/wget/manual/wget.html#Wgetrc-Commands
