# Lecture 02 solutions

### 1) Read 'man ls' and write an 'ls' command that lists files in the following manner

- Includes all files, including hidden files
- Sizes are listed in a human readable format (eg. 454M instead of 454279954)
- Files are ordered by recency
- Output is colorized

A sample output would look like this
```
 -rw-r--r--   1 user group 1.1M Jan 14 09:53 baz
 drwxr-xr-x   5 user group  160 Jan 14 09:53 .
 -rw-r--r--   1 user group  514 Jan 14 06:42 bar
 -rw-r--r--   1 user group 106M Jan 13 12:12 foo
 drwx------+ 47 user group 1.5K Jan 12 18:08 ..
```

Read 'man ls'
```
$ man ls
```

The flags that we need are:  
To include all files, including hidden files (starting with `.`:  
`-a` or `--all`  
To list sizes in a human readable format:  
`-h` or `--human-readable`, with `-l` for long format  
To display the files sorted by recency:  
`-c` with `-lt` - Will sort by, and show, `ctime` (time of last modification of file status information)  
To colorize the output:  
`--color=always`

To combine all the above flags (seems `-l` is unnecessary because we already have `-lt`)
```
ls -a -h -c -lt --color=always
```

### 2) Write bash functions `marco` and `polo`

Whenever you execute `marco` the current working directory should be saved in some manner, then when you execute `polo`, no mwtter what directory you are in, `polo` should `cd` you back to the directory where you executed `marco`. For ease of debugging you can write the code in a file `marco.sh` and (re)load the definitions to your shell by executing `source marco.sh`

Create `marco.sh` file in the `home` directory. We can use a `.` to make it an invisible file.
```
cd ~
touch .marco.sh
```

Open the file witha  text editor (I'm using `nano`)
```
nano .marco.sh
```

Function to store the output of `pwd` in a file called `/tmp/marco.txt`. We will append to the last line every time we call `marco`.
```
function marco() {
	pwd >> /tmp/marco.txt
	echo $(pwd)
}
```

Function to cd into the lst path stored in `/tmp/marco.txt`. We use `cat` to get the file contents, then pipe that output to `tail`, to get only the last line.
```
function polo() {
	cd $(cat /tmp/marco.txt | tail -n1)
	echo $(pwd)
}	
```

We can source `.marco.sh`
```
source .marco.sh
```

We can source them permanently by writing that line in the `~/.bashrc` file.

### 3) Debugger
Say you have a command that fails rarely. In order to debug it you need to capture its output, but it can be time aonsuming to get a failure run. Write a bash script that runs the following script until it fails and captures its standard output and error streams to files and prints everything at the end. Bonus points if you can also report how many runs it took for the script to fail.


```
#!/usr/bin/env bash

n=$(( RANDOM % 100 ))

if [[ n -eq 42 ]]; then
	echo "Something went wrong"
	>&2 echo "The error was using magic numbers"
	exit 1
fi

echo "Everything went according to plan"
```

Create file `fail.sh` and set it's permissions so we can execute it. Use a text editor to write the script in the file. I'm using `nano`.
```
touch fail.sh
chmod 744 fail.sh
```

Create the `debug.sh` script and set it's permissions too.
```
touch debug.sh
chmod 744 debug.sh
```

We can use a loop to make the script run until it fails
`debug.sh`
```
#!/usr/bin/env bash
while [ true ]; do
	./fail.sh || break
done
```
All the output will be printed to the terminal.
We can instead redirect the output to some files with `>>`, and redirect the error codes with `2>>`.  
We can store the paths to the files in variables `std` and `err` for easier reusability.  
We empty the contents of this files before the loop begins, so we fill them from scratch.  
To count the number of executions we need to define a counter variable and increase it on each loop run.  
Finally, we print the content of the files and the counter to the terminal.  

```
#!/usr/bin/env bash

# Store paths in variables
std=/tmp/std.txt
err=/tmp/err.txt

# Empty the files
> $std
> $err

# Counter
count=0

# Run until error occurs
while [ true ]; do
        count=$(( count+1 ))
        ./fail.sh >> $std 2>> $err || break
done

# Print files and counter
echo $(cat $std)
echo $(cat $err)
echo "Runs until error: $count"
```

**For some reason it's omitting the line jumps when printing the contents of the files.**
