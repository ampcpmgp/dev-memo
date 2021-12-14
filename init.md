
## install chocolatey

https://chocolatey.org/install

```shell
choco install --yes --ignore-checksum googlechrome firefox crystaldiskinfo greenshot crystaldiskmark openoffice win32diskimager.install virtualbox slack autoit screentogif visualstudiocode joytokey charles4 lockhunter pixie obs-studio teamviewer steam jcpicker typora vlc blender postman discord gimp deepl auto-dark-mode folder_size docker-desktop audacity notion figma mattermost-desktop git

choco install firefox-nightly --pre --yes --ignore-checksum
```

## download & setup
* svg viewer - https://github.com/tibold/svg-explorer-extension/releases
* https://scoop.sh/
* Windows Terminal - https://www.microsoft.com/ja-jp/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab
* Google Chrome Canary - https://www.google.com/intl/ja/chrome/canary/
* Docker setup - https://docs.docker.com/docker-for-windows/install/
  * 上記ページにて WSL の有効化も合わせて行う


## vscode settings

Ctrl + Shift + P -> Settings Sync Turn On -> GitHub login


## add startup
```
Windows Key + R
shell:startup
add quick start
```

## windows setting
* WinKey -> マルチタスクの設定 -> 「横に配置できるものを表示」を無効
* WinKey -> エクスプローラーのオプション -> 表示 ->
  * 「ログオン時に以前のフォルダーウィンドウを表示する」のチェックを入れる
  * 「登録されている拡張子は表示しない」のチェックを外す


# WSL

 * Volta - https://docs.volta.sh/guide/getting-started

## volta settings

```shell
volta install node@latest
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


## Git user settings

```shell
git config --global user.name "ampcpmgp"
git config --global user.email "email@example.com"
git config --global core.autocrlf input

# 必要に応じて変更する
git config --local user.name "ampcpmgp"
git config --local user.email "email@example.com"
```

