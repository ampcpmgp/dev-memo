## 必須ツールのダウンロード＆設定

* nvm - https://github.com/creationix/nvm

```shell
nvm install 10 # or later
npm i yarn -g
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
rustup target add wasm32-unknown-unknown --toolchain nightly # 必要に応じてnightlyを利用する。可能な限りstableを利用。

# components
rustup component add rls rust-analysis rust-src rustfmt

# racer
cargo +nightly install racer
```

# トラブルシューティング

* rustup component add rls の時のエラーの場合

https://github.com/rust-lang/rls#error-component-rls-is-unavailable-for-download-nightly を参照
