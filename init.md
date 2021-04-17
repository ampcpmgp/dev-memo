
## install chocolatey

```shell
# open cmd.exe (run by administrator)
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

refreshenv

choco install --yes --ignore-checksum git nvm.portable googlechrome firefox crystaldiskinfo greenshot crystaldiskmark openoffice win32diskimager.install virtualbox slack autoit screentogif visualstudiocode joytokey charles4 itunes lockhunter pixie obs-studio teamviewer steam jcpicker typora vlc blender postman ipfs python discord gimp deepl auto-dark-mode

choco install firefox-nightly --pre --yes --ignore-checksum
```

## download
* svg viewer - https://github.com/tibold/svg-explorer-extension/releases
* clover - http://cn.ejie.me/
* https://scoop.sh/
* ios webkit debugger ( required itunes ) - https://github.com/google/ios-webkit-debug-proxy
  * 上記リンク内にある→を利用し動作確認済み(2020/04/16) https://github.com/RemoteDebug/remotedebug-ios-webkit-adapter
* clibor - https://www.vector.co.jp/soft/winnt/util/se472890.html
* WSL (ubuntu) - from Window Store / ubuntu
  * WSLの有効化 - [参考記事](https://qiita.com/Aruneko/items/c79810b0b015bebf30bb)
* rustup - https://rustup.rs/
* Windows Terminal - https://www.microsoft.com/ja-jp/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab

## vscode packages
```shell
code --install-extension ritwickdey.liveserver --install-extension vstirbu.vscode-mermaid-preview --install-extension yzhang.markdown-all-in-one --install-extension editorconfig.editorconfig --install-extension tomoki1207.vscode-input-sequence --install-extension hookyqr.beautify --install-extension tokoph.ghosttext --install-extension wmaurer.change-case --install-extension damien.autoit --install-extension ryu1kn.partial-diff --install-extension eamodio.gitlens --install-extension grapecity.gc-excelviewer --install-extension goessner.mdmath --install-extension bierner.emojisense --install-extension rust-lang.rust --install-extension ecmel.vscode-html-css --install-extension humao.rest-client --install-extension be5invis.toml --install-extension visualstudioexptteam.vscodeintellicode --install-extension a5huynh.vscode-ron --install-extension ms-vscode-remote.vscode-remote-extensionpack --install-extension kelvin.vscode-sshfs --install-extension csholmq.excel-to-markdown-table --install-extension yzane.markdown-pdf --install-extension vadimcn.vscode-lldb --install-extension dbaeumer.vscode-eslint --install-extension fivethree.vscode-svelte-snippets --install-extension esbenp.prettier-vscode --install-extension cssho.vscode-svgviewer --install-extension mikeburgh.xml-format --install-extension oderwat.indent-rainbow --install-extension davidanson.vscode-markdownlint --install-extension svelte.svelte-vscode --install-extension ms-vsliveshare.vsliveshare --install-extension donjayamanne.githistory --install-extension mhutchie.git-graph --install-extension wix.vscode-import-cost --install-extension naumovs.color-highlight --install-extension bierner.markdown-mermaid --install-extension usernamehw.errorlens --install-extension funkyremi.vscode-google-translate
```

## vscode user settings

`Ctrl + , -> config json`
```json
{
    "editor.tabSize": 2,
    "explorer.confirmDelete": false,
    "window.zoomLevel": 0,
    "liveServer.settings.donotShowInfoMsg": true,
    "eslint.validate": [
        "javascript",
        "svelte"
    ],
    "explorer.confirmDragAndDrop": false,
    "javascript.updateImportsOnFileMove.enabled": "always",
    "[rust]": {
        "editor.formatOnSave": true,
    },
    "[javascript]": {
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[svelte]": {
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "svelte.svelte-vscode"
    },
    "[html]": {
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "rust.build_on_save": true,
    "terminal.integrated.shell.windows": "C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
    "remote.SSH.showLoginTerminal": true,
    "svelte.plugin.html.tagComplete.enable": false,
    "editor.wordWrap": "on"
}
```


## nvm settings

```shell
nvm list available # use LTS version
nvm install __VERSION__
nvm use __VERSION__
```

## Git user settings

```shell
git config --global user.name "ampcpmgp"
git config --global user.email "email@example.com"
```

## rust settings

```shell
# nightly & target wasm
rustup install nightly
rustup update
rustup target add wasm32-unknown-unknown --toolchain nightly

# components
rustup component add rls rust-analysis rust-src rustfmt

# binary packages
cargo +nightly install racer
cargo install cargo-tree cargo-edit
```


## add startup
```
Windows Key + R
shell:startup
add quick start
```

## windows setting
WinKey -> マルチタスクの設定 -> 「横に配置できるものを表示」を無効


## wsl setting
[init-wsl.md](init-wsl.md) を参照

## troubleshooting
windows 10 でnpm install時のビルドエラーが出た場合は、以下を導入
* https://github.com/felixrieseberg/windows-build-tools
* https://github.com/nodejs/node-gyp

vscode-rls で `--features` を渡す必要がある場合、Workspace setting より以下を参考に設定する
```json
{
  "rust.unstable_features": true,
  "rust.features": ["vulkan"]
}
```
