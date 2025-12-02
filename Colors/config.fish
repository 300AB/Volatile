# -------------------------------------
#  COLOR PALETTE (reference only)
# -------------------------------------
#  Top Line:       #124b18  (soft green)
#  Time/Duration:  #494d64  (dark gray-purple)
#  Arrow:          #124b18  (soft green)
#  User:           #00fffa  (magenta-rose)
#  Host/Dir:       #7fda6a / #087469 (desaturated rose/red / bright violet)
# -------------------------------------

# -------------------------------------
#  Source default CachyOS fish config
# -------------------------------------
source /usr/share/cachyos-fish-config/cachyos-config.fish

# -------------------------------------
#  Greeting: runs fastfetch with logo + config
# -------------------------------------
function fish_greeting
    fastfetch \
      --logo-type file \
      -l ~/.config/fastfetch/input.txt \
      -c ~/.config/fastfetch/config.jsonc
end


# -------------------------------------
#  Custom prompt
# -------------------------------------
function fish_prompt
    # Top line: show last command duration if available, else show current time
    if set -q __fish_command_duration
        set_color "#124b18"  # soft green
        echo -n "┬"
        set_color "#494d64"  # dark gray-purple
        echo -n " "
        set_color "#494d64"  # dark gray-purple
        echo -n "$__fish_command_duration"
    else
        set_color "#124b18"  # soft green
        echo -n "┬"
        set_color "#494d64"  # dark gray-purple
        echo -n " "
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

# -------------------------------------
#  Preexec: store command start time in nanoseconds
# -------------------------------------
function fish_preexec --on-event fish_preexec
    set -g __fish_command_start_time (date +%s%N)
end

# -------------------------------------
#  Postexec: calculate command duration with dynamic formatting
#  Converts:
#    <1s   -> ms (3 digits max, e.g., 1.23ms)
#    <60s  -> s  (2 decimals max, trim trailing zeros, e.g., 4s, 1.02s)
#    >=60s -> m  (2 decimals max, trim trailing zeros, e.g., 1m, 1.03m)
# -------------------------------------
function fish_postexec --on-event fish_postexec
    if set -q __fish_command_start_time
        set current_time (date +%s%N)
        set duration_ns (math "$current_time - $__fish_command_start_time")
        set duration (math "$duration_ns / 1000000000")

        # Duration < 1 second -> milliseconds
        if test $duration -lt 1
            set ms (math "$duration_ns / 1000000")
            set ms (string match -r '^\d+\.?\d{0,2}' $ms)
            set ms (string replace -r '\.?0+$' '' $ms)
            set -g __fish_command_duration "$ms""ms"

        # Duration < 60 seconds -> seconds
        else if test $duration -lt 60
            set secs (string match -r '^\d+\.?\d{0,2}' $duration)
            set secs (string replace -r '\.?0+$' '' $secs)
            set -g __fish_command_duration "$secs""s"

        # Duration >= 60 seconds -> minutes
        else
            set mins (math "scale=2; $duration / 60")
            set mins (string match -r '^\d+\.?\d{0,2}' $mins)
            set mins (string replace -r '\.?0+$' '' $mins)
            set -g __fish_command_duration "$mins""m"
        end
    else
        set -g __fish_command_duration "0ms"
    end
end
