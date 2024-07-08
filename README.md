# RoslynCrawler

This repository will crawl the Roslyn Feeds https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.{rid} for new releases and upload the as artifacts

## AutoUpdate for nvim

Theres an attempt to get integrated into the [mason-registry](https://github.com/mason-org/mason-registry/pull/6330).
Until this is done you can use this script to automatically update to the latest version:

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

unzip "./roslyn.zip" -d "$targetDir/
rm "./roslyn.zip"
```

### Macos
TBD

### Windows
TBD
