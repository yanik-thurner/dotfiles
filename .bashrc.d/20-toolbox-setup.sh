#/bin/bash

REQUESTED_PKGS=(fish neovim ripgrep fd-find tmux)

is_fedora=$(grep -qE "^Fedora" /etc/redhat-release 2>/dev/null && echo true || echo false)
in_toolbox=$([[ -f /run/.toolboxenv ]] && echo true || echo false)

if [[ "$is_fedora" == false || "$in_toolbox" == false ]]; then
	return
fi

missing=$(rpm -q "${REQUESTED_PKGS[@]}" 2>&1 | grep -c "not installed")

if [[ "$missing" -eq 0 ]]; then
	return
fi

echo "Installing basic tools..."
sudo dnf install "${REQUESTED_PKGS[@]}" --skip-unavailable --assumeyes &>/dev/null
echo "Finished!"
