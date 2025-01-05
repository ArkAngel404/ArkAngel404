@echo off
echo  -----------------------------------------------
echo  Welcome to the Windows Wacky Workshop!
echo  -----------------------------------------------
echo  Where we fix your PC with a sprinkle of silliness!
echo  Crafted with love by AI (and a little help from Adam Frame)
echo.

echo  Choose your skill level:
echo  1. Beginner Mechanic (Safe and Sound)
echo  2. Advanced Tech Wizard (Handle with Care!)
echo  3. Exit (I'm outta here!)
choice /C 123 /M "Enter your choice:"
goto level_%errorlevel%

:level_1 
echo  -----------------------------------------------
echo  Beginner Mechanic Menu:
echo  -----------------------------------------------
echo  1.  "Doctor, Doctor! My files are missing!" (SFC Scan)
echo  2.  "This PC needs a spa day!" (DISM RestoreHealth)
echo  3.  "My internet is slower than a snail on vacation!" (Network Repair)
echo  5.  "My hard drive is like my closet... full of junk!" (Clear Temp)
echo  7.  "Organize my files like a librarian on a caffeine rush!" (Disk Defrag)
echo  9.  "Windows Update is playing hide-and-seek... and it's winning!" (Fix WU)
echo  11. "Flush those DNS cobwebs!" (ipconfig /flushdns)
echo  12. "Doctor, check my drive for boo-boos!" (Chkdsk)
echo  17. "Open the Windows Update portal!" (ms-settings:windowsupdate)
echo  21. "Restart the audio service... because silence is golden... sometimes!" (Restart Audio Service)
echo  22. "Diagnose my sound! I want to hear the sweet music of success!" (Audio Playback Diagnostic)
echo  25. "Show me my drivers... they're like my PC's little helpers!" (driverquery)
echo  26. "Give me the system info... I want ALL the juicy details!" (systeminfo)
echo  45. "Open System Restore... I'm a time traveler!" (rstrui.exe)
echo  99. Back to Main Menu
choice /C 123579BCDEHIJKL /M "Choose your repair adventure:"
goto beginner_option_%errorlevel%

:beginner_option_1
echo  -----------------------------------------------
echo  "Doctor, Doctor! My files are missing!" (SFC Scan)
echo  -----------------------------------------------
echo  Don't worry, we'll send out the file detectives!
sfc /scannow
echo  Hopefully, they found those missing files!
pause
goto level_1

:beginner_option_2
echo  -----------------------------------------------
echo  "This PC needs a spa day!" (DISM RestoreHealth)
echo  -----------------------------------------------
echo  Time for some deep cleansing and rejuvenation!
Dism /Online /Cleanup-Image /RestoreHealth
echo  Ahhh... that's better. Feeling refreshed?
pause
goto level_1

:beginner_option_3
echo  -----------------------------------------------
echo  "My internet is slower than a snail on vacation!" (Network Repair)
echo  -----------------------------------------------
echo  Let's give your internet a kick in the pants!
netsh winsock reset
netsh int ip reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns
echo  Zoom zoom! Back to full speed!
pause
goto level_1

:beginner_option_4 
echo  -----------------------------------------------
echo  "My hard drive is like my closet... full of junk!" (Clear Temp)
echo  -----------------------------------------------
echo  Time to declutter! Donating all those old files to the digital void...
del /f /s /q "%temp%\*"
rd /s /q "%temp%"
md "%temp%"
del /f /s /q "C:\Windows\Temp\*"
rd /s /q "C:\Windows\Temp"
md "C:\Windows\Temp"
echo  Ah, much cleaner! Marie Kondo would be proud.
pause
goto level_1

:beginner_option_5
echo  -----------------------------------------------
echo  "Organize my files like a librarian on a caffeine rush!" (Disk Defrag)
echo  -----------------------------------------------
echo  Sorting those files alphabetically, chronologically, and by the Dewey Decimal System!
defrag.exe c: /h /v
echo  All nice and tidy!
pause
goto level_1

:beginner_option_6
echo  -----------------------------------------------
echo  "Windows Update is playing hide-and-seek... and it's winning!" (Fix WU)
echo  -----------------------------------------------
echo  Let's give Windows Update a little nudge... or maybe a big shove!
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
echo  Found you! No more hiding, Mr. Update.
pause
goto level_1

:beginner_option_7 
echo  -----------------------------------------------
echo  "Flush those DNS cobwebs!" (ipconfig /flushdns)
echo  -----------------------------------------------
ipconfig /flushdns
echo  Poof! All clean!
pause
goto level_1

:beginner_option_8
echo  -----------------------------------------------
echo  "Doctor, check my drive for boo-boos!" (Chkdsk)
echo  -----------------------------------------------
chkdsk c: /r 
echo  Hmm... let's see what we found...
pause
goto level_1

:beginner_option_9
echo  -----------------------------------------------
echo  "Open the Windows Update portal!" (ms-settings:windowsupdate)
echo  -----------------------------------------------
start ms-settings:windowsupdate
echo  Behold! The gateway to updates!
pause
goto level_1

:beginner_option_10
echo  -----------------------------------------------
echo  "Restart the audio service... because silence is golden... sometimes!" (Restart Audio Service)
echo  -----------------------------------------------
net stop audiosrv
net start audiosrv
echo  Audio service restarted!
pause
goto level_1

:beginner_option_11
echo  -----------------------------------------------
echo  "Diagnose my sound! I want to hear the sweet music of success!" (Audio Playback Diagnostic)
echo  -----------------------------------------------
msdt.exe -id AudioPlaybackDiagnostic
echo  Hopefully, that helped you find your sound!
pause
goto level_1

:beginner_option_12
echo  -----------------------------------------------
echo  "Show me my drivers... they're like my PC's little helpers!" (driverquery)
echo  -----------------------------------------------
driverquery
echo  There you go! A whole list of your driver buddies!
pause
goto level_1

:beginner_option_13
echo  -----------------------------------------------
echo  "Give me the system info... I want ALL the juicy details!" (systeminfo)
echo  -----------------------------------------------
systeminfo
echo  There you go! More system info than you can shake a stick at!
pause
goto level_1

:beginner_option_14
echo  -----------------------------------------------
echo  "Open System Restore... I'm a time traveler!" (rstrui.exe)
echo  -----------------------------------------------
rstrui.exe
echo  Going back in time! 
pause
goto level_1

:beginner_option_15
goto main

:level_2
echo  -----------------------------------------------
echo  Advanced Tech Wizard Menu:
echo  -----------------------------------------------
echo  1.  "Network? Never heard of her!" (Network Reset - Careful!)
echo  2.  "Fix those drive boo-boos!" (Chkdsk /f)
echo  3.  "Wakey wakey, sleepy power settings!" (POWERCFG)
echo  4.  "My graphics card needs an update potion!" (GPUPDATE) 
echo  5.  "Ping that website... with kindness!" (ping digitalcitizen.life)
echo  6.  "Force Windows Update to scan for goodies!" (UsoClient StartScan)
echo  7.  "Download those Windows Update goodies!" (UsoClient StartDownload)
echo  8.  "Install those Windows Update goodies!" (UsoClient StartInstall)
echo  9.  "Register Bluetooth devices... because connectivity is key!" (Regsvr32 bthprops.cpl) 
echo  10. "Release and renew my IP address... like a network butterfly!" (Release/Renew IP)
echo  11. "Refresh those Group Policy settings... it's like a PC power nap!" (gpupdate /force)
echo  12. "Fix my