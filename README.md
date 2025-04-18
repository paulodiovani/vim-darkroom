# vim-darkroom

A Vim plugin that creates a focused centered window for typing.

![screenshot-001](media/screenshot-001.png)

## Features

- Written in pure vim script
- Toggle a centered writing area with darkened side panels
- Customizable width for the writing area
- Automatically darkens the side panels based on your current colorscheme
- Simple keybinding to toggle the DarkRoom mode

## Installation

### Using a plugin manager (recommended)

#### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'paulodiovani/vim-darkroom'
```

#### [Vundle](https://github.com/VundleVim/Vundle.vim)

```vim
Plugin 'paulodiovani/vim-darkroom'
```

#### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'paulodiovani/vim-darkroom'
```

### Manual installation

Clone this repository into your Vim plugins directory:

```bash
# For Vim
git clone https://github.com/paulodiovani/vim-darkroom.git ~/.vim/pack/plugins/start/vim-darkroom

# For Neovim
git clone https://github.com/paulodiovani/vim-darkroom.git ~/.local/share/nvim/site/pack/plugins/start/vim-darkroom
```

## Usage

Toggle DarkRoom mode with:
- `<Leader><BS>` (default mapping)
- `:DarkRoomToggle` command

## Configuration

Add the following settings to your `.vimrc` or `init.vim` to customize the plugin's behavior.
Default values are shown below.

```vim
" Buffer name used in DarkRoom side windows
let g:darkroom_bufname = '__darkroom__'

" Percent to darken the background color in side windows (0-100)
let g:darkroom_darken_percent = 25

" Minimum number of columns for the main/center window
let g:darkroom_min_columns = 130

" Window parameters for side panels
let g:darkroom_params = 'buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile nocursorline nocursorcolumn nonumber norelativenumber noruler nolist noshowmode noshowcmd'
```
