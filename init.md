# Windows

## install chocolatey

https://chocolatey.org/install

```shell
choco install --yes --ignore-checksum googlechrome firefox crystaldiskinfo crystaldiskmark openoffice win32diskimager.install virtualbox slack autoit screentogif visualstudiocode joytokey lockhunter obs-studio teamviewer steam jcpicker typora vlc blender postman discord gimp deepl auto-dark-mode folder_size docker-desktop audacity notion figma mattermost-desktop git kindle microsoft-windows-terminal flameshot files powertoys wechat subtitleedit authy-desktop notepadplusplus line coretemp chromium opera vcam.ai unity-hub androidstudio logitech-options-plus anyvideoconverter ffmpeg cuda bun node uv cyberduck

choco install firefox-nightly --pre --yes --ignore-checksum
```

## Install this repository 

```powershell
cd C:\
mkdir repos
cd repos
git clone https://github.com/ampcpmgp/dev-memo.git
```

## Microsoft Store

currently nothing

- xxx

## install by winget

```shell
winget install httptoolkit
winget install devtoys
```

## Setup Windows reorder tool

- build 2-1920x1080.exe, then locate desktop, and execute from logi+ tool

## Download Ubuntu

* Microsoft Store で ubuntu 最新版ダウンロード
  * このページを確認 - https://winget.run/pkg/Canonical/Ubuntu
  * Ubuntu を起動して am user 追加
  * ページ下部 #WSL を参照、セットアップ
  * Dドライブ引越
    * https://learn.microsoft.com/ja-jp/windows/wsl/basic-commands?source=recommendations#export-a-distribution
    * https://zenn.dev/shittoku_xxx/articles/066cfd072d87a1

## download & setup
* svg viewer - https://github.com/tibold/svg-explorer-extension/releases
* https://scoop.sh/
* Windows Terminal - https://www.microsoft.com/ja-jp/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab
* Google Chrome Canary - https://www.google.com/intl/ja/chrome/canary/
* Docker setup - https://docs.docker.com/docker-for-windows/install/
  * 上記ページにて WSL の有効化も合わせて行う
  * Dドライブに移行する
* Huion Tablet Driver - https://www.huion.com/jp/index.php?m=content&c=index&a=lists&catid=16&myform=1&down_title=kamvas+13
* VB-CABLE - https://vb-audio.com/Cable/
* 水匠 & ShogiGUI - search by google
* 音楽ツール
  * Melissa - https://github.com/mosynthkey/Melissa
  * NeuralNote - https://github.com/DamRsn/NeuralNote/releases
* Xreal NRSDK - https://docs.xreal.com/Getting%20Started%20with%20NRSDK
* TopClipper - https://jp.imyfone.com/crop-video/
* API Dog - https://apidog.com/jp/download/
* Ollama - https://github.com/ollama/ollama
  * Install Ollama and models
  * Install embedding model - https://ollama.com/library/nomic-embed-text
* ComfyUI
  * Install ComfyUI - https://www.comfy.org/download
  * ComfyUI Manager - https://github.com/ltdrdata/ComfyUI-Manager?tab=readme-ov-file#installation
    * ComfyUI Ollama - https://github.com/stavsap/comfyui-ollama
    * ComfyUI Custom Scripts - https://github.com/pythongosssss/ComfyUI-Custom-Scripts
  * Stable Diffusion 3.5 or later - https://comfyui-wiki.com/ja/tutorial/advanced/stable-diffusion-3-5-comfyui-workflow
* Canva - https://www.canva.com/ja_jp/download/windows/
* あずきフォント - http://azukifont.com/font/azuki.html
* ケイ字 - https://k-gothic-font.hatenablog.com/
* AI Chat Communication Tool
  * Cherry Studio - https://cherry-ai.com/download
  * Jan (2025/07時点で未使用, 試してみる価値ありそう) - https://jan.ai/docs
* Pinokio - https://program.pinokio.computer/#/?id=install
  * Install FramePack
* Other FramePack
  * Install https://github.com/colinurbs/FramePack-Studio
    * If error, see https://aistudio.google.com/app/prompts?state=%7B%22ids%22:%5B%221p9we6tYvM-ZLVZdBYFpdDZHCuZNyPhjs%22%5D,%22action%22:%22open%22,%22userId%22:%22101802373527511565880%22,%22resourceKeys%22:%7B%7D%7D&usp=sharing
  * Install FramePack-eichi
    * Reference - https://github.com/git-ai-code/FramePack-eichi (currently not working in Pinokio, 2025/04/29)
    * choco install cuda
  * Install xformers, flash-attn, sage-attention - https://github.com/lllyasviel/FramePack/issues/138
  * 上記で動かない場合、依存関係のエラーを戻す
    *  `pip freeze > piplist.txt`
    *  `pip uninstall -r piplist.txt -y`
    *  `pip install -r requiments.txt`
* ACE-Step - https://github.com/ace-step/ACE-Step
* NVIDIA Driver
  * `nvidia-smi` で CUDA バージョン確認、最新化出来てなければ以下対応
  * `dxdiag` で GPU 確認後、最新ドライバダウンロード - https://www.nvidia.com/en-us/drivers/


## vscode settings

* Ctrl + Shift + P -> Settings Sync Turn On -> GitHub login (WSL 側で行う必要がある)

## Ollama

```shell
ollama serve
```

other settings

- https://ollama.com/blog/embedding-models
- 

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
* パフォーマンスのオプションの設定 - [参考](https://zenn.dev/takashiaihara/articles/a1dfc9899a5fe7)
* Locatorjs の設定 - https://github.com/infi-pc/locatorjs/issues/77#issuecomment-1331894792

## Tauri
* Prerequisites | Tauri Apps - https://tauri.app/v1/guides/getting-started/prerequisites

# WSL

## Dotfiles

`vi ~/.profile` で差分が無ければ更新の必要無し

* Source: https://github.com/ampcpmgp/dotfiles


## apt-get

※ 全て apt に移行できるか確認。

```shell
sudo apt-get update
sudo apt-get install git clang wget ca-certificates build-essential python3-pip python3-virtualenv peco xclip jq unzip
```

## apt

```shell
sudo apt install ffmpeg
```

## Git user settings

```shell
git config --global user.name "ampcpmgp"
git config --global user.email "<ACCOUNT_NAME>@gmail.com"

# 必要に応じて変更する
git config --local user.name "<USER_NAME>"
git config --local user.email "<ACCOUNT_NAME>@<DOMAIN>"
```

## fnm install

```shell
curl -fsSL https://fnm.vercel.app/install | bash

# then restart and read ~/.bashrc
fnm --version
```

https://github.com/Schniz/fnm

## fnm settings

 * fnm - https://github.com/Schniz/fnm

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

## Bun

```shell
curl -fsSL https://bun.sh/install | bash
```

https://bun.sh/docs/installation#installing

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

* https://www.rust-lang.org/ja/tools/install

```shell
cargo install cargo-edit --features vendored-openssl
```

* https://github.com/killercup/cargo-edit


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

## Other CLI Tool

- LLM Coding Tool
  - `curl -fsSL https://opencode.ai/install | bash` - https://opencode.ai/docs/
  - `npm install -g @charmland/crush` - https://github.com/charmbracelet/crush
  - `npm install -g @anthropic-ai/claude-code` - https://docs.anthropic.com/en/docs/claude-code/overview


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


