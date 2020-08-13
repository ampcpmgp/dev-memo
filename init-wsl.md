## 必須ツールのダウンロード＆設定

* nvm - https://github.com/creationix/nvm

```shell
nvm ls-remote
nvm install v14.8.0 # or later
```

* rustup - https://rustup.rs/
* rust (rls) - https://github.com/rust-lang/rls

```shell
# rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.bash_profile

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

# トラブルシューティング

* rustup component add rls の時のエラーの場合

https://github.com/rust-lang/rls#error-component-rls-is-unavailable-for-download-nightly を参照


* cargo install cargo-tree

下記エラー時
> error: failed to run custom build command for `openssl-sys v0.9.43`

```shell
sudo apt-get install libssl-dev
```
