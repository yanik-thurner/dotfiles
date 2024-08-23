Add the following snippet to `.bashrc` to include this folder:

```bash
# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*.sh; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
unset rc
```
