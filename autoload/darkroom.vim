" Dark Room
" creates a center window to focus on text

" toggle darkroom to use a smaller viewport
function! darkroom#toggle()
  " make only window if darkroom is in use, of there is any vertical split
  if bufwinnr(g:darkroom_bufname) > 0 || len(filter(range(1, winnr('$')), 'winwidth(v:val) != &columns')) > 0
    " focus on first non-darkroom window, if needed
    if bufname() == g:darkroom_bufname
      let l:focus_window = filter(range(1, winnr('$')), 'bufname(winbufnr(v:val)) != g:name')[0]
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

" split window at the given positio and set win highlight
function! s:split_window(position, width)
  execute 'vert' a:position a:width .. 'sview +setlocal\' g:darkroom_params g:darkroom_bufname

  if has('nvim')
    set winhighlight=Normal:DarkRoomNormal
  else
    set wincolor=DarkRoomNormal
  endif

  wincmd p
endfunction

" darken a hex color
function! s:darken_color(hex, percent)
  let l:rgb = [str2nr(a:hex[1:2], 16), str2nr(a:hex[3:4], 16), str2nr(a:hex[5:6], 16)]
  let l:factor = 1 - (a:percent / 100.0)
  let l:darker_rgb = map(l:rgb, {_, v -> printf('%02x', max([0, float2nr(v * l:factor)]))})
  return '#' . join(l:darker_rgb, '')
endfunction