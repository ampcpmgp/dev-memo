
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

# vscode packages
```shell
code --install-extension ritwickdey.liveserver --install-extension vstirbu.vscode-mermaid-preview --install-extension chenxsan.vscode-standardjs --install-extension yzhang.markdown-all-in-one --install-extension editorconfig.editorconfig --install-extension tomoki1207.vscode-input-sequence --install-extension hookyqr.beautify --install-extension tokoph.ghosttext --install-extension wmaurer.change-case --install-extension damien.autoit --install-extension ms-python.python --install-extension ryu1kn.partial-diff --install-extension eamodio.gitlens --install-extension grapecity.gc-excelviewer
```

# windows config environment
https://rustup.rs/

windows 10 でnpm install時のビルドエラーが出た場合は、以下を導入
* https://github.com/felixrieseberg/windows-build-tools
* https://github.com/nodejs/node-gyp

# firefox config

`abount:config` を開いて `browser.urlbar.autoFill` を入力し、falseに変更する


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
    "terminal.integrated.shell.windows": "C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
    "standard.autoFixOnSave": true
}
```


```shell
nodist add v10 # or later
nodist global v10
npm i yarn -g
npm i npx -g
```


# add startup
```
Windows Key + R
shell:startup
add quick start
```
