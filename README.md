# vim-tmux-tab-cyclist
This plugin unifies navigation of vim tabs and tmux's windows.  When combined with bindings in your tmux.conf you can use ctrl-pageup and ctrl-pagedown to move through vim tabs in your open tmux windows.

**NOTE:** this was tested with tmux 2.0

## Usage

 - `C-PageUp` if in vim go to the previous vim tab, if no previous tab go to previous tmux window, cycling over tmux windows
 - `C-PageDown` if in vim go to the next vim tab, if no next tab go to next tmux window, cycling over tmux windows

## Installation
### Vim
Installing with [Vundle](https://github.com/VundleVim/Vundle.vim):
`Plugin 'kurtenbachkyle/vim-tmux-tab-cyclist'`

### Tmux
I have the following in my ~/tmux.conf

```
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
#Navigate around vim tabs like tmux windows
bind-key -n C-PageUp if-shell "$is_vim" "send-keys C-PageUp" "previous-window"
bind-key -n C-PageDown if-shell "$is_vim" "send-keys C-PageDown" "next-window"
bind-key C-p if-shell "$is_vim" "send-keys C-PageUp" "previous-window"
bind-key C-n if-shell "$is_vim" "send-keys C-PageDown" "next-window"

#Navigate just through tmux splits (on by default)
bind-key p "previous-window"
bind-key n "next-window"
```

With this I can use C-PageUp and C-Pagedown or bind-key C-p C-n to go between vim and tmux tabs.  If I want to skip over the vim tabs I can still use bind-key n or p to navigate just through tmux.
