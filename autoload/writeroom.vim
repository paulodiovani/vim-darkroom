" Write Room
" creates a center window to focus on text

" toggle writeroom to use a smaller viewport
function! writeroom#toggle()
  " make only window if writeroom is in use, of there is any vertical split
  if bufwinnr(g:writeroom_bufname) > 0 || len(filter(range(1, winnr('$')), 'winwidth(v:val) != &columns')) > 0
    " focus on first non-writeroom window, if needed
    if bufname() == g:writeroom_bufname
      let l:focus_window = filter(range(1, winnr('$')), 'bufname(winbufnr(v:val)) != g:name')[0]
      exec l:focus_window . 'wincmd w'
    endif
    only
  else
    " or create writeroom windows
    let l:width = (&columns - g:writeroom_min_columns) / 2
    if l:width < 0
      return
    end

    call writeroom#split_window('topleft', l:width)
    call writeroom#split_window('botright', l:width)
  endif
endfunction

" split window at the given positio and set win highlight
function! writeroom#split_window(position, width)
  execute 'vert' a:position a:width .. 'sview +setlocal\' g:writeroom_params g:writeroom_bufname
  set winhighlight=Normal:WriteRoomNormal
  wincmd p
endfunction

" darken a hex color
function! writeroom#darken_color(hex, percent)
  let l:rgb = [str2nr(a:hex[1:2], 16), str2nr(a:hex[3:4], 16), str2nr(a:hex[5:6], 16)]
  let l:factor = 1 - (a:percent / 100.0)
  let l:darker_rgb = map(l:rgb, {_, v -> printf('%02x', max([0, float2nr(v * l:factor)]))})
  return '#' . join(l:darker_rgb, '')
endfunction

" get a darker background color
function! writeroom#get_darker_bg()
  echo g:writeroom_darken_percent
  let current_bg = synIDattr(hlID('Normal'), 'bg#')
  return writeroom#darken_color(current_bg, g:writeroom_darken_percent)
endfunction
