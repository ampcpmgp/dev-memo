
## install chocolatey

```shell
# open cmd.exe (run by administrator)
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

refreshenv

choco install --yes --ignore-checksum git googlechrome firefox crystaldiskinfo greenshot crystaldiskmark openoffice win32diskimager.install virtualbox slack autoit screentogif visualstudiocode joytokey charles4 itunes lockhunter pixie obs-studio teamviewer steam jcpicker typora vlc blender postman ipfs python discord gimp deepl auto-dark-mode folder_size docker-desktop

choco install firefox-nightly --pre --yes --ignore-checksum
```

## download & setup
* svg viewer - https://github.com/tibold/svg-explorer-extension/releases
* clover - http://cn.ejie.me/
* https://scoop.sh/
* ios webkit debugger ( required itunes ) - https://github.com/google/ios-webkit-debug-proxy
  * 上記リンク内にある→を利用し動作確認済み(2020/04/16) https://github.com/RemoteDebug/remotedebug-ios-webkit-adapter
  * 有料版に変更されている(2021/07/25) https://inspect.dev/
* Clibor - https://www.vector.co.jp/soft/winnt/util/se472890.html?ref=top
* rustup - https://rustup.rs/
* Windows Terminal - https://www.microsoft.com/ja-jp/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab
* FocalBoard - https://www.microsoft.com/ja-jp/p/focalboard-insiders-edition/9nln2t0sx9vf?cid=website&rtc=1&activetab=pivot:overviewtab
* Google Chrome Canary - https://www.google.com/intl/ja/chrome/canary/
* Docker setup - https://docs.docker.com/docker-for-windows/install/
  * 上記ページにて WSL の有効化も合わせて行う
 * Volta - https://docs.volta.sh/guide/getting-started


## vscode settings

Ctrl + Shift + P -> Settings Sync Turn On -> GitHub login

## volta settings

```shell
volta install node@latest
```

## Git user settings

```shell
git config --global user.name "ampcpmgp"
git config --global user.email "email@example.com"
git config --global core.autocrlf input

# 必要に応じて変更する
git config --local user.name "ampcpmgp"
git config --local user.email "email@example.com"
```

## rust settings

```shell
rustup update

# components
# 必要に応じて変更、2021/05/30時点では不要そう。
# rustup component add rls rust-analysis rust-src

# binary packages
cargo install cargo-tree cargo-edit
```


## add startup
```
Windows Key + R
shell:startup
add quick start
```

## windows setting
* WinKey -> マルチタスクの設定 -> 「横に配置できるものを表示」を無効
* WinKey -> エクスプローラーのオプション -> 表示 -> 「登録されている拡張子は表示しない」のチェックを外す


## wsl setting
[init-wsl.md](init-wsl.md) を参照

## troubleshooting
windows 10 で `npm install` 時のビルドエラーが出た場合は、以下を導入
* https://github.com/felixrieseberg/windows-build-tools
* https://github.com/nodejs/node-gyp
