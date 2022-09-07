# Bash


### Command	Description	Example

- `&`: &nbsp; Run the previous command in the background `ls &`
- `&&`: &nbsp; Logical AND `if [ "$foo" -ge "0" ] && [ "$foo" -le "9"]`
- `||`:	&nbsp; Logical OR `if [ "$foo" -lt "0" ] || [ "$foo" -gt "9" ]`
- `^`: &nbsp; Start of line `grep "^foo"`
- `$`: &nbsp; End of line `grep "foo$"`
- `=`: &nbsp; String equality `(cf. -eq) if [ "$foo" = "bar" ]`
- `!`: &nbsp; Logical NOT `if [ "$foo" != "bar" ]`
- `$$`: &nbsp; PID of current shell `echo my PID = $$`
- `$!`: &nbsp; PID of last background command `ls & echo "PID of ls = $!"`
- `$?`: &nbsp; exit status of last command `ls ; echo "ls returned code $?"`
- `$0`: &nbsp; Name of current command (as called)	`echo "I am $0"`
- `$1`: &nbsp; Name of current command's first parameter `echo "My first argument is $1"`
- `$9`: &nbsp; Name of current command's ninth parameter `echo "My ninth argument is $9"`
- `$@`: &nbsp; All of current command's parameters (preserving whitespace and quoting) `echo "My arguments are $@"`
- `$*`: &nbsp; All of current command's parameters (not preserving whitespace and quoting) `echo "My arguments are $*"`
- `-eq`: &nbsp; Numeric Equality `if [ "$foo" -eq "9" ]`
- `-ne`: &nbsp; Numeric Inquality `if [ "$foo" -ne "9" ]`
- `-lt`: &nbsp; Less Than	`if [ "$foo" -lt "9" ]`
- `-le`: &nbsp; Less Than or Equal	`if [ "$foo" -le "9" ]`
- `-gt`: &nbsp; Greater Than `if [ "$foo" -gt "9" ]`
`-ge`: &nbsp; Greater Than or Equal `if [ "$foo" -ge "9" ]`
`-z`: &nbsp; String is zero length `if [ -z "$foo" ]`
- `-n`: &nbsp; String is not zero length `if [ -n "$foo" ]`
- `-nt`: &nbsp; Newer Than `if [ "$file1" -nt "$file2" ]`
- `-d`: &nbsp; Is a Directory `if [ -d /bin ]`
- `-f`: &nbsp; Is a File `if [ -f /bin/ls ]`
- `-r`: &nbsp; Is a readable file `if [ -r /bin/ls ]`
- `-w`: &nbsp; Is a writable file `if [ -w /bin/ls ]`
- `-x`: &nbsp; Is an executable file `if [ -x /bin/ls ]`
- `( ... )`: &nbsp; Function definition	`function myfunc() { echo hello }`

## References
[Blog] Steve Parker - [Shell Scripting Tutorial](https://www.shellscript.sh/quickref.html)