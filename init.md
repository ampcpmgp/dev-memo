
# install chocolatey
choco install -yf --allow-empty-checksums nodist lhaplus notepadplusplus googlechrome firefox crystaldiskinfo greenshot crystaldiskmark gitkraken libreoffice googlechrome.canarcy win32diskimager.install virtualbox slack autoit winmerge atom screentogif githubforwindows wechat visualstudio2015community visualstudiocode joytokey charles itunes clover

# download
* color picker - http://www.vector.co.jp/soft/dl/win95/art/se350616.html
* ios webkit debugger ( required itunes ) - https://github.com/google/ios-webkit-debug-proxy
* clibor - https://www.vector.co.jp/soft/winnt/util/se472890.html

# atom package
apm install pigments highlight-selected editorconfig linter script atom-terminal file-icons atom-beautify linter-eslint linter-ui-default linter-js-standard standard-formatter markdown-preview-enhanced docblockr linter-coffee-variables svg-preview restart-atom busy-signal intentions atom-mermaid@2.2.1 sort-lines atom-live-server atom-html-preview prettier-atom autoclose-html file-watcher GhostText/GhostText-for-Atom sequential-number

# windows config environment
* 拡張子を表示する
* Ctrl+Alt+上下による画面回転を無効にする（デスクトップ上で右クリック→グラフィックスオプション→ホットキー無効）

# firefox 
about:config / security.csp.enable の設定検討 / S3.translator 翻訳のため

# atom settings

## stylesheet
```
atom-text-editor {
  // font-family: "Ubuntu Mono";
  font-family: "Avenir Next",Verdana, "ヒラギノ角ゴ Pro W3", "Hiragino Kaku Gothic Pro", "游ゴシック", "Yu Gothic", "メイリオ", Meiryo, Osaka, sans-serif;
}
```

## snippets 
```

'.source.js':
  'JSON.stringify 1 line':
    'prefix': 'logj'
    'body': 'console.log(JSON.stringify($1))'
  'JSON.stringify':
    'prefix': 'logj_line_shaping'
    'body': 'console.log(JSON.stringify($1, null, \'  \'))'

'.text.html':
  'less scope':
    'prefix': 'lesss'
    'body': """
      <style type="less">
        :scope {
          $1
        }
      </style>
    """
  'less':
    'prefix': 'less'
    'body': """
      <style type="less">
        $1
      </style>
    """
```
