# Dual-Boot Time Sync

**A lightweight Windows batch script that automatically fixes your system clock and restores your preferred time zone on every boot.**

Made for people running **Linux + Windows dual-boot setups**.

---

## The Problem

Dual-booting Linux and Windows can mess with your system clock.

Linux typically uses the hardware clock (RTC) in UTC, while Windows expects it in local time. This often results in Windows displaying the wrong time after switching between operating systems.

And sometimes, Windows decides to mess with your time zone too.

**This script fixes that. Automatically.**

## Features

- **Single-file solution** – Everything runs from one `.bat` file. No dependencies or additional software required.
- **Guided setup** – An interactive menu makes first-time configuration easy.
- **Custom time zones** – Choose from common time zones or enter any valid Windows time zone ID.
- **Keep current time zone** – Automatically use the time zone Windows is currently configured with.
- **Validation** – Checks whether the selected time zone ID is valid before saving it.
- **Automatic startup** – Creates a Windows Task Scheduler task that runs at every boot.
- **Silent operation** – Applies your saved time zone, synchronizes the clock, and exits without bothering you.
- **Network-aware retries** – Retries time synchronization if your network isn't ready during startup.
- **Easy management** – Run the script again whenever you want to change your time zone or uninstall it.
- **Automatic elevation** – Requests administrator privileges when needed.

## Installation

1. Download or clone this repository.
2. Extract the ZIP file if you downloaded it.
3. Right-click the `.bat` file and select **Run as administrator**.
4. Follow the on-screen setup instructions.
5. Choose your preferred time zone.

That's it!

The script installs a scheduled task and takes care of everything on subsequent boots.

## How It Works

During the initial setup:

1. Requests administrator privileges.
2. Lets you select or enter your preferred Windows time zone.
3. Validates your selection.
4. Creates a scheduled task in Windows Task Scheduler.
5. Configures the task to run as `SYSTEM` at startup.

On every subsequent boot:

1. Restores your saved time zone.
2. Triggers Windows time synchronization.
3. Retries synchronization if the network isn't available yet.
4. Exits silently.

## Download

Getting started is simple:

1. Click the green **Code** button above.
2. Select **Download ZIP**.
3. Extract the downloaded archive.
4. Run the `.bat` file as administrator.

No installation wizard. No dependencies. Just one file.

## Uninstallation

Run the `.bat` file again and follow the on-screen uninstall instructions.

The script provides the necessary steps to remove its scheduled task and configuration.

## Requirements

- Windows 10 / Windows 11
- Administrator privileges (for initial setup)
- Internet connection for automatic time synchronization

## Feel free to Pull Req <3

---

**Made to fix one of the most annoying little problems with dual-booting.**
