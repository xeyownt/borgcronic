Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run "C:\cygwin64\bin\bash.exe --login -c '/usr/local/bin/borgcronic devil'", 0
Set WshShell = Nothing
