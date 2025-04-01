" Title:        WriteRoom plugin
" Description:  A plugin to create a focus centered window for typing.
" Last Change:  1 April 2025
" Maintainer:   Paulo Diovani <https://github.com/paulodiovani>

" Prevents the plugin from being loaded multiple times.
if exists("g:loaded_vim_writeroom")
    finish
endif
let g:loaded_vim_writeroom = 1

"""""""""""
" CONFIGS "
"""""""""""

" buffer name used in writeroom sde windows
let g:writeroom_bufname = get(g:, 'writeroom_bufname', '__writeroom__')
" percent to darken the bg color in writeroom side windows (may need to change to match theme)
let g:writeroom_darken_percent = get(g:, 'writeroom_darken_percent', 25)
" minimum number of columns for the writeroom main/center window
let g:writeroom_min_columns = get(g:, 'writeroom_min_columns', 130)
" window params used when creating writeroom windows
let g:writeroom_params = get(g:, 'writeroom_params', 'buftype=nofile\ bufhidden=wipe\ nomodifiable\ nobuflisted\ noswapfile\ nocursorline\ nocursorcolumn\ nonumber\ norelativenumber\ noruler\ nolist\ noshowmode\ noshowcmd')

" custom bg color
exec 'highlight WriteRoomNormal guibg=' .. writeroom#get_darker_bg()

""""""""""""
" COMMANDS "
""""""""""""

if !exists(':WriteRoomToggle')
  command! -nargs=0 WriteRoomToggle call writeroom#toggle()
endif

""""""""""""
" MAPPINGS "
""""""""""""

if !hasmapto('<Plug>WriteRoomToggle')
  nmap <unique> <Plug>WriteRoomToggle :WriteRoomToggle<CR>
  nmap <silent> <Leader><BS> <Plug>WriteRoomToggle
endif
