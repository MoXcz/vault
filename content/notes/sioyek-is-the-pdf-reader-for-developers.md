---
author: ["Oscar Marquez"]
title: "Sioyek is the PDF reader for developers"
date: "2026-03-16"
tags:
  - script
  - zsh
---
I previously used Zathura as my PDF reader of choice, it just did what it had to do with no complications: it read PDFs. But in one of my urge to try something new I found Sioyek, I can't remember exactly from where I initially found it, though I did watch a recent YouTube video by [Sylvan Franklin](https://youtu.be/vYQ4sri2_XE?si=LEPolNo7WeJkfBCr) talking about it.

I honestly do not think the change was necessary, as I don't even know if I could replicate my Sioyek configuration in Zathura, but I liked how simple it was to configure that I just didn't bother to search after the change.

For navigation, I remapped a couple of keys to match what I’m used to:
- `<C-d>` and `<C-u>` for larger jumps up and down the document
- `j` and `k` for small movements
- `t` to open the table of contents
- `o` to switch between recently opened PDFs

Here’s what that looks like in `keys_user.config`:
```
screen_down         <C-d>
screen_up           <C-u>
open_prev_doc       o
toggle_custom_color c
```

> Configuration files go over at `$HOME/.config/sioyek`

I also added a custom theme inspired on Kanagawa. I based myself off of the [dracula theme](https://draculatheme.com/sioyek) and just adjusted the colors to my liking that you can also include inside `prefs_user.config`:
```
# === KANAGAWA THEME === #
startup_commands		toggle_custom_color

background_color	   	#1f1f28
dark_mode_contrast 0.85
dark_mode_background_color 	#1f1f28

text_highlight_color 		#e6c384
visual_mark_color  		#1f1f28

search_highlight_color		#e6c384
link_highlight_color 		#7e9cd8
synctex_highlight_color		#98bb6c

highlight_color_a 		#e6c384
highlight_color_b		#98bb6c
highlight_color_c		#7fb4ca
highlight_color_d		#957fb8
highlight_color_e		#938aa9
highlight_color_f		#e82424
highlight_color_g		#c0a36e

font_size			12

custom_background_color 	#1f1f28
custom_text_color		#dcd7ba

ui_text_color 			#dcd7ba
ui_background_color 		#1f1f28
ui_selected_text_color 		#dcd7ba
ui_selected_background_color 	#2d4f67

status_bar_font_size    	16
```

And because I don't like using the file explorer that comes with Sioyek as I would have to use the mouse, I created a zsh function that searches for my books and displays a [fzf](https://github.com/junegunn/fzf) menu to select one:
```sh
function book() {
  if [ "$#" -ne 0 ]; then
    echo "Usage: book"
    return 1
  fi

  local BOOK_DIR="$HOME/Documents/books"
  if [ ! -d $BOOK_DIR ]; then
    echo "No books available"
    mkdir -p $BOOK_DIR
    return 1
  fi

  local BOOK=$(find ~/Documents/books -maxdepth 1 -name "*pdf" | fzf)
  if [[ -z $BOOK ]]; then
      return 0
  fi

  if ! pacman -Q "sioyek" &>/dev/null; then
      echo "sioyek is not installed"
      yay -S sioyek
  fi

  sioyek $BOOK &
}
```

This is mostly used just the first time I open a book, as later on Sioyek's `o` command to change between recently opened files is sufficient.