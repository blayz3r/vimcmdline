" Ensure that plugin/vimcmdline.vim was sourced
if !exists("g:cmdline_job")
    runtime plugin/vimcmdline.vim
endif
"Create function to send lines
function! JavaSourceLines(lines)
    call writefile(a:lines, g:cmdline_tmp_dir . "/lines.java")
    call VimCmdLineSendCmd("/open ".g:cmdline_tmp_dir ."\\lines.java\n/list")
endfunction

let b:cmdline_nl = "\n"
let b:cmdline_app = "jshell"
let b:cmdline_quit_cmd = "/exit"
let b:cmdline_source_fun = function("JavaSourceLines")
let b:cmdline_send_empty = 0
let b:cmdline_filetype = "java"

exe 'nmap <buffer><silent> ' . g:cmdline_map_start . ' :call VimCmdLineStartApp()<CR>'
exe 'autocmd VimLeave * call delete(g:cmdline_tmp_dir . "/lines.java")'
call VimCmdLineSetApp("java")
