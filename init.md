# Windows

## install chocolatey

https://chocolatey.org/install

```shell
choco install --yes --ignore-checksum googlechrome firefox crystaldiskinfo crystaldiskmark openoffice win32diskimager.install virtualbox slack autoit screentogif visualstudiocode joytokey charles4 lockhunter obs-studio teamviewer steam jcpicker typora vlc blender postman discord gimp deepl auto-dark-mode folder_size docker-desktop audacity notion figma mattermost-desktop git kindle microsoft-windows-terminal flameshot files powertoys wechat subtitleedit authy-desktop notepadplusplus

choco install firefox-nightly --pre --yes --ignore-checksum
```

## Windows Package Manager CLI 

```shell
winget install devtoys
```

## Download Ubuntu

* Microsoft Store で ubuntu 最新版ダウンロード
  * このページを確認 - https://winget.run/pkg/Canonical/Ubuntu
* Ubuntu を起動して am user 追加
* ページ下部 #WSL を参照、セットアップ

## download & setup
* svg viewer - https://github.com/tibold/svg-explorer-extension/releases
* https://scoop.sh/
* Windows Terminal - https://www.microsoft.com/ja-jp/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab
* Google Chrome Canary - https://www.google.com/intl/ja/chrome/canary/
* Docker setup - https://docs.docker.com/docker-for-windows/install/
  * 上記ページにて WSL の有効化も合わせて行う
 * Huion Tablet Driver - https://www.huion.com/jp/index.php?m=content&c=index&a=lists&catid=16&myform=1&down_title=kamvas+13

## vscode settings

* Ctrl + Shift + P -> Settings Sync Turn On -> GitHub login (WSL 側で行う必要がある)


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

## Tauri
* Prerequisites | Tauri Apps - https://tauri.app/v1/guides/getting-started/prerequisites

# WSL

## Dotfiles

* Source: https://github.com/ampcpmgp/dotfiles


## apt-get

```shell
sudo apt-get update
sudo apt-get install git clang wget ca-certificates build-essential python3-pip python3-virtualenv peco xclip jq
```

## Git user settings

```shell
git config --global user.name "ampcpmgp"
git config --global user.email "<ACCOUNT_NAME>@gmail.com"

# 必要に応じて変更する
git config --local user.name "<USER_NAME>"
git config --local user.email "<ACCOUNT_NAME>@<DOMAIN>"
```

## Homebrew

* Homebrew - https://docs.brew.sh/Homebrew-on-Linux

手順が長いため、念のため上記 URL を確認する。

```shell
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.bash_profile
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.profile
```

## Brew install

```shell
brew install fnm go
```

## fnm settings

 * fnm - https://github.com/Schniz/fnm

```shell
fnm list-remote
fnm install <LATEST_STABLE_VERSION>
```

## This repository 

```shell
mkdir repos
cd repos
git clone https://github.com/ampcpmgp/dev-memo.git
```

## Deno

```
curl -fsSL https://deno.land/x/install/install.sh | sh
```

https://deno.land/manual@v1.29.1/getting_started/installation

## Rust install

```shell
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

* https://www.rust-lang.org/ja/tools/install

```shell
cargo install cargo-edit --features vendored-openssl
```

* https://github.com/killercup/cargo-edit



# Windows connect to WSL

* Linux 用 Windows サブシステムで Visual Studio Code の使用を開始する - https://docs.microsoft.com/ja-jp/windows/wsl/tutorials/wsl-vscode


# TroubleShooting

## スマフォから WSL で立ち上げたサーバーにアクセスする参考手順

### Android の場合

こちらの手順を参考に

<https://www.suzu6.net/posts/141-android-to-pc-localhost/>

### それ以外の場合

* WSL 2 側で `ip a show dev eth0` を叩き、 inet の次にある IP Address を取得する。
* 管理者権限で Powershell を開き以下を入力する

```
netsh.exe interface portproxy show v4tov4 # ポート状況の確認

netsh.exe interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=3000 connectaddress=<WSL_IP_ADDRESS> connectport=3000

netsh.exe interface portproxy show v4tov4

netsh.exe interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=3000
```


参考URL 
* https://docs.microsoft.com/ja-jp/windows/wsl/networking 
* https://gunmagisgeek.com/blog/other/7171

