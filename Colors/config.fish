# Source the default CachyOS fish config
source /usr/share/cachyos-fish-config/cachyos-config.fish

function fish_greeting
    fastfetch \
      --logo-type file \
      -l ~/.config/fastfetch/input.txt \
      -c ~/.config/fastfetch/config.jsonc
end

#/home/ab/.config/fastfetch/logo.jsonc;

# Custom prompt
function fish_prompt
    # Top line: show last command duration if available, else show time

    if set -q __fish_command_duration
        set_color "#124b18"  # soft green
        echo -n "┬"
        set_color "#494d64"  # dark gray-purple
        echo -n " "
        set_color "#494d64"  # dark gray-purple
        echo -n "$__fish_command_duration""s"
    else
        set_color "#124b18"  # soft green
        echo -n "┬"
        set_color "#494d64"  # dark gray-purple
        echo -n " "
        set_color "#494d64"  # dark gray-purple
        echo -n (string trim (date +"%l:%M%p"))
    end

    echo ""

    # Bottom line: arrow + username + pwd
    set_color "#124b18"  # soft green
    echo -n "╰─"

    set_color "#00fffa"  # magenta-rose
    echo -n (whoami)

    set_color "#7fda6a"  # desaturated rose/red
    echo -n "@"

    set_color "#087469"  # bright violet
    echo -n (pwd)

    set_color "#124b18"  # soft green
    echo -n "⩺ "

    set_color normal
end

# Preexec: store command start time
function fish_preexec --on-event fish_preexec
    set -g __fish_command_start_time (date +%s)
end

# Postexec: calculate duration
function fish_postexec --on-event fish_postexec
    if set -q __fish_command_start_time
        set current_time (date +%s)
        set -g __fish_command_duration (math "$current_time - $__fish_command_start_time")
    else
        set -g __fish_command_duration 0
    end
end
