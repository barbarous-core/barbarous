# Tmux Cheat Sheet

## Sessions

### Start a new session
- **Shell**: `tmux`
- **Shell**: `tmux new`
- **Shell**: `tmux new-session`
- **Tmux**: `:new`

### Start a new session or attach to an existing session named mysession
- **Shell**: `tmux new-session -A -s mysession`

### Start a new session with the name mysession
- **Shell**: `tmux new -s mysession`
- **Tmux**: `:new -s mysession`

### kill/delete the current session
- **Tmux**: `:kill-session`

### kill/delete session mysession
- **Shell**: `tmux kill-ses -t mysession`
- **Shell**: `tmux kill-session -t mysession`

### kill/delete all sessions but the current
- **Shell**: `tmux kill-session -a`

### kill/delete all sessions but mysession
- **Shell**: `tmux kill-session -a -t mysession`

### Rename session
- **Shortcut**: `Prefix $`

### Detach from session
- **Shortcut**: `Prefix d`

### Detach others on the session (Maximize window by detach other clients)
- **Tmux**: `:attach -d`

### Show all sessions
- **Shortcut**: `Prefix s`
- **Shell**: `tmux ls`
- **Shell**: `tmux list-sessions`

### Attach to last session
- **Shell**: `tmux a`
- **Shell**: `tmux at`
- **Shell**: `tmux attach`
- **Shell**: `tmux attach-session`

### Attach to a session with the name mysession
- **Shell**: `tmux a -t mysession`
- **Shell**: `tmux at -t mysession`
- **Shell**: `tmux attach -t mysession`
- **Shell**: `tmux attach-session -t mysession`

### Session and Window Preview
- **Shortcut**: `Prefix w`

### Move to previous session
- **Shortcut**: `Prefix (`

### Move to next session
- **Shortcut**: `Prefix )`

## Windows

### start a new session with the name mysession and window mywindow
- **Shell**: `tmux new -s mysession -n mywindow`

### Create window
- **Shortcut**: `Prefix c`

### Rename current window
- **Shortcut**: `Prefix ,`

### Close current window
- **Shortcut**: `Prefix &`

### List windows
- **Shortcut**: `Prefix w`

### Previous window
- **Shortcut**: `Prefix p`

### Next window
- **Shortcut**: `Prefix n`

### Switch/select window by number
- **Shortcut**: `Prefix 0 ... 9`

### Toggle last active window
- **Shortcut**: `Prefix l`

### Reorder window, swap window number 2(src) and 1(dst)
- **Tmux**: `:swap-window -s 2 -t 1`

### Move current window to the left by one position
- **Tmux**: `:swap-window -t -1`

### Move window from source to target
- **Tmux**: `:move-window -s src_ses:win -t target_ses:win`
- **Tmux**: `:movew -s foo:0 -t bar:9`
- **Tmux**: `:movew -s 0:0 -t 1:9`

### Reposition window in the current session
- **Tmux**: `:move-window -s src_session:src_window`
- **Tmux**: `:movew -s 0:9`

### Renumber windows to remove gap in the sequence
- **Tmux**: `:move-window -r`
- **Tmux**: `:movew -r`

## Panes

### Toggle last active pane
- **Shortcut**: `Prefix ;`

### Split the current pane with a vertical line to create a horizontal layout
- **Shortcut**: `Prefix %`
- **Tmux**: `:split-window -h`

### Split the current  with a horizontal line to create a vertical layout
- **Shortcut**: `Prefix "`
- **Tmux**: `:split-window -v`

### Join two windows as panes (Merge window 2 to window 1 as panes)
- **Tmux**: `:join-pane -s 2 -t 1`

### Move pane from one window to another (Move pane 1 from window 2 to pane after 0 of window 1)
- **Tmux**: `:join-pane -s 2.1 -t 1.0`

### Move the current pane left
- **Shortcut**: `Prefix {`

### Switch to pane to the direction
- **Shortcut**: `Prefix Up`
- **Shortcut**: `Prefix Down`
- **Shortcut**: `Prefix Right`
- **Shortcut**: `Prefix Left`

### Toggle synchronize-panes(send command to all panes)
- **Tmux**: `:setw synchronize-panes`

### Toggle between pane layouts
- **Shortcut**: `Prefix Spacebar`

### Switch to next pane
- **Shortcut**: `Prefix o`

### Show pane numbers
- **Shortcut**: `Prefix q`

### Switch/select pane by number
- **Shortcut**: `Prefix q 0 ... 9`

### Toggle pane zoom
- **Shortcut**: `Prefix z`

### Convert pane into a window
- **Shortcut**: `Prefix !`

### Resize current pane height(holding second key is optional)
- **Shortcut**: `Prefix + Up`
- **Shortcut**: `Prefix Ctrl + Up`
- **Shortcut**: `Prefix + Down`
- **Shortcut**: `Prefix Ctrl + Down`

### Resize current pane width(holding second key is optional)
- **Shortcut**: `Prefix + Right`
- **Shortcut**: `Prefix Ctrl + Right`
- **Shortcut**: `Prefix + Left`
- **Shortcut**: `Prefix Ctrl + Left`

### Close current pane
- **Shortcut**: `Prefix x`

## Copy Mode

### use vi keys in buffer
- **Tmux**: `:setw -g mode-keys vi`

### Enter copy mode
- **Shortcut**: `Prefix [`

### Enter copy mode and scroll one page up
- **Shortcut**: `Prefix PgUp`

### Quit mode
- **Shortcut**: `q`

### Go to top line
- **Shortcut**: `g`

### Go to bottom line
- **Shortcut**: `G`

### Scroll up
- **Shortcut**: `Up`

### Scroll down
- **Shortcut**: `Down`

### Move cursor left
- **Shortcut**: `h`

### Move cursor down
- **Shortcut**: `j`

### Move cursor up
- **Shortcut**: `k`

### Move cursor right
- **Shortcut**: `l`

### Move cursor forward one word at a time
- **Shortcut**: `w`

### Move cursor backward one word at a time
- **Shortcut**: `b`

### Search forward
- **Shortcut**: `/`

### Search backward
- **Shortcut**: `?`

### Next keyword occurance
- **Shortcut**: `n`

### Previous keyword occurance
- **Shortcut**: `N`

### Start selection
- **Shortcut**: `Spacebar`

### Clear selection
- **Shortcut**: `Esc`

### Copy selection
- **Shortcut**: `Enter`

### Paste contents of buffer_0

### display buffer_0 contents
- **Tmux**: `:show-buffer`

### copy entire visible contents of pane to a buffer
- **Tmux**: `:capture-pane`

### Show all buffers
- **Tmux**: `:list-buffers`

### Show all buffers and paste selected
- **Tmux**: `:choose-buffer`

### Save buffer contents to buf.txt
- **Tmux**: `:save-buffer buf.txt`

### delete buffer_1
- **Tmux**: `:delete-buffer -b 1`

## Misc

### Enter command mode
- **Shortcut**: `Prefix :`

### Set OPTION for all sessions
- **Tmux**: `:set -g OPTION`

### Set OPTION for all windows
- **Tmux**: `:setw -g OPTION`

### Enable mouse mode
- **Tmux**: `:set mouse on`

## Help

### List key bindings(shortcuts)
- **Shortcut**: `Prefix ?`
- **Shell**: `tmux list-keys`
- **Tmux**: `:list-keys`

### Show every session, window, pane, etc...
- **Shell**: `tmux info`
