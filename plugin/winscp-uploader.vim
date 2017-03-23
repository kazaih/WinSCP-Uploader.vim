" ==================================================================================
" Author:   Kazutaka Aihara(b18c98specr@gmail.com)
" Version:  0.1.2
" URL:      https://github.com/kazaih/winscp-uploader
"
" Copyright (c) 2017 Kazutaka Aihara
" License: MIT license
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
" ==================================================================================

" Check OS
if !has("win32") && !has("win64")
  finish
endif

" Check reload
if exists('g:loaded_winscp_uploader')
  finish
endif

let g:loaded_winscp_uploader = 1

" Key bind
nnoremap <C-U> <ESC>:call WinSCPUpload() <CR>

function! WinSCPUpload()


	" WinSCP binary name
	if !exists("g:winscp_uploader_use_vim_dispatch")
		let g:winscp_uploader_use_vim_dispatch = 0
	endif

	" WinSCP binary name
	if !exists("g:winscp_uploader_binary")
		let g:winscp_uploader_binary = "winscp.com"
	endif

	" WinSCP binary path
	if !exists("g:winscp_uploader_binary_path")
		if has('win64')
		  let g:winscp_uploader_binary_path = "c:/Program Files (x86)/winscp/"
		elseif has('win32')
		  let g:winscp_uploader_binary_path = "c:/Program Files/winscp/"
		endif
	endif

	" Check WinSCP Installed
	let winscp_binary_path = g:winscp_uploader_binary_path . g:winscp_uploader_binary
	if !filereadable(winscp_binary_path)
		echo "Error : WinSCP not found. Please install WinSCP."
		return
	endif

	" Check configs
	if !exists("g:winscp_uploader_configs")
		echo "Eroor : Please setting configuration(g:winscp_uploader_configs)."
		return
	endif

	let current_file_path = substitute(expand("%:p"),"\\","/","g")
	let configs = g:winscp_uploader_configs

	for key in keys(configs)
		let config = configs[key]
		let local_path = substitute(config['local_path'],"\\","/","g")
		if current_file_path =~ "^" . local_path
			let target_config        = config
			let target_server       = key
			let target_relative_file = current_file_path[strlen(local_path):]
			:break
		endif
	endfor

	if !exists("target_server")
		echo "Eroor : Please setting configuration(g:winscp_uploader_configs)."
		return
	endif
	" Check config format
	if !has_key(target_config, 'account') || !has_key(target_config, 'password') || !has_key(target_config, 'host') || !has_key(target_config, 'port')
		echo "Eroor : Please setting configuration(g:winscp_uploader_configs)."
		return
	endif

	let local_transfer_file  = substitute(target_config['local_path'],"\\","/","g") . target_relative_file
	let remote_received_path = target_config['remote_path'] . substitute(target_relative_file,expand("%"),"","g")

	if current_file_path != local_transfer_file
		echo "Error : The current file and transfer file are different."
		return
	endif

	echo "Transfer file : " . local_transfer_file
	echo "Received file : " . remote_received_path . expand("%")

	" Create WinSCP script file
	let scriptfile = $HOME . "/$winscp_script$"
	execute ":redir! > " . scriptfile
		:silent! echon "option batch on\r\n"
		:silent! echon "option confirm on\r\n"
		:silent! echon printf("open scp://%s:%s@%s:%s\r\n", target_config['account'], target_config['password'], target_config['host'], target_config['port'])
		:silent! echon printf("cd %s\r\n", iconv(remote_received_path, "sjis", "utf-8"))
		:silent! echon "option transfer binary\r\n"
		:silent! echon printf("put %s\r\n",iconv(substitute(local_transfer_file,"/","\\","g"), "sjis", "utf-8"))
		:silent! echon "close\r\n"
		:silent! echon "exit\r\n"
	redir END

	let command = "\"" . substitute(g:winscp_uploader_binary_path . g:winscp_uploader_binary,"/","\\","g") . "\" /script=" .  substitute(scriptfile,"/","\\","g") .""""
	echo command
	let choice = confirm("Do you want to upload the file?", "&Yes\n&No", 2)
	if choice != 1
		echo "Upload Canceled."
		return
	endif

	 if g:winscp_uploader_use_vim_dispatch && exists('g:loaded_dispatch')
		silent! exe 'Start!' command
	 else
		silent! exe '!' . command
	endif

	call delete(scriptfile)

endfunction

