# Roshade
An installation package made for correctly installing Reshade presets and shaders to the Roblox directory.

## Key features:
- Uses registry to locate and uninstall Roblox to avoid incorrect uninstalls.
- Selecting essential reshade keybinds during installation.
- Previously unknown errors are now resolved through dialog messages.
- Description of system requirements for each component.

## Building the source
The installer uses [NSIS](https://nsis.sourceforge.io/Download "Download NSIS"), so make sure you have that installed first.
### Libraries:
1. [INetC](https://github.com/DigitalMediaServer/NSIS-INetC-plugin)
2. [MoveFileFolder](https://nsis.sourceforge.io/MoveFileFolder)
3. [Nsisunz](https://github.com/past-due/nsisunz)
4. [NsProcess](https://nsis.sourceforge.io/mediawiki/index.php?title=NsProcess_plugin&oldid=24277)
