# Wget command for mirroroing a website

Next following the command for mirroring a website ${WEBSITE}

```
wget --debug \
     --mirror \
     --timestamping \
     --convert-links \
     --backup-converted \
     --adjust-extension \
     --page-requisites \
     --wait 30 \
     --random-wait \
     --continue \
     --limit-rate=50k \
     --no-if-modified-since \
     --append-output="${WEBSITE}.log" \
     --rejected-log="${WEBSITE}-rejected.log" \
     --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" \
     ${WEBSITE}

```

`--debug`:
    Turn on debug output, meaning various information important to the developers of Wget if it does not work properly. Your system administrator may have chosen to compile Wget without debug support, in which case `-d` will not work. Please note that compiling with debug support is always safe—Wget compiled with the debug support will not print any debug info unless requested with `-d`. See Reporting Bugs, for more information on how to use `-d` for sending bug reports.

`--mirror`:
    Turn on options suitable for mirroring. This option turns on recursion and time-stamping, sets infinite recursion depth and keeps FTP directory listings. It is currently equivalent to `-r -N -l inf --no-remove-listing`.

`--timestamping`:
    Turn on time-stamping. See [Time-Stamping](https://www.gnu.org/software/wget/manual/wget.html#Time_002dStamping), for details.

`--convert-links`:
    After the download is complete, convert the links in the document to make them suitable for local viewing. This affects not only the visible hyperlinks, but any part of the document that links to external content, such as embedded images, links to style sheets, hyperlinks to non-HTML content, etc.

    Each link will be changed in one of the two ways:

        * The links to files that have been downloaded by Wget will be changed to refer to the file they point to as a relative link. Example: if the downloaded file `/foo/doc.html` links to `/bar/img.gif`, also downloaded, then the link in doc.html will be modified to point to `../bar/img.gif`. This kind of transformation works reliably for arbitrary combinations of directories.
        * The links to files that have not been downloaded by Wget will be changed to include host name and absolute path of the location they point to. Example: if the downloaded file `/foo/doc.html` links to `/bar/img.gif` (or to `../bar/img.gif`), then the link in `doc.html` will be modified to point to `http://hostname/bar/img.gif`.

    Because of this, local browsing works reliably: if a linked file was downloaded, the link will refer to its local name; if it was not downloaded, the link will refer to its full Internet address rather than presenting a broken link. The fact that the former links are converted to relative links ensures that you can move the downloaded hierarchy to another directory.

    Note that only at the end of the download can Wget know which links have been downloaded. Because of that, the work done by `-k` will be performed at the end of all the downloads.

`--backup-converted`:
    When converting a file, back up the original version with a `.orig` suffix. Affects the behavior of `-N` (see [HTTP Time-Stamping Internals](https://www.gnu.org/software/wget/manual/wget.html#HTTP-Time_002dStamping-Internals)).

`--adjust-extension`:
    If a file of type `application/xhtml+xml` or `text/html` is downloaded and the URL does not end with the regexp `\.[Hh][Tt][Mm][Ll]?`, this option will cause the suffix `.html` to be appended to the local filename. This is useful, for instance, when you’re mirroring a remote site that uses `.asp` pages, but you want the mirrored pages to be viewable on your stock Apache server. Another good use for this is when you’re downloading CGI-generated materials. A URL like `http://site.com/article.cgi?25` will be saved as `article.cgi?25.html`.

    Note that filenames changed in this way will be re-downloaded every time you re-mirror a site, because Wget can’t tell that the local X.html file corresponds to remote URL `X` (since it doesn’t yet know that the URL produces output of type `text/html` or `application/xhtml+xml`.

    As of version 1.12, Wget will also ensure that any downloaded files of type `text/css` end in the suffix `.css`, and the option was renamed from `--html-extension`, to better reflect its new behavior. The old option name is still acceptable, but should now be considered deprecated.

    As of version 1.19.2, Wget will also ensure that any downloaded files with a Content-Encoding of `br`, `compress`, `deflate` or `gzip` end in the suffix `.br`, `.Z`, `.zlib` and `.gz` respectively.

    At some point in the future, this option may well be expanded to include suffixes for other types of content, including content types that are not parsed by Wget.

`--page-requisites`:
    This option causes Wget to download all the files that are necessary to properly display a given HTML page. This includes such things as inlined images, sounds, and referenced stylesheets.

    Ordinarily, when downloading a single HTML page, any requisite documents that may be needed to display it properly are not downloaded. Using `-r` together with `-l` can help, but since Wget does not ordinarily distinguish between external and inlined documents, one is generally left with “leaf documents” that are missing their requisites.

    For instance, say document `1.html` contains an `<IMG>` tag referencing `1.gif` and an `<A>` tag pointing to external document `2.html`. Say that `2.html` is similar but that its image is `2.gif` and it links to `3.html`. Say this continues up to some arbitrarily high number.

    If one executes the command:

```
        wget -r -l 2 http://site/1.html
```

    then `1.html`, `1.gif`, `2.html`, `2.gif`, and `3.html` will be downloaded. As you can see, `3.html` is without its requisite `3.gif` because Wget is simply counting the number of hops (up to 2) away from `1.html` in order to determine where to stop the recursion.


    However, with this command:

```
        wget -r -l 2 -p http://site/1.html
```

    all the above files and `3.html`’s requisite `3.gif` will be downloaded. Similarly,

```
        wget -r -l 1 -p http://site/1.html
```

    will cause `1.html`, `1.gif`, `2.html`, and `2.gif` to be downloaded. One might think that:

```
        wget -r -l 0 -p http://site/1.html
```

    would download just `1.html` and `1.gif`, but unfortunately this is not the case, because `-l 0` is equivalent to `-l inf`—that is, infinite recursion. To download a single HTML page (or a handful of them, all specified on the command-line or in a `-i` URL input file) and its (or their) requisites, simply leave off `-r` and `-l`:

```
        wget -p http://site/1.html
```

    Note that Wget will behave as if `-r` had been specified, but only that single page and its requisites will be downloaded. Links from that page to external documents will not be followed. Actually, to download a single page and all its requisites (even if they exist on separate websites), and make sure the lot displays properly locally, this author likes to use a few options in addition to `-p`:

```
        wget -E -H -k -K -p http://site/document
```

    To finish off this topic, it’s worth knowing that Wget’s idea of an external document link is any URL specified in an `<A>` tag, an `<AREA>` tag, or a `<LINK>` tag other than `<LINK REL="stylesheet">`.

`--wait`:
    Wait the specified number of seconds between the retrievals. Use of this option is recommended, as it lightens the server load by making the requests less frequent. Instead of in seconds, the time can be specified in minutes using the `m` suffix, in hours using `h` suffix, or in days using d suffix.

    Specifying a large value for this option is useful if the network or the destination host is down, so that Wget can wait long enough to reasonably expect the network error to be fixed before the retry. The waiting interval specified by this function is influenced by `--random-wait`, which see.

`--random-wait`:
    Some web sites may perform log analysis to identify retrieval programs such as Wget by looking for statistically significant similarities in the time between requests. This option causes the time between requests to vary between `0.5` and `1.5` * `wait` seconds, where `wait` was specified using the `--wait` option, in order to mask Wget’s presence from such analysis.

    A 2001 article in a publication devoted to development on a popular consumer platform provided code to perform this analysis on the fly. Its author suggested blocking at the class C address level to ensure automated retrieval programs were blocked despite changing DHCP-supplied addresses.

    The `--random-wait` option was inspired by this ill-advised recommendation to block many unrelated users from a web site due to the actions of one.

`--continue`:
    Continue getting a partially-downloaded file. This is useful when you want to finish up a download started by a previous instance of Wget, or by another program. For instance:

```
        wget -c ftp://sunsite.doc.ic.ac.uk/ls-lR.Z
```

    If there is a file named `ls-lR.Z` in the current directory, Wget will assume that it is the first portion of the remote file, and will ask the server to continue the retrieval from an offset equal to the length of the local file.

    Note that you don’t need to specify this option if you just want the current invocation of Wget to retry downloading a file should the connection be lost midway through. This is the default behavior. `-c` only affects resumption of downloads started prior to this invocation of Wget, and whose local files are still sitting around.

    Without `-c`, the previous example would just download the remote file to `ls-lR.Z.1`, leaving the truncated `ls-lR.Z` file alone.

    If you use `-c` on a non-empty file, and the server does not support continued downloading, Wget will restart the download from scratch and overwrite the existing file entirely.

    Beginning with Wget 1.7, if you use `-c` on a file which is of equal size as the one on the server, Wget will refuse to download the file and print an explanatory message. The same happens when the file is smaller on the server than locally (presumably because it was changed on the server since your last download attempt)—because “continuing” is not meaningful, no download occurs.

    On the other side of the coin, while using `-c`, any file that’s bigger on the server than locally will be considered an incomplete download and only (`length(remote) - length(local)`) bytes will be downloaded and tacked onto the end of the local file. This behavior can be desirable in certain cases—for instance, you can use `wget -c` to download just the new portion that’s been appended to a data collection or log file.

    However, if the file is bigger on the server because it’s been changed, as opposed to just appended to, you’ll end up with a garbled file. Wget has no way of verifying that the local file is really a valid prefix of the remote file. You need to be especially careful of this when using `-c` in conjunction with `-r`, since every file will be considered as an "incomplete download" candidate.

    Another instance where you’ll get a garbled file if you try to use `-c` is if you have a lame HTTP proxy that inserts a “transfer interrupted” string into the local file. In the future a “rollback” option may be added to deal with this case.

    Note that `-c` only works with FTP servers and with HTTP servers that support the `Range` header.

`--limit-rate`:
    Limit the download speed to amount bytes per second. Amount may be expressed in bytes, kilobytes with the `k` suffix, or megabytes with the `m` suffix. For example, `--limit-rate=20k` will limit the retrieval rate to `20KB/s`. This is useful when, for whatever reason, you don’t want Wget to consume the entire available bandwidth.

    This option allows the use of decimal numbers, usually in conjunction with power suffixes; for example, `--limit-rate=2.5k` is a legal value.

    Note that Wget implements the limiting by sleeping the appropriate amount of time after a network read that took less time than specified by the rate. Eventually this strategy causes the TCP transfer to slow down to approximately the specified rate. However, it may take some time for this balance to be achieved, so don’t be surprised if limiting the rate doesn’t work well with very small files.

`--no-if-modified-since`:
    Do not send `If-Modified-Since` header in `-N` mode. Send preliminary HEAD request instead. This has only effect in `-N` mode.

`--append-output=logfile`:
    Append to `logfile`. This is the same as `-o`, only it appends to logfile instead of overwriting the old log file. If logfile does not exist, a new file is created.

`--rejected-log=logfile`:
    Logs all URL rejections to `logfile` as comma separated values. The values include the reason of rejection, the URL and the parent URL it was found in.

`--user-agent=agent-string`:
    Identify as `agent-string` to the HTTP server.

    The HTTP protocol allows the clients to identify themselves using a `User-Agent` header field. This enables distinguishing the WWW software, usually for statistical purposes or for tracing of protocol violations. Wget normally identifies as `Wget/version`, version being the current version number of Wget.

    However, some sites have been known to impose the policy of tailoring the output according to the `User-Agent`-supplied information. While this is not such a bad idea in theory, it has been abused by servers denying information to clients other than (historically) Netscape or, more frequently, Microsoft Internet Explorer. This option allows you to change the `User-Agent` line issued by Wget. Use of this option is discouraged, unless you really know what you are doing.

    Specifying empty user agent with `--user-agent=""` instructs Wget not to send the User-Agent header in HTTP requests.
    See [here](https://en.wikipedia.org/wiki/User_agent) for more information.

See the wget documentation [here](https://www.gnu.org/software/wget/manual/wget.html) for more information.
