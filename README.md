# instant.d

Instantly apply the `config.d/*` standard to any software with a config file.

You see it in `/etc/nginx/config.d/`, in `/etc/apt/sources.list.d/`, `/etc/sudoers.d/`, and any number of other places, but what about the applications that don't support including all files in a given directory? Enter, instant.d.

```bash
$ instant.d ~/.ssh/config.d ~/.ssh/config
>>>  Backing up ~/.ssh/config to ~/.ssh/config.old
>>>  Generating ~/.ssh/config from ~/.ssh/config.d/*
$
```

## Requirements

- Bourne Again SHell (BASH) from sometime in the past 2 decades
- `find` (default provided with macOS and any GNU/Linux will work)
- `sort` (default provided with macOS and any GNU/Linux will work)

## Config Order

Each file in your `config.d`-style directory (we'll just call it `config.d` for simplicity) will be concatenated into the target config file. Nothing special. Each config file will be appended in this order:

- `config.d/pre/*` (alphabetical order by filename)
- `config.d/*` (alphabetical order by filename)
- `config.d/post/*` (alphabetical order by filename)

If the `pre/` or `post/` subdirectories do not exist, they will be skipped respectively.

## Install

Clone the repository and run `make install`. That's it. There is no uninstaller.

It will always install to `/usr/local/share/instant.d` and `/usr/local/bin/instant.d` unless you specify a different prefix besides `/usr/local`.
