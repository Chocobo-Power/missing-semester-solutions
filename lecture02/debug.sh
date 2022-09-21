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
