1. Make sure you're running an appropriate shell.
```
echo $SHELL
```
It should say something like **/bin/bash** or **/usr/bin/zsh**

2. Create a new directory called missing under /tmp
```
mkdir /tmp/missing
```

3. Look up the touch program. The man program is your friend
```
man touch
```

4. Use touch to create a file called semester in missing
```
touch /tmp/missing/semester
```


5. Write the following into that file, one line at a time
```
#!/bin/sh
curl --head --silent https://missing.csail.mit.edu
```

We move to the directory with cd
```
$ cd /tmp/missing
```

We can echo the lines and redirect them the to the file.  
The first line can be redirected with >  
We must use single quotes for the first line so the special characters are not replaced.
```
$ echo '#!/bin/sh' > semester
```
Then we can append the second line with >>
```
$ echo "curl --head --silent https://missing.csail.mit.edu >> semester"
```

6. Try to ececute the file, i.e. type the path to the script (./semester) into your shell and press enter. Understand why it doesn't work by consulting the output of ls.

Try to execute the script.
```
$ ./semester
-bash: ./semester: Permission denied
```

We use ls -l to list the contents of the directory in long format, and check the permissions.
```
$ ls -l
total 0
-rw-r--r-- 1 renzo renzo 61 Sep 21 10:44 semester
```
My user can't execute this file.

7. Run the command by explicitly starting the sh interpreter, and giving it the file semester as the first argument, i.e. sh semester. Why does this work, thile ./semester didn't?


With sh semester we can execute the script and see the output printed in the terminal.
```
$ sh semester
HTTP/2 200
server: GitHub.com
content-type: text/html; charset=utf-8
last-modified: Sat, 17 Sep 2022 10:59:54 GMT
access-control-allow-origin: *
etag: "6325a8aa-1f37"
expires: Wed, 21 Sep 2022 12:24:03 GMT
cache-control: max-age=600
x-proxy-cache: MISS
x-github-request-id: 99AA:73C3:51856A:6D814D:632B000B
accept-ranges: bytes
date: Wed, 21 Sep 2022 16:26:53 GMT
via: 1.1 varnish
age: 0
x-served-by: cache-lim12120-LIM
x-cache: HIT
x-cache-hits: 1
x-timer: S1663777614.861770,VS0,VE103
vary: Accept-Encoding
x-fastly-request-id: 49bf5936a19d9404b015601278b74e7fb8d2bedc
content-length: 7991
```
We are executing the sh program and passing the semester file as an argument.  
We have permission to run the sh program and to read the semester file.  
The sh program will read and interpret the semester file.


8. Look up the chmod program (e.g. use man chmod).
```
$ man chmod
```

9. Use chmod to make it possible to run the command ./semester rather than having to type sh semester. How does your shell know that the file is supposed to be interpreted using sh?

```
$ chmod 744 semester
```
We upgrade the permissions of the creator user (owner) of the file, so it also has execute permissions. The group and other users get only read permissions.

The shell knows how to interpret the file using sh thanks to the shebang at the first line: #!/bin/sh


10. Use | and > to write the "last modified" date output by semester into a file called last-modified.txt in your home directory

This question was a little confusing at first. I thought we were supposed to get the "last modified" date of the file itself, which can be done by executing date -r semester

But we want the "last modified" output from executing the ./semester script, so we need to find it with something like grep.

Execute the ./semester script, pipe the output to grep with last-modified as argument
```
$ ./semester | grep last-modified
last-modified: Sat, 17 Sep 2022 10:59:54 GMT
```

Then we can redirect the output of grep to the last-modified.txt file
```
$ ./semester | grep last-modified > ~/last-modifiet.txt
```

Alternative: We can get rid of the "last-modified:" substring by using cut
```
$ ./semester | grep -i last | cut -d ' ' -f 2- > ~/last-modifiet.txt
```
Source: https://medium.com/@rw2268/the-missing-semester-of-your-cs-education-course-overview-the-shell-c8bc31f26b77

Let's check the contents of the last-modified.txt file
```
$ more ~/last-modified.txt
Wed Sep 21 10:44:46 -05 2022
```


11. Write a command that reads out your laptop battery's power level or your desktop machine's CPU temperature from /sys. Note: if you're a macOS user, your OS doesn't have a sysfs, so you can skip this exercise.

```
cat /sys/class/thermal/thermal_zone0/temp
```
Note: Worked on Manjaro, didn't work on WSL.

