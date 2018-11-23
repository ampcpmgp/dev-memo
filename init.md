
# install chocolatey
choco install --yes --ignore-checksum git nodist notepadplusplus googlechrome firefox crystaldiskinfo greenshot crystaldiskmark gitkraken libreoffice win32diskimager.install virtualbox slack autoit.commandline winmerge screentogif visualstudiocode joytokey charles4 itunes lockhunter pixie obs teamviewer

# download
* ios webkit debugger ( required itunes ) - https://github.com/google/ios-webkit-debug-proxy
* clibor - https://www.vector.co.jp/soft/winnt/util/se472890.html
* github desktop - https://desktop.github.com/
* clover - http://cn.ejie.me/
* markdown editor - https://github.com/marktext/marktext/releases
* WSL (ubuntu) - from Window Store / ubuntu
  * WSLの有効化 - [参考記事](https://qiita.com/Aruneko/items/c79810b0b015bebf30bb)
* Firefox Quantom Developer Edition - https://www.mozilla.org/ja/firefox/developer/

# vscode packages
code --install-extension ritwickdey.liveserver --install-extension vstirbu.vscode-mermaid-preview --install-extension chenxsan.vscode-standardjs --install-extension yzhang.markdown-all-in-one --install-extension editorconfig.editorconfig --install-extension tomoki1207.vscode-input-sequence --install-extension hookyqr.beautify --install-extension tokoph.ghosttext

# windows config environment
https://rustup.rs/

windows 10 でnpm install時のビルドエラーが出た場合は、以下を導入  
https://github.com/felixrieseberg/windows-build-tools

# vscode user settings

`Ctrl + , -> config json`
```
{
    "editor.tabSize": 2,
    "explorer.confirmDelete": false,
    "window.zoomLevel": 0,
    "liveServer.settings.donotShowInfoMsg": true,
    "files.associations": {
        "*.tag": "html"
    },
    "explorer.confirmDragAndDrop": false,
    "terminal.integrated.shell.windows": "C:\\WINDOWS\\System32\\wsl.exe"
}
```

`Ctrl + p -> snippets -> html`
html.json
```json
{
	"less scope": {
		"prefix": "lesss",
		"body": [
			"<style type=\"less\">",
			"  :scope {",
			"    $2",
			"  }",
			"</style>"
		],
		"description": "style tag for less"
	},

	"less style": {
		"prefix": "less",
		"body": [
			"<style type=\"less\">",
			"  > $1 {",
			"    $2",
			"  }",
			"</style>"
		],
		"description": "style tag for less"
	}
}
```


# add startup
```
Windows Key + R
shell:startup
add quick start
```
