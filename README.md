# file-export-robot
A file export tool written in robot to go to a link, log in and download files from an old document platform and save & rename them as new files to be uploaded on a new platform.

A csv file with the below format is used to download and rename the files.

| ID  | Filename        | Link              
|-----|-----------------|-------------------
| 101 | somefile.docx   | any url
| 102 | anotherfile.pdf | any url
| 103 | file.txt        | any url

The reason this was implemented with RobotFramework was because the page sometimes required a sign in, sometimes not and sometimes it had to wait for a popup, and it was eaiser for me to implement that conditions with RobotFramework.
