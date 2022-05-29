# Linux command

#### 1. System command

- check ubuntu version -> cat /etc/os-release
- check memory usage -> free
- check disk usage -> df -h --total

- Grant access to file -> sudo chmod +rwx /path/to/file 
- Grant access to folder/subfolder -> sudo chmod -R a+rwx /path/to/folder
  
- chmod +rwx filename to add permissions.
- chmod -rwx directoryname to remove permissions.
- chmod +x filename to allow executable permissions.
- chmod -wx filename to take out write and executable permissions

Ref: [How do you give a full permission to a folder and subfolder in Unix](https://frameboxxindore.com/linux/how-do-i-give-full-permission-to-a-folder-and-subfolders-and-files-in-linux.html)

#### 2. Zip & unzip file
- zip -r compressed_filename.zip foldername
- unzip file.zip -d destination_folder

#### 3. copy file/folder from and to remote server
if you have this ~/.ssh/config:

```
Host test
    User testuser
    HostName test-site.com
    Port 22022

Host prod
    User produser
    HostName production-site.com
    Port 22022
```
you'll save yourself from password entry and simplify scp syntax like this:
```
scp -r prod:/path/foo /home/user/Desktop   # copy to local
scp -r prod:/path/foo test:/tmp            # copy from remote prod to remote test
```

Ref: [How do I copy a folder from remote to local using scp?](https://stackoverflow.com/questions/11304895/how-do-i-copy-a-folder-from-remote-to-local-using-scp)