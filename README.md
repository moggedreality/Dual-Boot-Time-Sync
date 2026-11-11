# Dual-Boot-Time-Sync
Windows batch script that restores your preferred time zone and resyncs the clock on every boot. Made for Linux/Windows dual-boot setups.

Dual-booting Linux and Windows often leaves the clock wrong in one of them, or leaves Windows on the wrong time zone. To Fix this Pain in the Ass, 

TimeZoneSync is a single .bat file. You run it once, pick your time zone, and it installs itself as a startup task. On every boot after that it quietly sets your time zone, resyncs the clock, and closes by itself. There are no dependencies and nothing to install beyond the file itself.

# Features

One file, with a guided first-time setup menu
Choose from common time zones, type any Windows time zone ID, or keep the zone Windows is using right now
Checks the time zone ID is valid before saving it
Installs itself permanently as a startup task (Task Scheduler, runs as SYSTEM at boot)
Applies your zone and resyncs the clock on every boot, silently, and closes automatically
Retries the clock sync a few times if the network isn’t up yet at boot
Re-run the file any time to change the zone or uninstall
Shows uninstall instructions and a “setup complete” screen after setup
Asks for admin rights automatically
