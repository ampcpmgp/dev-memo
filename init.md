
# install chocolatey
choco install -yf --allow-empty-checksums --checksum --checksum64 git nodist lhaplus notepadplusplus googlechrome firefox crystaldiskinfo greenshot crystaldiskmark gitkraken libreoffice win32diskimager.install virtualbox slack autoit winmerge screentogif wechat visualstudiocode joytokey charles itunes atom lockhunter pixie obs teamviewer

# download
* color picker - http://www.vector.co.jp/soft/dl/win95/art/se350616.html
* ios webkit debugger ( required itunes ) - https://github.com/google/ios-webkit-debug-proxy
* clibor - https://www.vector.co.jp/soft/winnt/util/se472890.html
* github desktop - https://desktop.github.com/
* clover - http://en.ejie.me/download/
* line - https://www.microsoft.com/ja-jp/store/p/line/9wzdncrfj2g6
* markdown editor - https://github.com/marktext/marktext

# vscode packages
code --install-extension ritwickdey.liveserver --install-extension vstirbu.vscode-mermaid-preview --install-extension chenxsan.vscode-standardjs --install-extension yzhang.markdown-all-in-one --install-extension editorconfig.editorconfig

# windows config environment
https://rustup.rs/

windows 10 でnpm install時のビルドエラーが出た場合は、以下を導入
https://github.com/felixrieseberg/windows-build-tools

# vscode user settings
```
{
    "window.zoomLevel": 0,
    "workbench.startupEditor": "newUntitledFile",
    "liveServer.settings.donotShowInfoMsg": true,
    "git.enableSmartCommit": true,
    "files.trimTrailingWhitespace": true
}
```


# add startup
```
Windows Key + R
shell:startup
add quick start
```
