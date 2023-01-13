# Roshade [![Build](https://github.com/bituq/Roshade/actions/workflows/nsis.yaml/badge.svg?branch=main)](https://github.com/bituq/Roshade/actions/workflows/nsis.yaml) [![Roshade](https://badgen.net/badge/visit/Roshade.com/orange)](https://Roshade.com/) [![NSIS](https://badgen.net/badge/NSIS/3.08/cyan)](https://nsis.sourceforge.io/Download)

Roshade is an installation package that makes it easy to correctly install Reshade presets and shaders to the Roblox directory. With Roshade, you can quickly and easily customize your Roblox experience with advanced visual effects.

## Key features:
- Uses the registry to locate and uninstall Roblox, avoiding any incorrect uninstalls.
- Allows you to select essential Reshade keybinds during installation.
- Resolves previously unknown errors through dialog messages.
- Provides a description of system requirements for each component.
- Automatically installs the required shaders from GitHub.

## Getting Started
To get started with Roshade, you'll first need to download the latest release from the [releases](https://github.com/bituq/Roshade/releases) page. Once you've downloaded the installer, simply run it and follow the prompts to install Roshade. Once installation is complete, you'll be able to launch Roblox and start customizing your visual experience with the included Reshade presets and shaders.

If you have any questions or issues with Roshade, please feel free to open an issue on the GitHub repository, or visit the [Roshade website](https://roshade.com/) for more information.

## Building the source
The installer is written in [NSIS](https://nsis.sourceforge.io/Download "Download NSIS"), a popular open-source tool for creating Windows installers. To build the source, you'll need to have NSIS installed on your machine. I highly recommend reading through the [NSIS reference](https://nsis.sourceforge.io/Docs/Contents.html) before proceeding.

### Libraries
Some dependencies may be installed to the NSIS directory, or to the repository's *Setup\Util* folder. For more information on installing plugins to the NSIS directory, click [here](https://nsis.sourceforge.io/How_can_I_install_a_plugin).
##### NSIS Plugins Directory:
- [LogEx](https://nsis.sourceforge.io/LogEx_plug-in)
- [NScurl](https://github.com/negrutiu/nsis-nscurl)
- [Nsisunz](https://github.com/past-due/nsisunz)
- [NsProcess](https://nsis.sourceforge.io/mediawiki/index.php?title=NsProcess_plugin&oldid=24277)
- [TitlebarProgress](https://nsis.sourceforge.io/TitlebarProgress_plug-in)
- [TaskbarProgress](https://nsis.sourceforge.io/TaskbarProgress_plug-in)
- [nsJSON](https://nsis.sourceforge.io/NsJSON_plug-in)
- [AccessControl](https://nsis.sourceforge.io/AccessControl_plug-in)
##### Setup->Util folder:
- [MoveFileFolder](https://nsis.sourceforge.io/MoveFileFolder)
- [GetSectionNames](https://nsis.sourceforge.io/Get_all_section_names_of_INI_file)
- [Explode](https://nsis.sourceforge.io/Explode)
- [StrContains](https://nsis.sourceforge.io/StrContains)
- [ConfigRead](https://nsis.sourceforge.io/ConfigRead)

### Command Line
You can build using the command line:
```
> makensis Setup.nsi
```
For production, it is recommended to use **lzma compression**, as it offers a higher compression ratio:
```
> makensis /X"SetCompressor /FINAL lzma" Setup.nsi
```
