" Skip if filetype is sage.python
if match(&ft, '\v<sage>') != -1
    finish
endif

" Ensure that plugin/vimcmdline.vim was sourced
if !exists("g:cmdline_job")
    runtime plugin/vimcmdline.vim
endif

if exists("g:cmdline_app")
    if has_key(g:cmdline_app, "python")
        if match(g:cmdline_app["python"], "ipython") != -1
            let b:cmdline_ipython = 1
        elseif match(g:cmdline_app["python"], "jupyter") != -1
            let b:cmdline_jupyter = 1
        endif
    endif
endif

function! PythonSourceLines(lines)
    if exists("b:cmdline_ipython") || exists("b:cmdline_jupyter")
        " Use bracketed paste for ipython or jupyter
        call VimCmdLineSendCmd("\e[200~")
        call VimCmdLineSendCmd(join(a:lines, b:cmdline_nl))
        call VimCmdLineSendCmd("\e[201~")
    else
        if a:lines[len(a:lines)-1] == ''
            call VimCmdLineSendCmd(join(a:lines, b:cmdline_nl))
        else
            call VimCmdLineSendCmd(join(add(a:lines, ''), b:cmdline_nl))
        endif
    endif
endfunction

function! PythonSendLine()
    let line = getline(".")
    if line =~ '^class ' || line =~ '^def '
        let lines = []
        let idx = line('.')
        while idx <= line('$')
            if line != ''
                let lines += [line]
            endif
            let idx += 1
            let line = getline(idx)
            if line =~ '^\S'
                break
            endif
        endwhile
        let lines += ['']
        call PythonSourceLines(lines)
        exe idx
        return
    endif
    if strlen(line) > 0 || b:cmdline_send_empty
        call VimCmdLineSendCmd(line)
    endif
    call VimCmdLineDown()
endfunction

if has("win32") && g:cmdline_app["python"]=='python'
    let b:cmdline_nl = "\r\n"
else
    let b:cmdline_nl = "\n"
endif
if executable("python3")
    let b:cmdline_app = "python3"
else
    let b:cmdline_app = "python"
endif
let b:cmdline_quit_cmd = "quit()"
let b:cmdline_send = function('PythonSendLine')
let b:cmdline_source_fun = function("PythonSourceLines")
let b:cmdline_send_empty = 1
let b:cmdline_filetype = "python"

exe 'nmap <buffer><silent> ' . g:cmdline_map_start . ' :call VimCmdLineStartApp()<CR>'

call VimCmdLineSetApp("python")
