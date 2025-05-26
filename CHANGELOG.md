# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.3.4

- Allow selection when using darkroom left/right commands.

## 0.3.3

- Fix open with darkroom

## 0.3.2

### Changed
- Fix helptags

## 0.3.1

### Added
- Added recommendation to use `set noequalalways` (or `set noea`) for optimal behavior

## 0.3.0

### Added
- New commands to run Vim commands in side panels:
  - `:DarkRoomLeft {cmd}` - Run command in left panel
  - `:DarkRoomRight {cmd}` - Run command in right panel
  - `:DarkRoomReplaceLeft {cmd}` - Replace left darkroom window with a Vim command
  - `:DarkRoomReplaceRight {cmd}` - Replace right darkroom window with a Vim command
- New `g:darkroom_highlight` configuration option to customize highlight group name
- Better window detection with new helper functions
- Improved darkroom toggle behavior with better window management

### Changed
- Refactored internal functions with improved documentation
- Better error handling when running commands in side panels

### Fixed
- Issue with detecting active darkroom windows in vertical splits

## 0.2.0

### Changed
- Renamed plugin from "writeroom" to "darkroom"
- Updated documentation to reflect new plugin name

## 0.1.2

### Added
- Added support for Vim in addition to Neovim

### Fixed
- Removed debugging output

## 0.1.1

### Added
- Added Vim help documentation

## 0.1.0

### Added
- Initial release
- Toggle centered writing area with darkened side panels
- Automatically darken side panels based on current colorscheme
