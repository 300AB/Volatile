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
#  Set default terminal emulator
# -------------------------------------
set -gx TERMINAL wezterm

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
#  F5 function, just reloads fish
# -------------------------------------
function f5
    source ~/.config/fish/config.fish
    echo "Fish reloaded"
end

# -------------------------------------
#  Smh Function
# -------------------------------------
function smh
    set msg $argv[1]
    set raw $argv[2]
    set amount (string match -r '\d+' $raw)
    set unit (string match -r '[a-z]+' $raw)

    switch $unit
        case m min minute minutes
            set unit "minute"
        case h hr hour hours
            set unit "hour"
    end

    if test $amount -gt 1
        set unit "$unit"s
    end

    echo "DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send 'Reminder' '$msg'" | at now + $amount $unit 2>/dev/null
    echo "⏰ Reminder set for $amount $unit from now"
end

function smh-undo
    set last (atq | sort -k1 -n | tail -1 | awk '{print $1}')
    if test -n "$last"
        atrm $last
        echo "❌ Removed job $last"
    else
        echo "No jobs in queue"
    end
end

# -------------------------------------
#  Paru edit to colors
# -------------------------------------

function paru
    set green (set_color green)
    set blue (set_color blue)
    set normal (set_color normal)
    set pkg_name (set_color magenta)
    set bracket (set_color brblack)
    command paru --color=always $argv | \
        sed -E 's/\[(\x1b\[1m)(\+[0-9]+) (~[0-9.]+)(\x1b\[0m)\]/'"$bracket"'['"$green"'\2 '"$blue"'\3'"$bracket"']'"$normal"'/g' | \
        sed -E 's|/(\x1b\[1m)([a-zA-Z0-9._-]+)(\x1b\[0m)|'"$bracket"'/'"$pkg_name"'\2'"$normal"'|g'
end

# -------------------------------------
#  Pacman edit to colors
# -------------------------------------

function pacman
    set yellow (set_color yellow)
    set magenta (set_color magenta)
    set bracket (set_color brblack)
    set green (set_color green)
    set normal (set_color normal)
    command pacman --color=never $argv | awk -v yellow="$yellow" -v magenta="$magenta" -v bracket="$bracket" -v green="$green" -v normal="$normal" '
        /^[^ ]/ && /\// {
            match($0, /^([^\/]+)\/([^ ]+) ([^ ]+)(.*)$/, arr)
            print yellow arr[1] bracket "/" magenta arr[2] " " green arr[3] normal arr[4]
            next
        }
        { print normal $0 }
    '
end

# -------------------------------------
#  Fish colorings
# -------------------------------------
set fish_color_comment "#124b18"

# -------------------------------------
#  Grep with persistent colors
# -------------------------------------
set -gx GREP_COLORS 'mt=1;32:fn=35:ln=32:se=36'  # modern syntax: match=green, filename=magenta, line=green, separator=cyan
abbr -a -g grep 'grep --color=auto'
abbr -a -g egrep 'egrep --color=auto'
abbr -a -g fgrep 'fgrep --color=auto'

# -------------------------------------
#  Useful abbreviations
# -------------------------------------

# Package management
abbr -a -g up 'sudo pacman -Syu'           # Quick system update
abbr -a -g inst 'sudo pacman -S'           # Quick install
abbr -a -g rem 'sudo pacman -Rns'          # Remove with dependencies
abbr -a -g search 'pacman -Ss'             # Search packages
abbr -a -g clean 'sudo pacman -Sc'         # Clean package cache
abbr -a -g orphans 'sudo pacman -Rns (pacman -Qtdq)'  # Remove orphaned packages

# Modern replacements
abbr -a -g ll 'eza -la --git --icons'      # Better ls with git status
abbr -a -g ls 'eza'                        # Replace ls entirely
abbr -a -g tree 'eza --tree'               # Tree view
abbr -a -g cat 'bat --style=auto'          # Better cat with auto-paging

# Navigation & system
abbr -a -g c 'clear'                       # Quick clear
abbr -a -g .. 'cd ..'                      # Up one directory
abbr -a -g ... 'cd ../..'                  # Up two directories
abbr -a -g - 'cd -'                        # Go to previous directory

# Utilities
abbr -a -g math --set-cursor 'math "%"'    # Quick math
abbr -a -g ports 'sudo ss -tulpn'          # Show listening ports
abbr -a -g df 'df -h'                      # Human-readable disk space
abbr -a -g free 'free -h'                  # Human-readable memory

# Git shortcuts (if you use git)
abbr -a -g g 'git'
abbr -a -g gs 'git status'
abbr -a -g ga 'git add'
abbr -a -g gc 'git commit'
abbr -a -g gp 'git push'

# -------------------------------------
#  Eza configuration
# -------------------------------------
set -gx EZA_ICONS_AUTO 1

# -------------------------------------
#  Command not found handler with pacman → paru fallback
# -------------------------------------
function fish_command_not_found
    set_color red --bold
    echo "⚠ Command '$argv[1]' not found"
    set_color normal
    
    # First, try pkgfile to find which package provides this binary
    if command -v pkgfile >/dev/null 2>&1
        set providers (pkgfile -b -v $argv[1] 2>/dev/null)
        
        if test -n "$providers"
            set_color green
            echo -e "\n✓ Available in these packages:"
            set_color normal
            for provider in $providers
                set pkg (echo $provider | awk '{print $1}')
                set repo (echo $provider | awk '{print $2}')
                set_color cyan
                echo -n "  • "
                set_color yellow
                echo -n "$pkg "
                set_color brblack  # Changed from dim
                echo "($repo)"
                set_color normal
            end
            
            set first_pkg (echo $providers[1] | awk '{print $1}')
            set_color green --bold
            echo -e "\n→ sudo pacman -S $first_pkg"
            set_color normal
            return
        end
    end
    
    # If pkgfile didn't find it, search official repos with pacman
    set_color yellow
    echo -e "\nSearching CachyOS/official repos..."
    set_color normal
    
    set official_results (pacman -Ssq "^$argv[1]\$" 2>/dev/null)
    if test -n "$official_results"
        set_color cyan
        echo "Found in official repos:"
        set_color normal
        for pkg in $official_results
            echo "  • $pkg"
        end
        set_color green --bold
        echo -e "\n→ sudo pacman -S $official_results[1]"
        set_color normal
        return
    end
    
    # If not in official repos, try fuzzy search
    set fuzzy_results (pacman -Ssq $argv[1] 2>/dev/null | head -n 5)
    if test -n "$fuzzy_results"
        set_color cyan
        echo "Similar packages in official repos:"
        set_color normal
        for pkg in $fuzzy_results
            echo "  • $pkg"
        end
    end
    
    # Finally, check AUR with paru
    if command -v paru >/dev/null 2>&1
        set_color yellow
        echo -e "\nSearching AUR..."
        set_color normal
        
        set aur_results (paru -Ssq "^$argv[1]\$" 2>/dev/null)
        if test -n "$aur_results"
            set_color magenta
            echo "Found in AUR:"
            set_color normal
            for pkg in $aur_results
                echo "  • $pkg"
            end
            set_color magenta --bold
            echo -e "\n→ paru -S $aur_results[1]"
            set_color normal
            return
        end
        
        # AUR fuzzy search as last resort
        set aur_fuzzy (paru -Ssq $argv[1] 2>/dev/null | head -n 5)
        if test -n "$aur_fuzzy"
            set_color magenta
            echo "Similar packages in AUR:"
            set_color normal
            for pkg in $aur_fuzzy
                echo "  • $pkg"
            end
        end
    end
    
    # If nothing found anywhere
    if test -z "$official_results" -a -z "$fuzzy_results" -a -z "$aur_results" -a -z "$aur_fuzzy"
        set_color red
        echo -e "\nNo packages found matching '$argv[1]'"
        set_color brblack  # Changed from dim
        echo "Double-check the command name or try a web search"
        set_color normal
    end
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
#    <1s   -> ms (2 decimals max, e.g., 1.23ms)
#    <60s  -> s  (2 decimals max, e.g., 1.02s)
#    >=60s -> m  (2 decimals max, e.g., 1.03m)
# -------------------------------------
function fish_postexec --on-event fish_postexec
    if not set -q __fish_command_start_time
        set -g __fish_command_duration "0ms"
        return
    end

    set current_time (date +%s%N)
    set duration_ns (math "$current_time - $__fish_command_start_time")
    set duration_s (math -s 6 "$duration_ns / 1000000000")

    # Determine unit and value
    if test $duration_s -lt 1
        set value (math -s 2 "$duration_ns / 1000000")
        set unit "ms"
    else if test $duration_s -lt 60
        set value (math -s 2 "$duration_s")
        set unit "s"
    else
        set value (math -s 2 "$duration_s / 60")
        set unit "m"
    end

    # Remove trailing zeros and unnecessary dot
    set formatted $value
    set formatted (string replace -r '\.0+$' '' $formatted)          # Remove ".0" at the end
    set formatted (string replace -r '(\.\d*?)0+$' '$1' $formatted) # Remove trailing zeros after decimal

    set -g __fish_command_duration "$formatted$unit"
end
