# Windows

## Windows 11 設定

- マルクタスクの設定 -> ウインドウのスナップ -> 開いて内側をすべて解除
- エクスプローラーのオプション -> 拡張子は表示しない OFF -> 隠しファイルの表示する ON
- システム -> ディスプレイ -> 夜間モード -> スケジュールON
- WinKey -> マルチタスクの設定 -> 「横に配置できるものを表示」を無効
- WinKey -> エクスプローラーのオプション -> 表示 ->
  - 「ログオン時に以前のフォルダーウィンドウを表示する」のチェックを入れる
  - 「登録されている拡張子は表示しない」のチェックを外す
- パフォーマンスのオプションの設定 - [参考](https://zenn.dev/takashiaihara/articles/a1dfc9899a5fe7)
- ターミナル -> Ctrl + , -> コンピューターのスタートアップ時に起動ON -> ターミナルの起動時 前のセッションからウインドウを開く 

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
winget install -e --id Microsoft.PowerToys --source winget --accept-package-agreements
winget install Warp.Warp

# Canonical.Ubuntu もできるか次に試す、うまくいけば Store から除去
```

## darkモードの設定

- PowerToys -> Light Switch -> 夜間モードをフォローする

## Install directly
- Kamvas 13 Driver - https://www.huion.com/jp/download/kamvas-13
- NVIDIA App
  - https://www.nvidia.com/ja-jp/software/nvidia-app/
- NVIDIA Driver
  - NVIDIA App からダウンロード可能、もしできなければ以下
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

## apt

```shell
sudo apt update
sudo apt install git clang wget ca-certificates build-essential python3-pip python3-virtualenv peco xclip jq unzip ffmpeg libportaudio2 portaudio19-dev 
```

## Install others

```shell
# https://bun.sh/docs/installation#installing
curl -fsSL https://bun.sh/install | bash
bun -v

# https://docs.astral.sh/uv/getting-started/installation/
curl -LsSf https://astral.sh/uv/install.sh | sh
uv --version

# https://nodejs.org/ja/download
curl -o- https://fnm.vercel.app/install | bash
fnm install 24 # 適切なバージョンを入れる
node -v

# https://opencode.ai/
# https://code.claude.com/docs/ja/quickstart
bun add -g opencode-ai @anthropic-ai/claude-code
opencode -v
claude -v

# https://hermes-agent.nousresearch.com/docs/getting-started/quickstart#1-install-hermes-agent
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
source ~/.bashrc
hermes -v

# https://www.kimi.com/code/docs/en/kimi-code-cli/getting-started.html
curl -LsSf https://code.kimi.com/install.sh | bash
kimi --version

# https://pnpm.io/ja/installation
curl -fsSL https://get.pnpm.io/install.sh | sh -
pnpm -v

# https://docs.deno.com/runtime/getting_started/installation/
curl -fsSL https://deno.land/x/install/install.sh | sh
deno -v

# https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
gh --version
```

## Git user settings

```shell
git config --global user.name "ampcpmgp"
git config --global user.email "<ACCOUNT_NAME>@gmail.com"

# 必要に応じて変更する
git config --local user.name "<USER_NAME>"
git config --local user.email "<ACCOUNT_NAME>@<DOMAIN>"
```

# TroubleShooting

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
