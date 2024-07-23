# EPICS TOOLS

This is an application to be used with Wavemetrics Igor. Through an Experiment file (.pxp), it adds the capability to load EPICS Archiver's data, wich can then be displayed using Igor's graph tools.
It is meant to be used within Sirius Synchrotron Accelerator Facility.

## Installation

- Copy the EPICS_Tools folder to the 'Igor Pro User Files/User Procedures' folder. You can find the path inside Igor's Help Menu, 'Show Igor Pro User Files'.
- Open the experiment file 'Sirius_X.pxp'

## For Linux Users

- Wavemetrics Igor works only with Windows and Mac Operational Systems. In order to run it under Linux, we use WineHQ.
- Go to the correct version page of WineHQ relative to your Linux distribution and install it.
- On Terminal, use 'winecfg' to check if Wine is working. Install all recommended sofware.
- Download Wavemetrics Igor and install it using 'wine <path to Igor installation file>'.
- Start Igor from the installation window as soon it asks to.
- Go to menu Help > Show Igor Pro Folder, then locate Igor64.exe (usually under IgorBinaries_x64), copy the path.
- To open Igor, use 'wine <path to Igor64.exe>'. You can add a shortcut to desktop using this command.
