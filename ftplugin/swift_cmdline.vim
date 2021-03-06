" Ensure that plugin/vimcmdline.vim was sourced
if !exists("g:cmdline_job_nvim")||!exists("g:cmdline_job_vim")
    runtime plugin/vimcmdline.vim
endif

function! SwiftSourceLines(lines)
    call VimCmdLineSendCmd(join(add(a:lines, ''), b:cmdline_nl))
endfunction

let b:cmdline_nl = "\n"
let b:cmdline_quit_cmd = ":quit"
let b:cmdline_app = "swift"
let b:cmdline_source_fun = function("SwiftSourceLines")
let b:cmdline_send_empty = 1
let b:cmdline_filetype = "swift"

exe 'nmap <buffer><silent> ' . g:cmdline_map_start . ' :call VimCmdLineStartApp()<CR>'

call VimCmdLineSetApp("swift")
