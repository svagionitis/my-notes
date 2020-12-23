See information in this website, https://bitmingw.com/2019/08/28/ubuntu-update-alternatives/


# Changing the Default Program with update alternatives
Posted on 2019-08-28 Edited on 2019-08-27 In tutorial Disqus:

It is common to have multiple versions of the same software installed on a single ubuntu machine. With ubuntu's update-alternatives utility, it is easy to choose the default one to use.

For example, let's assume you have JDK 11 installed in the machine, and by default java points to JDK 11:

```
root@ubuntu:~# java -version
openjdk version "11.0.3" 2019-04-16
OpenJDK Runtime Environment (build 11.0.3+7-Ubuntu-1ubuntu218.04.1)
OpenJDK 64-Bit Server VM (build 11.0.3+7-Ubuntu-1ubuntu218.04.1, mixed mode, sharing)
```

Now you would like to work on a project that only supports JDK 8. After install JDK 8 with `apt-get install openjdk-8-jdk`, JDK 11 is still the default one. How can we make JDK 8 as the default?

Ubuntu keeps track of the default programs by maintaining a list of symbolic links, under /etc/alternatives directory. Each entry here is a shortcut points to the actual program, which may have more than one option (i.e. alternatives).

## List All Entries of Alternatives

To list all entries of alternatives in the system, use `update-alternatives --get-selections`.

```
root@ubuntu:~# update-alternatives --get-selections
...
java                           auto     /usr/lib/jvm/java-11-openjdk-amd64/bin/java
javac                          auto     /usr/lib/jvm/java-11-openjdk-amd64/bin/javac
...
```

You can see java is pointing to actual program at /usr/lib/jvm/java-11-openjdk-amd64/bin/java, which belongs to JDK 11.

## List All Alternatives of an Entry

To list all alternatives of java, use `update-alternatives --list java`.

```
root@ubuntu:~# update-alternatives --list java
/usr/lib/jvm/java-11-openjdk-amd64/bin/java
/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
```

## Set Alternatives for an Entry

To set java to use JDK 8 as the default, you can use an interactive command `update-alternatives --config java`.

```
root@ubuntu:~# update-alternatives --config java
There are 2 choices for the alternative java (providing /usr/bin/java).

  Selection    Path                                            Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      auto mode
  1            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      manual mode
  2            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081      manual mode

Press <enter> to keep the current choice[*], or type selection number:
```

After typing selection number 2, update-alternatives will modify the symbolic link to update the default java to use JDK 8.

```
Press <enter> to keep the current choice[*], or type selection number: 2
update-alternatives: using /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java to provide /usr/bin/java (java) in manual mode

root@ubuntu:~# java -version
openjdk version "1.8.0_212"
OpenJDK Runtime Environment (build 1.8.0_212-8u212-b03-0ubuntu1.18.04.1-b03)
OpenJDK 64-Bit Server VM (build 25.212-b03, mixed mode)
```

You can also do this in a script without interaction, if you know the full path of desired default program.

```
root@ubuntu:~# update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
update-alternatives: using /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java to provide /usr/bin/java (java) in manual mode
```
