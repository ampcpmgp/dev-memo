# Windows

## Windows 11 設定

- マルクタスクの設定 -> ウインドウのスナップ -> 開いて内側をすべて解除
- コントロールパネル -> コンピューターの簡単操作 -> マウスを使いやすくします -> ウインドウが画面の端に移動されたとき自動的に整列されないようにします にチェック
- エクスプローラーのオプション -> 拡張子は表示しない OFF -> 隠しファイルの表示する ON
- システム -> ディスプレイ -> 夜間モード -> スケジュールON

## windows setting
- WinKey -> マルチタスクの設定 -> 「横に配置できるものを表示」を無効
- WinKey -> エクスプローラーのオプション -> 表示 ->
  - 「ログオン時に以前のフォルダーウィンドウを表示する」のチェックを入れる
  - 「登録されている拡張子は表示しない」のチェックを外す
- パフォーマンスのオプションの設定 - [参考](https://zenn.dev/takashiaihara/articles/a1dfc9899a5fe7)

## Install chocolatey

以下より CLI インストール
https://chocolatey.org/install

```shell
choco install --yes --ignore-checksum googlechrome firefox crystaldiskinfo crystaldiskmark autoit screentogif visualstudiocode lockhunter obs-studio teamviewer steam jcpicker typora vlc folder_size docker-desktop audacity figma mattermost-desktop git flameshot line chromium logitech-options-plus
```

インストールしたものを一通り確認する

## Install this repository 

```powershell
cd C:\
mkdir repos
cd repos
git clone https://github.com/ampcpmgp/dev-memo.git
```

## install by winget

```powershell
winget install -e --id ZedIndustries.Zed --accept-package-agreements
winget install -e --id Tencent.WeChat --accept-package-agreements
winget install -e --id Canonical.Ubuntu --accept-package-agreements
winget install --id Microsoft.PowerToys --source winget --accept-package-agreements

# Canonical.Ubuntu もできるか次に試す、うまくいけば Store から除去
```

## darkモードの設定

- PowerToys -> Light Switch -> 夜間モードをフォローする

## Install directly
- Kamvas 13 Driver - https://www.huion.com/jp/download/kamvas-13
- NVIDIA Driver
  - `nvidia-smi` で CUDA バージョン確認、最新化出来てなければ以下対応
  - `dxdiag` で GPU 確認後、最新ドライバダウンロード - https://www.nvidia.com/en-us/drivers/
- 水匠 & ShogiGUI - search by google
- 音楽ツール
  - Melissa - https://github.com/mosynthkey/Melissa
  - NeuralNote - https://github.com/DamRsn/NeuralNote/releases
- Canva - https://www.canva.com/ja_jp/download/windows/
- Owl3d - https://www.owl3d.com/purchase/downloadstart

## Setup

- memory-windows
  - build 横縦横.exe, then locate desktop, and execute from logi+ tool
- Ubuntu"C:\repos\dev-memo\memory-windows\横縦横.exe"
  - Ubuntu を起動して am user 追加
  - ページ下部 #WSL を参照、セットアップ
  - DドライブなどのSSDに引っ越しする場合（しなくても適宜圧縮できればOK）
    - https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands?source=recommendations#export-a-distribution
    - https://zenn.dev/shittoku_xxx/articles/066cfd072d87a1
- Docker Desktop
  - Settings -> Resources -> WSL integration -> Ubuntu -> Apply & Restart
  - DドライブなどのSSDに引っ越しする場合（特に推奨）
    - Settings -> Resources -> Advanced -> Browse 変更

## vscode settings

- Ctrl + Shift + P -> Settings Sync Turn On -> GitHub login (WSL 側で行う必要がある)

## add startup
```
Windows Key + R
shell:startup
add quick start
```

# WSL

## WSL Configuration (/etc/wsl.conf)

Windowsコマンドとの連携（Interop）を有効化し、WindowsのPATHを引き継ぐための設定を行います。

```shell
sed '/^$/d' << 'EOF' | sudo tee -a /etc/wsl.conf
[interop]
enabled = true
appendWindowsPath = true
EOF
```

## Dotfiles

`vi ~/.profile` で差分が無ければ更新の必要無し

- Source: https://github.com/ampcpmgp/dotfiles


## apt-get

※ 全て apt に移行できるか確認。

```shell
sudo apt-get update
sudo apt-get install git clang wget ca-certificates build-essential python3-pip python3-virtualenv peco xclip jq unzip tmux
```

## apt

```shell
sudo apt install ffmpeg

# Ubuntu 25.10 or later, see https://github.com/jesseduffield/lazygit?tab=readme-ov-file#debian-and-ubuntu
sudo apt install lazygit
```

## Git user settings

```shell
git config --global user.name "ampcpmgp"
git config --global user.email "<ACCOUNT_NAME>@gmail.com"

# 必要に応じて変更する
git config --local user.name "<USER_NAME>"
git config --local user.email "<ACCOUNT_NAME>@<DOMAIN>"

# git 操作が遅い場合に設定する
git config --global checkout.workers $(nproc)
git config core.fsmonitor true
git config core.untrackedCache true
```

## tmux settings

```shell
sed '/^$/d' << 'EOT' > ~/.tmux.conf
# --- 基本設定 ---
set -g default-terminal "screen-256color"
set-option -ga terminal-overrides ",xterm-256color:Tc"
set -g mouse on
set -g prefix C-a
unbind C-b
set -g base-index 1
setw -g pane-base-index 1
# --- 分割操作 (パス維持) ---
bind - split-window -v -c "#{pane_current_path}"
bind | split-window -h -c "#{pane_current_path}"
# --- 日本語ヘルプ ---
bind h display-popup -E "bash -c 'echo \"Prefix(C-a) + | : 画面を縦に分割
Prefix(C-a) + - : 画面を横に分割
Prefix(C-a) + s : プロジェクト(セッション)切替
Prefix(C-a) + $ : プロジェクト名の変更
Prefix(C-a) + d : そのまま中断 (次回復元)
---
何かキーを押すと閉じます...\" && read -n 1'"
EOT

tmux source-file ~/.tmux.conf
```

## Bun

```shell
curl -fsSL https://bun.sh/install | bash
```

https://bun.sh/docs/installation#installing

### Bun module

```shell
bun add -g opencode-ai @anthropic-ai/claude-code
```

## fnm install

```shell
curl -fsSL https://fnm.vercel.app/install | bash

# then restart and read ~/.bashrc
fnm --version
```

https://github.com/Schniz/fnm

## fnm settings

 - fnm - https://github.com/Schniz/fnm

```shell
fnm list-remote
fnm install <LATEST_STABLE_VERSION>
fnm default <LATEST_STABLE_VERSION>
```

If you want to fix the version in the repository, enter the following.

```shell
node -v > .node-version
```

## pnpm

```bash
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

## This repository 

```shell
mkdir repos
cd repos
git clone https://github.com/ampcpmgp/dev-memo.git
```

## Deno

```shell
curl -fsSL https://deno.land/x/install/install.sh | sh
```

https://deno.land/manual@v1.29.1/getting_started/installation

## Rust install

```shell
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 1) Proceed with standard installation (default - just press enter)
# 2) Customize installation
# 3) Cancel installation
>1

# then restart
```

- https://www.rust-lang.org/ja/tools/install

```shell
cargo install cargo-edit --features vendored-openssl
```

- https://github.com/killercup/cargo-edit


## Brew install

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# after RETURN/ENTER

test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "" >> ~/.bashrc
echo "# brew" >> ~/.bashrc
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
```

- https://brew.sh/
- https://docs.brew.sh/Homebrew-on-Linux

# Windows connect to WSL

- Linux 用 Windows サブシステムで Visual Studio Code の使用を開始する - https://docs.microsoft.com/ja-jp/windows/wsl/tutorials/wsl-vscode


# TroubleShooting

## Vmmem の CPU 使用率が高い場合

以下を参考に、 .wslconfig を作成し、設定を行う

https://jp.minitool.com/news/vmmem-high-memory.html

## スマフォから WSL で立ち上げたサーバーにアクセスする参考手順

### 共通

- Powershell で `ipconfig` を叩き、 IPv4 アドレスの次にある IP Address を取得する。
- WSL 2 側で `ip a show dev eth0` を叩き、 inet の次にある IP Address を取得する。
- 管理者権限で Powershell を開き以下を入力する

```
netsh.exe interface portproxy show v4tov4 # ポート状況の確認

netsh.exe interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=3000 connectaddress=<WSL_IP_ADDRESS> connectport=3000

netsh.exe interface portproxy show v4tov4

netsh.exe interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=3000
```

- 「セキュリティが強化された Windows Defender ファイアウォール」より、指定のポートを外す

参考URL 
- https://docs.microsoft.com/ja-jp/windows/wsl/networking 
- https://gunmagisgeek.com/blog/other/7171
- https://learn.microsoft.com/ja-jp/windows/security/threat-protection/windows-firewall/open-windows-firewall-with-advanced-security

### Android の場合

Wifi debug を有効にする

<https://dev.classmethod.jp/articles/android-chrome-debug/>
