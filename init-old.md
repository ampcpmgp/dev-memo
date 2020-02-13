# 過去の設定

## download

* glslang - https://github.com/KhronosGroup/glslang/releases
  * vscode/mrjjot.vscode-glsl-linter に実行パスを設定する
  
  
## vscode packages 

```shell
code --install-extension circledev.glsl-canvas --install-extension slevesque.shader --install-extension mrjjot.vscode-glsl-linter 
```


## vscode user settings

```json
{
    // glslang のパスを設定する
    "glsl-linter.validatorPath": "C:\\MyPrograms\\glslang-master-windows-x64-Release\\bin\\glslangValidator.exe",
    "glsl-linter.validatorArgs": "",
}
```


`User Snippets -> glsl`

https://gist.github.com/lewislepton/8b17f56baa7f1790a70284e7520f9623
