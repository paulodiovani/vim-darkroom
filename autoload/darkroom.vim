" Dark Room
" creates a center window to focus on text

" toggle darkroom to use a smaller viewport
function! darkroom#toggle()
  " make only window if darkroom is in use
  if s:is_active()
    " focus on first non-darkroom window, if needed
    if s:is_darkroom_window()
      let l:focus_window = s:get_windows('nondarkroom')[0]
      exec l:focus_window . 'wincmd w'
    endif
    only
  else
    call s:split_window('topleft')
    call s:split_window('botright')
  endif
endfunction

" runs a command on the specified darkroom window
function! darkroom#cmd(position, cmd)
  let l:width = s:get_darkroom_width()

  if a:position == 'topleft'
    let l:dest_window = 1
  else " botright
    let l:dest_window = '$'
  endif

  " make sure we have a window and move to it
  call s:split_window(a:position)
  silent exec l:dest_window 'wincmd w'

  try
    exec a:cmd
    call s:set_window_bg()
  catch
    " return to main window in case of error
    silent wincmd p
  endtry
endfunction

" get a darker background color
function! darkroom#get_darker_bg()
  let current_bg = synIDattr(hlID('Normal'), 'bg#')
  return s:darken_color(current_bg, g:darkroom_darken_percent)
endfunction

"""""""""""""""""""""
" PRIVATE FUNCTIONS "
"""""""""""""""""""""

" return true if darkroom layout is active,
function! s:is_active()
  if len(s:get_windows('darkroom')) >= 2
    return 1
  elseif len(s:get_windows('vertical')) >= 3
    return 1
  else
    return 0
  endif
endfunction

" Return a list of window numbers filtered by type:
"  'all'         - all windows (default)
"  'darkroom'    - only windows with darkroom settings applied
"  'nondarkroom' - only windows without darkroom settings
"  'vertical'    - only windows in vertical splits
"  'horizontal'  - only windows in horizontal splits
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
function! s:is_darkroom_window(window = 0)
  let l:buffer = bufname(winbufnr(a:window))
  return match(l:buffer, g:darkroom_bufname) >= 0
endfunction

" split window at the given positio and set win highlight
function! s:split_window(position)
  let l:width = s:get_darkroom_width()

  if l:width <= 0
    return
  endif

  " do not split if already have a left|right window
  if a:position == 'topleft' && winwidth(1) == l:width ||
        \ a:position == 'botright' && winwidth(winnr('$')) == l:width
    return
  endif

  execute 'vert' a:position l:width . 'sview +setlocal\' g:darkroom_params g:darkroom_bufname
  call s:set_window_bg()
  wincmd p
endfunction

" et darkroom windows width
function s:get_darkroom_width()
  return (&columns - g:darkroom_min_columns) / 2
endfunction

" get window background highlight
function! s:get_window_bg()
  if has('nvim')
    return matchstr(&winhighlight, 'Normal:\zs\w\+\ze')
  else
    return &wincolor
  endif
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
function! s:darken_color(hex, percent)
  let l:rgb = [str2nr(a:hex[1:2], 16), str2nr(a:hex[3:4], 16), str2nr(a:hex[5:6], 16)]
  let l:factor = 1 - (a:percent / 100.0)
  let l:darker_rgb = map(l:rgb, {_, v -> printf('%02x', max([0, float2nr(v * l:factor)]))})
  return '#' . join(l:darker_rgb, '')
endfunction
