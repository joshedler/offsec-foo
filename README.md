# offsec-foo

A collection of scripts I use as part of my offensive security fun.

## scripts

### `easy_serve.py`
Based upon python3's `http.server`, extends its functionality to allow serving
specific files from locations outside the current directory. The simple 
use-case here is an annoyance always having to `locate` the files I want to 
transfer to a target machine, `pushd` into that directory, run python3's
`http.server`, and finally `popd` back to my working directory.

Now, `easy_serve.py` can serve up all files under a folder structure just like
`http.server`, and if it encounters a special request matching one of a set of
shortcut keys, it will serve that file instead.

For example, set up two terminals.

Terminal #1:
```
$ ./easy_serve.py 
Loaded 1 user shortcuts from local_shortcuts.json.
Serving HTTP on eth0: 192.168.56.130 port 8000 ...
Serving HTTP on tun0: 10.10.14.14 port 8000 ...
```

Terminal #2:
```
$ curl -v http://10.10.14.14:8000/nc.exe  
*   Trying 10.10.14.14:8000...
* Connected to 10.10.14.14 (10.10.14.14) port 8000 (#0)
> GET /nc.exe HTTP/1.1
> Host: 10.10.14.14:8000
> User-Agent: curl/7.72.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
* HTTP 1.0, assume close after body
< HTTP/1.0 200 OK
< Server: SimpleHTTP/0.6 Python/3.8.5
< Date: Fri, 18 Sep 2020 15:48:31 GMT
< Content-type: application/x-msdos-program
< Content-Length: 59392
< Last-Modified: Wed, 17 Jul 2019 09:31:43 GMT
< 
Warning: Binary output can mess up your terminal. Use "--output -" to tell 
Warning: curl to output it to your terminal anyway, or consider "--output 
Warning: <FILE>" to save to a file.
* Failure writing output to destination
* Closing connection 0
```

And back in Terminal #1 you'll see the following output:
```
Redirecting path nc.exe to /usr/share/windows-resources/binaries...
10.10.14.14 - - [18/Sep/2020 10:48:31] "GET /nc.exe HTTP/1.1" 200 -
```

Add a file named `local_shortcuts.json` to provide user-specific overrides, so
there's no need to commit potentially personal folder structure information
into the script. Here's an example:

```
{
    "winPEAS.exe" : "/home/kali/peas/winPEAS/winPEASexe/winPEAS/bin/Release"
}
```
