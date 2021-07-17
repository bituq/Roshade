# Roshade [![Roshade](https://badgen.net/badge/visit/Roshade.com/orange)](https://Roshade.com/) [![NSIS](https://badgen.net/badge/NSIS/3.06.1/cyan)](https://nsis.sourceforge.io/Download)

An installation package made for correctly installing Reshade presets and shaders to the Roblox directory.

## Key features:
- Uses registry to locate and uninstall Roblox to avoid incorrect uninstalls.
- Selecting essential reshade keybinds during installation.
- Previously unknown errors are now resolved through dialog messages.
- Description of system requirements for each component.
- Automatically installs the required shaders from github.

## Building the source
The installer is written in [NSIS](https://nsis.sourceforge.io/Download "Download NSIS"), so make sure you have that installed first. I highly recommend reading through the NSIS [reference](https://nsis.sourceforge.io/Docs/Contents.html) before proceeding.
### Libraries

Some dependencies may be installed to the NSIS directory, or otherwise to the repository's *Setup\Util* folder. For more information on installing plugins to the NSIS directory, click [here](https://nsis.sourceforge.io/How_can_I_install_a_plugin).
##### NSIS Directory:
- [NScurl](https://github.com/negrutiu/nsis-nscurl)
- [Nsisunz](https://github.com/past-due/nsisunz)
- [NsProcess](https://nsis.sourceforge.io/mediawiki/index.php?title=NsProcess_plugin&oldid=24277)
##### Setup\Util folder:
- [MoveFileFolder](https://nsis.sourceforge.io/MoveFileFolder)
- [GetSectionNames](https://nsis.sourceforge.io/Get_all_section_names_of_INI_file)
- [Explode](https://nsis.sourceforge.io/Explode)
- [StrContains](https://nsis.sourceforge.io/StrContains)
- [ConfigRead](https://nsis.sourceforge.io/ConfigRead)
