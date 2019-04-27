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
rustup default nightly
rustup target add wasm32-unknown-unknown --toolchain nightly

# rls
rustup component add rls rust-analysis rust-src
```
