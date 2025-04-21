" Dark Room
" creates a center window to focus on text

" toggle darkroom to use a smaller viewport
"
" @return void
function! darkroom#toggle()
  " make only window if darkroom is in use
  if s:is_active()
    " focus on first non-darkroom window, if needed
    if s:is_darkroom_window()
      let l:focus_window = s:get_windows('nondarkroom')[0]
      exec l:focus_window . 'wincmd w'
    endif

    " close darkroom windows (in reverse bc of win numbers)
    for l:window in reverse(s:get_windows('darkroom'))
      exec l:window 'wincmd c'
    endfor
  else
    if ! s:is_darkroom_window(1) | call s:split_window('topleft') | endif
    if ! s:is_darkroom_window(winnr('$')) | call s:split_window('botright') | endif
  endif
endfunction

" runs a command on the specified darkroom window
"
" @param {string} position - 'topleft' or 'botright' window position
" @param {string} cmd - vim command to execute in the darkroom window
" @param {number} replace - 1 to replace the window with the command output
" @return void
function! darkroom#cmd(position, cmd, replace = 0)
  let l:width = s:get_darkroom_width()

  if a:position == 'topleft'
    let l:dest_window = 1
  else " botright
    let l:dest_window = winnr('$')
  endif

  try
    if a:replace == 1
      " close darkroom window first, if exists
      if s:is_darkroom_window(l:dest_window) | exec l:dest_window 'wincmd c' | endif
      exec 'vert' a:position a:cmd
      exec 'vert' l:dest_window 'resize' s:get_darkroom_width()
    else
      " make sure we have a window and move to it
      if ! s:is_darkroom_window(l:dest_window) | call s:split_window(a:position) | endif
      exec l:dest_window 'wincmd w'
      exec a:cmd
    endif

    call s:set_window_bg()
  catch
    echoerr v:exception
    " return to main window in case of error
    silent wincmd p
  endtry
endfunction

" get a darker background color
"
" @return {string} - hex color code for darkened background
function! darkroom#get_darker_bg()
  let current_bg = synIDattr(hlID('Normal'), 'bg#')
  return s:darken_color(current_bg, g:darkroom_darken_percent)
endfunction

"""""""""""""""""""""
" PRIVATE FUNCTIONS "
"""""""""""""""""""""

" return true if darkroom layout is active
"
" @return {number} - 1 if darkroom is active, 0 otherwise
function! s:is_active()
  if len(s:get_windows('darkroom')) >= 2
    " true if there are 2 darkroom windows
    return 1
    " true if there are any 3 vertical windows
  elseif len(s:get_windows('vertical')) >= 3
    return 1
  else
    return 0
  endif
endfunction

" Return a list of window numbers filtered by type:
"
" @param {string} type - Filter type:
"   'all'         - all windows (default)
"   'darkroom'    - only windows with darkroom settings applied
"   'nondarkroom' - only windows without darkroom settings
"   'vertical'    - only windows in vertical splits
"   'horizontal'  - only windows in horizontal splits
" @return {list} - List of window numbers matching the filter type
function! s:get_windows(type = 'all')
  let l:windows = range(1, winnr('$'))

  if a:type == 'darkroom'
    " return darkroom windows
    return filter(l:windows, {idx, val -> s:is_darkroom_window(val) })
  elseif a:type == 'nondarkroom'
    " return non-darkroom windows
    return filter(l:windows, {idx, val -> !s:is_darkroom_window(val) })
  elseif a:type == 'vertical'
    " return vertical split windows
    return filter(l:windows, {idx, val -> winwidth(val) != &columns })
  elseif a:type == 'horizontal'
    " return horizontal split windows
    return filter(l:windows, {idx, val -> winheight(val) != &lines - &cmdheight - 1 })
  else " if a:type == 'all'
    " return all windows
    return l:windows
  endif
endfunction

" check if window is a darkroom window
"
" @param {number} window - Window number (0 for current window)
" @return {number} - 1 if window is a darkroom window, 0 otherwise
function! s:is_darkroom_window(window = 0)
  let l:buffer = bufname(winbufnr(a:window))

  return match(l:buffer, g:darkroom_bufname) >= 0
        \ || winwidth(a:window) == s:get_darkroom_width()
endfunction

" split window at the given position and set win highlight
"
" @param {string} position - 'topleft' or 'botright'
" @return void
function! s:split_window(position)
  let l:width = s:get_darkroom_width()

  if l:width <= 0
    return
  endif

  execute 'vert' a:position l:width . 'sview +setlocal\' g:darkroom_params g:darkroom_bufname
  call s:set_window_bg()
  wincmd p
endfunction

" get darkroom windows width
"
" @return {number} - Width for darkroom windows in columns
function s:get_darkroom_width()
  return (&columns - g:darkroom_min_columns) / 2
endfunction

" darken window background
function! s:set_window_bg()
  if has('nvim')
    exec 'set winhighlight=Normal:' . g:darkroom_highlight
  else
    exec 'set wincolor=' . g:darkroom_highlight
  endif
endfunction

" darken a hex color
"
" @param {string} hex - Hex color code (format: '#rrggbb')
" @param {number} percent - Percentage to darken by (0-100)
" @return {string} - Darkened hex color code
function! s:darken_color(hex, percent)
  let l:rgb = [str2nr(a:hex[1:2], 16), str2nr(a:hex[3:4], 16), str2nr(a:hex[5:6], 16)]
  let l:factor = 1 - (a:percent / 100.0)
  let l:darker_rgb = map(l:rgb, {_, v -> printf('%02x', max([0, float2nr(v * l:factor)]))})
  return '#' . join(l:darker_rgb, '')
endfunction
