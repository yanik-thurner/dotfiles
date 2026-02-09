# ═══════════════════════════════════════════════════════════════════════════════
# Fish Shell Greeting: Minimal Sparkles ✨ by Claude
# ═══════════════════════════════════════════════════════════════════════════════

function fish_greeting
    # Pastel colors
    set -l c1 (set_color -o 89b4fa)  # blue
    set -l c2 (set_color -o f5c2e7)  # pink
    set -l c3 (set_color -o a6e3a1)  # green
    set -l c4 (set_color -o f9e2af)  # yellow
    set -l c5 (set_color -o cba6f7)  # lavender
    set -l c6 (set_color -o 94e2d5)  # teal
    set -l dim (set_color -o 6c7086) # dim
    set -l reset (set_color normal)

    # System info
    set -l user (whoami)
    set -l host (hostname -s 2>/dev/null; or hostname)
    set -l date_str (date "+%a %b %d, %Y · %H:%M")
    set -l distro (grep "^PRETTY_NAME=" /etc/os-release 2>/dev/null | cut -d'"' -f2; or echo "Unknown")
    set -l kernel (uname -r)

    # Get list of interfaces with IPs (excluding lo)
    set -l interfaces (ip -o addr show 2>/dev/null | awk '{print $2}' | grep -v '^lo$' | sort -u)

    echo ""
    echo "  $c4✦$reset $c1$user$reset$dim@$reset$c2$host$reset $c4✦$reset"
    echo ""
    echo "  $dim┌─$reset $c3♡$reset $dim date    $reset$date_str"
    echo "  $dim│ $reset $c1♡$reset $dim distro  $reset$distro"
    echo "  $dim│ $reset $c5♡$reset $dim kernel  $reset$kernel"

    # Collect interfaces that have addresses
    set -l active_ifaces
    for iface in $interfaces
        set -l v4 (ip -4 addr show $iface 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}/\d+' | grep -v '^127\.')
        set -l v6 (ip -6 addr show $iface 2>/dev/null | grep -v 'temporary' | grep -v 'fe80::' | grep -oP '(?<=inet6\s)[0-9a-f:]+/\d+' | grep -v '^::1')
        if test -n "$v4" -o -n "$v6"
            set -a active_ifaces $iface
        end
    end

    set -l iface_count (count $active_ifaces)

    if test $iface_count -eq 0
        echo "  $dim└─$reset $c2♡$reset $dim network $reset$dim""offline$reset"
    else
        set -l iface_idx 0
        for iface in $active_ifaces
            set iface_idx (math $iface_idx + 1)
            set -l is_last (test $iface_idx -eq $iface_count; and echo 1; or echo 0)

            # Get IPv4 for this interface
            set -l v4 (ip -4 addr show $iface 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}/\d+' | grep -v '^127\.')
            # Get IPv6 for this interface: exclude link-local (fe80::) and temporary
            set -l v6 (ip -6 addr show $iface 2>/dev/null | grep -v 'temporary' | grep -v 'fe80::' | grep -oP '(?<=inet6\s)[0-9a-f:]+/\d+' | grep -v '^::1')

            # Print interface header (aligned with date/distro/kernel)
            if test $is_last -eq 1
                echo "  $dim└─$reset $c2♡$reset $c4 $iface$reset"
            else
                echo "  $dim│ $reset $c2♡$reset $c4 $iface$reset"
            end

            # Print IPv4 addresses (indented under interface)
            for addr in $v4
                if test $is_last -eq 1
                    echo "         $c3$addr$reset"
                else
                    echo "  $dim│$reset      $c3$addr$reset"
                end
            end

            # Print IPv6 addresses (indented under interface)
            for addr in $v6
                if test $is_last -eq 1
                    echo "         $c6$addr$reset"
                else
                    echo "  $dim│$reset      $c6$addr$reset"
                end
            end
        end
    end

    echo ""
end
