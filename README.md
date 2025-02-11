# RoslynCrawler

This repository will crawl the Roslyn Feeds <https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.{rid}> for new releases and upload the as artifacts

## AutoUpdate for nvim

Theres an attempt to get integrated into the [mason-registry](https://github.com/mason-org/mason-registry/pull/6330).
Until this is done you can use one of these approaaches to automatically update to the latest version:

### custom-mason-registry

In case you're already using [mason](https://github.com/williamboman/mason.nvim) you can add a custom registry.  

```lua
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
    },
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:crashdummyy/mason-registry"
      }
    }
  },

```

This registry currently serves at least the languageServer for [roslyn.nvim](https://github.com/seblj/roslyn.nvim) and [rzls.nvim](https://github.com/tris203/rzls.nvim)

### Linux

The variable `rid` might need to be altered

```bash
#!/bin/bash

if ! command -v unzip &> /dev/null
then
    echo "unzip is required. Please install it"
    exit 1
fi

rid="linux-x64"
targetDir="$HOME/.local/share/nvim/roslyn"
latestVersion=$(curl -s https://api.github.com/repos/Crashdummyy/roslynLanguageServer/releases | grep tag_name | head -1 | cut -d '"' -f4)

[[ -z "$latestVersion" ]] && echo "Failed to fetch the latest package information." && exit 1

echo "Latest version: $latestVersion"

asset=$(curl -s https://api.github.com/repos/Crashdummyy/roslynLanguageServer/releases | grep "releases/download/$latestVersion" | grep "$rid"| cut -d '"' -f 4)

echo "Downloading: $asset"

curl -Lo "./roslyn.zip" "$asset"

echo "Remove old installation"
rm -rf $targetDir/*

unzip "./roslyn.zip" -d "$targetDir/"
rm "./roslyn.zip"
```

### Macos

TBD

### Windows

#### x64

```powershell
$file = New-Guid
Invoke-WebRequest https://github.com/Crashdummyy/roslynLanguageServer/releases/latest/download/microsoft.codeanalysis.languageserver.win-x64.zip -OutFile ~/Downloads/$file.zip
Expand-Archive ~/Downloads/$file.zip -DestinationPath ~/AppData/Local/nvim-data/roslyn/ -Force
rm ~/Downloads/$file.zip
```

#### arm64

```powershell
$file = New-Guid
Invoke-WebRequest https://github.com/Crashdummyy/roslynLanguageServer/releases/latest/download/microsoft.codeanalysis.languageserver.win-arm64.zip -OutFile ~/Downloads/$file.zip
Expand-Archive ~/Downloads/$file.zip -DestinationPath ~/AppData/Local/nvim-data/roslyn/ -Force
rm ~/Downloads/$file.zip
```
