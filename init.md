
## install chocolatey

https://chocolatey.org/install

```shell
choco install --yes --ignore-checksum googlechrome firefox crystaldiskinfo greenshot crystaldiskmark openoffice win32diskimager.install virtualbox slack autoit screentogif visualstudiocode joytokey charles4 lockhunter pixie obs-studio teamviewer steam jcpicker typora vlc blender postman discord gimp deepl auto-dark-mode folder_size docker-desktop audacity notion figma mattermost-desktop

choco install firefox-nightly --pre --yes --ignore-checksum
```

## download & setup
* svg viewer - https://github.com/tibold/svg-explorer-extension/releases
* https://scoop.sh/
* Windows Terminal - https://www.microsoft.com/ja-jp/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab
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

## Clibor settings

定型文の追加

```
## Before & After

| **Before**             | **After**            |
| ------------------ | ------------------ |
| <テキストや画像など> | <テキストや画像など> |
|                    |                    |

## 対応内容

* 

## 留意事項

```

## troubleshooting
windows 10 で `npm install` 時のビルドエラーが出た場合は、以下を導入

* https://github.com/felixrieseberg/windows-build-tools
* https://github.com/nodejs/node-gyp

Windows 10 で環境変数をリロードせずに反映したい場合

* `$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")` を入力
 * https://github.com/microsoft/vscode/issues/47816#issuecomment-525523816

