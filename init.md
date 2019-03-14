
# install chocolatey

```shell
# open cmd.exe (run by administrator)
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

refreshenv

choco install --yes --ignore-checksum git nodist notepadplusplus googlechrome firefox crystaldiskinfo greenshot crystaldiskmark gitkraken libreoffice win32diskimager.install virtualbox slack autoit.commandline winmerge screentogif visualstudiocode joytokey charles4 itunes lockhunter pixie obs teamviewer steam github-desktop

choco install firefox-dev --pre --yes --ignore-checksum
```

# download
* ios webkit debugger ( required itunes ) - https://github.com/google/ios-webkit-debug-proxy
* clibor - https://www.vector.co.jp/soft/winnt/util/se472890.html
* clover - http://cn.ejie.me/
* WSL (ubuntu) - from Window Store / ubuntu
  * WSLの有効化 - [参考記事](https://qiita.com/Aruneko/items/c79810b0b015bebf30bb)
* Firefox Quantom Developer Edition - https://www.mozilla.org/ja/firefox/developer/

# vscode packages
```shell
code --install-extension ritwickdey.liveserver --install-extension vstirbu.vscode-mermaid-preview --install-extension chenxsan.vscode-standardjs --install-extension yzhang.markdown-all-in-one --install-extension editorconfig.editorconfig --install-extension tomoki1207.vscode-input-sequence --install-extension hookyqr.beautify --install-extension tokoph.ghosttext --install-extension wmaurer.change-case damien.autoit ms-python.python ryu1kn.partial-diff eamodio.gitlens grapecity.gc-excelviewer
```

# windows config environment
https://rustup.rs/

windows 10 でnpm install時のビルドエラーが出た場合は、以下を導入
* https://github.com/felixrieseberg/windows-build-tools
* https://github.com/nodejs/node-gyp

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
    "terminal.integrated.shell.windows": "C:\\Program Files\\Git\\bin\\bash.exe",
    "standard.autoFixOnSave": true
}
```

`Ctrl + p -> snippets -> html`
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

```shell
nodist add v10 # or later
npm i yarn -g
npm i npx -g
```


# add startup
```
Windows Key + R
shell:startup
add quick start
```
