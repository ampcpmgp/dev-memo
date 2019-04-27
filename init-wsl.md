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
# restart
exit
wsl

# rls
rustup component add rls rust-analysis rust-src
```
