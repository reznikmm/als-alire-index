# als-alire-index

> An Alire index to build ada_language_server, lsif-ada

This alire index provides the `ada_language_server`,
`lsif_ada` crates
and dependenties not included in the community index yet.

## Install

```
alr index --reset-community
alr index --add git+https://github.com/reznikmm/als-alire-index.git --name als
# Choose gnat_native=12.2
alr toolchain --select
alr get ada_language_server
cd ada_language_server*
# Temporary an Alire issue workaround:
git -C alire/cache/dependencies/vss*/ checkout config/vss_config.gpr
# export LIBRARY_TYPE=static
# On Mac OS X you should disable SAL (Standalone Libraries):
# export STANDALONE=no
# sed -i -e "/for Library_Interface use /s/^/--/" alire/cache/dependencies/langkit_support*/langkit/support/langkit_support.gpr
# sed -i -e "/for Interfaces use /s/^/--/" alire/cache/dependencies/libadalang*/build/libadalang.gpr

alr build -- -gnatwn
```

After a successful build you will get `ada_language_server` executable:

```
# ls -l ada_language_server_23.0.*/.obj/server/ada_language_server 
-rwxr-xr-x 1 root root 114655496 Nov  9 11:47 ada_language_server_23.0.1_7cc30d32/.obj/server/ada_language_server
```

### Dependencies

Make sure you have [`alr`](https://alire.ada.dev/), `wget`, `curl`, `git`, `libgmp-dev`, `python3`, `python3-venv`, `python3-pip`. On Ubuntu run:

```
apt install wget curl git libgmp-dev python3 python3-venv python3-pip
```

## GCC 13.1 preview

You can install `gnat_native` of GCC 13.1 with the next commant:

    alr toolchain --select gnat_native=13.1.1

## One line installer for `lsif-ada`

This script builds [`lsif-ada`](https://github.com/AdaCore/lsif-ada) 
and installs it into the current directory.
It supposes next packages are already installed:

    sudo apt install -y \
      python3 curl unzip git libgmp-dev libc6-dev make python3-pip python3-venv

    curl -fsSL https://raw.githubusercontent.com/reznikmm/als-alire-index/main/make_lsif.sh | bash

## Package VSCode extension to `.vsix`

You need NodeJS 16. On Ubuntu install it this way:
```
apt install gcc g++ make
curl -fsSL https://deb.nodesource.com/setup_16.x | bash - &&\
apt-get install -y nodejs
```

You may want to change version (or CPU for AArch64) in the `package.json`:

    sed -i -e s/x64/arm64/ -e s/23.0.999/23.0.18/ integration/vscode/ada/package.json

You should have a copy of `ada_language_server` in `integration/vscode/ada/{linux,darwin,win32}/`.
You need `vsce` and `esbuild`:
```
npm install -g @vscode/vsce
npm install -g esbuild
```

Then you could do:
```
cd integration/vscode/ada
npm install
vsce package
```

## Build on Mac OS X

You need [Python 3.8](https://www.python.org/downloads/macos/) or newer. Install and append it to `PATH` environment variable.

You need a GNAT compiler GCC 12 or newer.

You also need `wget` for `alr`. If you don't have `wget` this simple `curl` wrapper should work:
```
cat > bin/wget <<\EOF
#!/bin/bash

for J in "$@"; do
   case "$J" in
    "-O") echo "-o"     ;;
    *)    echo \'"$J"\' ;;
   esac
done | xargs -L 100 curl
EOF

chmod +x bin/wget
```

The `alr` complains on absent `libgmp`, so you need to find this library somewhere. For instance "GNAT CE 2021" distribution has its-own copy of `libgmp` in `opt/gnat-ce-2021/lib/` directory. Set `LIBRARY_PATH` environment to point to a directory with `libgmp`.
 After the build fix RPATH to the `libgmp.10.dylib`:

```
function fix_rpath ()
{
    for R in `otool -l $1 |grep -A2 LC_RPATH |awk '/ path /{ print $2 }'`; do
        install_name_tool -delete_rpath $R $1
    done
    install_name_tool -change /opt/gnat-ce-2021/lib/libgmp.10.dylib @executable_path/libgmp.10.dylib $1
}

fix_rpath ada_language_server_*/.obj/server/ada_language_server

cp $HOME/opt/gnat-ce-2021/lib/libgmp.10.dylib ada_language_server_*/.obj/server/
```

## Maintainer

[Max Reznik](https://github.com/reznikmm).

## Contribute

Feel free to dive in!
[Open an issue](https://github.com/reznikmm/als-alire-index/issues/new)
or submit PRs.

## License

[GPL-3](LICENSE) © Max Reznik

