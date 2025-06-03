" Title:        DarkRoom plugin
" Description:  A plugin to create a focus centered window for typing.
" Last Change:  1 April 2025
" Maintainer:   Paulo Diovani <https://github.com/paulodiovani>

" Prevents the plugin from being loaded multiple times.
if exists("g:loaded_vim_darkroom")
    finish
endif
let g:loaded_vim_darkroom = 1

"""""""""""
" CONFIGS "
"""""""""""

" buffer name used in darkroom sde windows
let g:darkroom_bufname = get(g:, 'darkroom_bufname', '__darkroom__')
" highlight group name used by darkroom
let g:darkroom_highlight = get(g:, 'darkroom_highlight', 'DarkRoomNormal')
" percent to darken the bg color in darkroom side windows (may need to change to match theme)
let g:darkroom_darken_percent = get(g:, 'darkroom_darken_percent', 25)
" minimum number of columns for the main/center window
let g:darkroom_min_columns = get(g:, 'darkroom_min_columns', 130)
" window params used when creating darkroom windows
let g:darkroom_params = get(g:, 'darkroom_params', 'buftype=nofile\ filetype=darkroom\ bufhidden=wipe\ nomodifiable\ nobuflisted\ noswapfile\ nocursorline\ nocursorcolumn\ nonumber\ norelativenumber\ noruler\ nolist\ noshowmode\ noshowcmd')

"""""""""""""""
" PLUGIN INIT "
"""""""""""""""

" set custom bg color
exec 'highlight' g:darkroom_highlight 'guibg=' . darkroom#get_darker_bg()

""""""""""""
" COMMANDS "
""""""""""""

" toggle darkroom windows
if !exists(':DarkRoomToggle')
  command! -nargs=0 DarkRoomToggle call darkroom#toggle()
endif

" run a command on the left darkroom window
if !exists(':DarkRoomLeft')
  command! -range -nargs=+ DarkRoomLeft call darkroom#cmd('topleft', '<args>')
endif

" run a command on the right darkroom window
if !exists(':DarkRoomRight')
  command! -range -nargs=+ DarkRoomRight call darkroom#cmd('botright', '<args>')
endif

" replace the left darkroom window with a Vim command
if !exists(':DarkRoomReplaceLeft')
  command! -range -nargs=+ DarkRoomReplaceLeft call darkroom#cmd('topleft', '<args>', 1)
endif

" replace the right darkroom window with a Vim command
if !exists(':DarkRoomReplaceRight')
  command! -range -nargs=+ DarkRoomReplaceRight call darkroom#cmd('botright', '<args>', 1)
endif

""""""""""""
" MAPPINGS "
""""""""""""

if !hasmapto('<Plug>DarkRoomToggle')
  nmap <unique> <Plug>DarkRoomToggle :DarkRoomToggle<CR>
  nmap <silent> <Leader><BS> <Plug>DarkRoomToggle
endif
