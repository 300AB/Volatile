# Source the default CachyOS fish config
source /usr/share/cachyos-fish-config/cachyos-config.fish

# Custom prompt
function fish_prompt
    # Top line: show last command duration if available, else show time
    set_color "#43C776"  # green for time box
    if set -q __fish_command_duration
        echo -n "┐{"$__fish_command_duration"s}"
    else
        # use %l for 12-hour without leading zero, trim spaces
        echo -n "┐{"(string trim (date +"%l:%M%p"))"}"
    end

    # Newline
    echo ""

    # Bottom line: prompt arrow + username@hostname
    set_color "#43C776"  # green arrow
    echo -n "╰─"

    set_color "#C74395"  # magenta/pink for username
    echo -n (whoami)

    set_color "#B21F4E"  # deep red separator
    echo -n "@"

    set_color "#AD27F5"  # bright violet hostname
    echo -n (hostname)

    set_color "#43C776"  # green arrow end
    echo -n "⩺ "

    # Reset color
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
