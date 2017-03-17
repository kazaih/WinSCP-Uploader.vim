WinSCP-Uploader.vim
===================
WinSCP-Uploader.vim Version 0.1.0
----------------------

About
-----
Windows用SCPソフトウェア「WinSCP」を利用して編集中のファイルをVimからアップロードするプラグイン

Installation
------------
```
cd ~/.vim/bundle
git clone https://github.com/kazaih/winscp-uploader.vim

※本プラグインの利用にはWinSCPのインストールが必要です。
```

Usage
-----
    <leader>wsup

Configuration
-----
* `g:winscp_uploader_configs`

   ファイルアップロード先設定です。
   以下の形式で設定してください。

    ```
    let g:winscp_uploader_configs = {
    \   'sample_server1' : {
    \       'local_path'  : $HOME . '/sample1/sample_source/',
    \       'remote_path' : '/var/www/sample1',
    \       'account' : 'guest',
    \       'password' : 'password',
    \       'host' : 'sample1_server',
    \       'port' : '22'
    \   },
    \   'sample_server2' : {
    \       'local_path'  : $HOME . '/sample2/sample_source/',
    \       'remote_path' : '/var/www/sample2',
    \       'account' : 'guest',
    \       'password' : 'password',
    \       'host' : 'sample2_server',
    \       'port' : '22'
    \   },
    }
    ```

* `g:winscp_uploader_use_vim_dispatch`
    * Default: `0`

    Vim-Dispatchによる非同期アップロードの設定です。  
    Vim-Dispatchは、システムコマンドの非同期呼び出しを可能にするプラグインです。  
    `0` 通常アップロード  
    `1` 非同期アップロード

* `g:winscp_uploader_binary_path`
   * Windows 32bit
      * Default: `c:/Program Files/winscp/`
   * Windows 64bit
      * Default: `c:/Program Files (x86)/winscp/`

  WinSCPインストール先ディレクトリ設定です。

Key mapping
-----------
例）

Ctrl+u  
    `nnoremap <C-U> <ESC>:call WinSCPUpload() <CR>`


License
-----------

```
License: MIT license
    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
```

