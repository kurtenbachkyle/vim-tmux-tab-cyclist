if exists("g:loaded_tmux_tab_cyclist") || &cp || v:version < 700
  finish
endif

let g:loaded_tmux_tab_cyclist = 0

function! s:IsLastTab(direction)
        let ct = tabpagenr()
        if a:direction == 0
                let nt = 1
        else
                let nt = tabpagenr("$")
        endif
        if ct == nt 
                return 1
        else
                return 0
        endif
endfunction

function! s:UseTmuxTabCyclistMappings()
  return !exists("g:tmux_tab_cyclist_no_mappings") || !g:tmux_tab_cyclist_no_mappings
endfunction

"From https://github.com/christoomey/vim-tmux-navigator
function! s:TmuxOrTmateExecutable()
  if s:StrippedSystemCall("[[ $TMUX == *'tmate'* ]] && echo 'tmate'") == 'tmate'
    return "tmate"
  else
    return "tmux"
  endif
endfunction

function! s:StrippedSystemCall(system_cmd)
  let raw_result = system(a:system_cmd)
  return substitute(raw_result, '^\s*\(.\{-}\)\s*\n\?$', '\1', '')
endfunction

function! s:UseTmuxNavigatorMappings()
  return !exists("g:tmux_navigator_no_mappings") || !g:tmux_navigator_no_mappings
endfunction

function! s:InTmuxSession()
  return $TMUX != ''
endfunction

function! s:TmuxSocket()
  " The socket path is the first value in the comma-separated list of $TMUX.
  return split($TMUX, ',')[0]
endfunction

function! s:TmuxCommand(args)
  let cmd = s:TmuxOrTmateExecutable() . ' -S ' . s:TmuxSocket() . ' ' . a:args
  return system(cmd)
endfunction

"end from https://github.com/christoomey/vim-tmux-navigator

function! s:NextTab(direction)
        let lt = s:IsLastTab(a:direction)
        if a:direction == 0 && lt == 0
                tabp
        elseif a:direction == 1 && lt == 0
                tabn
        elseif a:direction == 0
                let args = "select-window -l"
                silent call s:TmuxCommand(args)
        else
                let args = "select-window -n"
                silent call s:TmuxCommand(args)
        endif
endfunction

command! TmuxTabCyclistLeft call <SID>NextTab(0)
command! TmuxTabCyclistRight call <SID>NextTab(1)

if s:UseTmuxTabCyclistMappings()
        map <silent> [5;5~ :TmuxTabCyclistLeft<CR>
        map <silent> [6;5~ :TmuxTabCyclistRight<CR>
endif
