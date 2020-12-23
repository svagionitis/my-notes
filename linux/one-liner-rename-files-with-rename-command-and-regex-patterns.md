# Rename files in command prompt in one line

See https://stackoverflow.com/questions/9393607/find-and-replace-filename-recursively-in-a-directory

```
find -name "gwsdk*" -exec rename 's/gwsdk/template/' {} \;
```
