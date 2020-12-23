# Replace string in multiple files

See https://stackoverflow.com/questions/11392478/how-to-replace-a-string-in-multiple-files-in-linux-command-line

Replace the `gwsdk` with `template` in all .h files

```
sed -i 's/gwsdk/template/g' *.h
```
