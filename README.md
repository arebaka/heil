# heil v1.0
*head | tail*

> An easy tool for output one line with a specified number from a file or one from each file

## Usage
`heil [options...] <lineno> <filename>`
or
`heil [options...] <lineno> <filenames...>`

Lines are indexed from 1 (1, 2, 3, etc.)  
The name of tool (heil) is a play on words head and tail, the names of utils  
that previously had to be run through the pipeline to get the same result.

## Options
- `-<integer>`  – output also some lines before
- `+<integer>`  – output also some lines after
- `+-<integer>` – output lines both before and after

if several options of the same sign are specified, they will add up to the total sum.  
e.g.
```bash
heil +2 -4 +3 +-1 -5 90 myfile.sh
```
will output the line 90, 10 lines before (4 + 1 + 5) and 6 lines after (2 + 3 + 1).  
You will see lines 80 to 96.  
If the frame is outside real limits of the file, the excess is ignored.

## Install
Just copy the `heil.sh` file to `/usr/bin/heil`
