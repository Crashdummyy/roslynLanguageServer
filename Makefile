version ?= 5.3.0-2.25576.3
rzlsversion ?= 10.0.0-preview.25573.2

# Default platform to empty (will be set based on target)
platform =

all: linux-x64 linux-arm64 win-x64 win-arm64 osx-x64 osx-arm64

linux-x64:
	@echo "Download roslyn for linux-x64 platform :)"
	$(MAKE) target PLATFORM=linux-x64

linux-arm64:
	@echo "Download roslyn for linux-arm64 platform :)"
	$(MAKE) target PLATFORM=linux-arm64

win-x64:
	@echo "Download roslyn for win-x64 platform :)"
	$(MAKE) target PLATFORM=win-x64

win-arm64:
	@echo "Download roslyn for win-arm64 platform :)"
	$(MAKE) target PLATFORM=win-arm64

osx-arm64:
	@echo "Download roslyn for win-arm64 platform :)"
	$(MAKE) target PLATFORM=osx-arm64

osx-x64:
	@echo "Download roslyn for win-arm64 platform :)"
	$(MAKE) target PLATFORM=osx-x64

target:
	git checkout ./Server.csproj
	@echo "Replacing targetVersion in version.json with ${version} :)"
	sed -i 's|#{roslynVersion}|${version}|' ./Server.csproj
	sed -i 's|#{rzlsVersion}|${rzlsversion}|' ./Server.csproj
	sed -i 's|#{rid}|${PLATFORM}|' ./Server.csproj
	git diff ./Server.csproj
	@echo "Ensure vs-impl feed is set"
	dotnet nuget add source -n roslyn "https://pkgs.dev.azure.com/azure-public/vside/_packaging/vs-impl/nuget/v3/index.json" || true
	dotnet nuget add source -n rzls "https://pkgs.dev.azure.com/azure-public/vside/_packaging/msft_consumption/nuget/v3/index.json" || true
	dotnet restore "./Server.csproj"
	cd ./out/microsoft.codeanalysis.languageserver.${PLATFORM}/${version}/content/LanguageServer/${PLATFORM} && zip -r "../../../../../../microsoft.codeanalysis.languageserver.${PLATFORM}.zip" .
	cd ./out/microsoft.visualstudiocode.razorextension/${rzlsversion} && mv "./content" "./RazorExtension" && zip -r "../../../microsoft.codeanalysis.languageserver.${PLATFORM}.zip" RazorExtension
	git checkout ./Server.csproj
	rm -rf obj out
