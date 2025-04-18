" Dark Room
" creates a center window to focus on text

" toggle darkroom to use a smaller viewport
function! darkroom#toggle()
  " make only window if darkroom is in use, of there is any vertical split
  if s:is_active()
    " focus on first non-darkroom window, if needed
    if bufname() == g:darkroom_bufname
      let l:focus_window = s:get_windows(1)[0]
      exec l:focus_window . 'wincmd w'
    endif
    only
  else
    " or create darkroom windows
    let l:width = (&columns - g:darkroom_min_columns) / 2
    if l:width < 0
      return
    end

    call s:split_window('topleft', l:width)
    call s:split_window('botright', l:width)
  endif
endfunction

" get a darker background color
function! darkroom#get_darker_bg()
  let current_bg = synIDattr(hlID('Normal'), 'bg#')
  return s:darken_color(current_bg, g:darkroom_darken_percent)
endfunction

"""""""""""""""""""""
" PRIVATE FUNCTIONS "
"""""""""""""""""""""

function! s:get_windows(nodark = 0)
  if a:nodark
    return filter(range(1, winnr('$')), {idx, val -> s:get_window_bg(val) != 'DarkRoomNormal' })
  else
    return filter(range(1, winnr('$')), {idx, val -> s:get_window_bg(val) == 'DarkRoomNormal' })
  endif
endfunction

" return true if darkroom windows exist
function! s:is_active()
  return len(s:get_windows()) > 0
endfunction

" split window at the given positio and set win highlight
function! s:split_window(position, width)
  execute 'vert' a:position a:width .. 'sview +setlocal\' g:darkroom_params g:darkroom_bufname
  call s:set_window_bg()
  wincmd p
endfunction

" get window background highlight
function! s:get_window_bg(window = winnr())
  exec a:window . 'wincmd w'
  if has('nvim')
    return matchstr(&winhighlight, 'Normal:\zs\w\+\ze')
  else
    return &wincolor
  endif
  wincmd p
endfunction

" darken background of current window
function! s:set_window_bg()
  if has('nvim')
    set winhighlight=Normal:DarkRoomNormal
  else
    set wincolor=DarkRoomNormal
  endif
endfunction

" darken a hex color
function! s:darken_color(hex, percent)
  let l:rgb = [str2nr(a:hex[1:2], 16), str2nr(a:hex[3:4], 16), str2nr(a:hex[5:6], 16)]
  let l:factor = 1 - (a:percent / 100.0)
  let l:darker_rgb = map(l:rgb, {_, v -> printf('%02x', max([0, float2nr(v * l:factor)]))})
  return '#' . join(l:darker_rgb, '')
endfunction
