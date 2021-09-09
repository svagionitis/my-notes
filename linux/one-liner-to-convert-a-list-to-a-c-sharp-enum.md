# One liner to convert a list to a C# enum

The list was copied by a pdf document which was in the following format


```
Message ID  |   Name
-------------------------------------
0x00        |   SLAGetVersionNumber_t
0x01        |   SLAResetAllParameters_t
0x02        |   SLASetStabilizationParameters_t
0x03        |   SLAGetStabilizationParameters_t
0x04        |   SLAResetStabilizationParameters_t
0x05        |   SLAModifyTracking_t
0x06        |   SLASetOverlayMode_t
0x07        |   SLAGetOverlayMode_t
0x08        |   SLAStartTracking_t
0x09        |   SLAStopTracking_t
0x0A        |   SLANudgeTrackingCoordinate_t
...
```


If you copy the above to a text file, it will have the following format


```
0x00
SLAGetVersionNumber_t
0x01
SLAResetAllParameters_t
0x02
SLASetStabilizationParameters_t
0x03
SLAGetStabilizationParameters_t
0x04
SLAResetStabilizationParameters_t
0x05
SLAModifyTracking_t
0x06
SLASetOverlayMode_t
0x07
SLAGetOverlayMode_t
0x08
SLAStartTracking_t
0x09
SLAStopTracking_t
0x0A
SLANudgeTrackingCoordinate_t
...
```

So the format that we want it is the following


```
SLAGetVersionNumber = 0x00,
SLAResetAllParameters = 0x01,
SLASetStabilizationParameters = 0x02,
SLAGetStabilizationParameters = 0x03,
SLAResetStabilizationParameters = 0x04,
SLAModifyTracking = 0x05,
SLASetOverlayMode = 0x06,
SLAGetOverlayMode = 0x07,
SLAStartTracking = 0x08,
SLAStopTracking = 0x09,
SLANudgeTrackingCoordinate = 0x0A,
...
```


## Move the message id and the name in the same line


The first thing we need to do is to move the name in the same line with the message id. In order to do that, we need to remove the new line in every second line. The following `sed` command achieve this


```
sed '1~2N ; s/\n/ /g' SLAMesssageIDCommands.txt
```

where `SLAMesssageIDCommands.txt` is the text file with the commands that we want to convert. The output of the above command is the following


```
0x00 SLAGetVersionNumber_t
0x01 SLAResetAllParameters_t
0x02 SLASetStabilizationParameters_t
0x03 SLAGetStabilizationParameters_t
0x04 SLAResetStabilizationParameters_t
0x05 SLAModifyTracking_t
0x06 SLASetOverlayMode_t
0x07 SLAGetOverlayMode_t
0x08 SLAStartTracking_t
0x09 SLAStopTracking_t
0x0A SLANudgeTrackingCoordinate_t
...
```


The `1~2N` part of `sed` uses the addresses where a specific line can be given to execute the pattern later on. In this case, `first~step` matches every step'th line starting with the line first [0]. In our case
, starting from line 1, the line after it will be added to the pattern space `N` and then the pattern will be executed [1].


## Move the `_t` from the name


To remove the ending `_t` from the name, we execute the following command


```
sed 's/_t$//g'
```

The above command removes the ending `_t` from the name.


## Re-arrange the fields and bring it to the expected format


To bring to the expected output, I use the following `awk` command


```
awk '{ print $2 " = " $1 ","}'
```

which will output the following


```
SLAGetVersionNumber = 0x00,
SLAResetAllParameters = 0x01,
SLASetStabilizationParameters = 0x02,
SLAGetStabilizationParameters = 0x03,
SLAResetStabilizationParameters = 0x04,
SLAModifyTracking = 0x05,
SLASetOverlayMode = 0x06,
SLAGetOverlayMode = 0x07,
SLAStartTracking = 0x08,
SLAStopTracking = 0x09,
SLANudgeTrackingCoordinate = 0x0A,
...
```

which is the expected output.


```
sed '1~2N ; s/\n/ /g' SLAMesssageIDCommands.txt | sed 's/_t$//g' | awk '{ print $2 "=" $1 ","}'
```


## Resources

[0]: https://linux.die.net/man/1/sed
[1]: https://unix.stackexchange.com/a/44465
