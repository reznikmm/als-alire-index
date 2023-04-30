# als-alire-index

> An Alire index to build ada_language_server, lsif-ada

This alire index provides the `ada_language_server`,
`lsif_ada` crates
and dependenties not included in the community index yet.

## Install

```
git clone https://github.com/reznikmm/als-alire-index.git
alr index --reset-community
alr index --add file://$PWD/als-alire-index --name als
# Choose gnat_native=12.2
alr toolchain --select
alr get ada_language_server
cd ada_language_server*
# export LIBRARY_TYPE=static
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

## Build on Mac OS X High Sierra

You need [Python 3.8](https://www.python.org/downloads/macos/) or newer. Install and append it to `PATH` environment variable.

You can use [GNAT CE 2021](https://github.com/simonjwright/distributing-gcc/releases/tag/gnat-ce-2021) to build ALS on Mac OS X older than Big Sur (11, Darwin 20).

```
curl -L -O https://github.com/simonjwright/distributing-gcc/releases/download/gnat-ce-2021/gnat-ce-2021-x86_64-apple-darwin15.pkg

installer -pkg gnat-ce-2021-x86_64-apple-darwin15.pkg  -target CurrentUserHomeDirectory

export PATH=$HOME/opt/gnat-ce-2021/bin:$PATH
```

Then you should uninstall conflicting packages:

```
for J in xmlada gnatcoll_iconv gpr langkit_support gnatcoll_gmp gnatcoll_sqlite2ada gnatcoll gnatcoll_syslog gnatcoll_sql aunit gnatcoll_python libadalang gnatcoll_xref gnatcoll_sqlite mains gnatcoll_readline
do
   gprinstall --uninstall $J
done
```

Install `alire`:
```
curl -L -O https://github.com/alire-project/alire/releases/download/v1.1.1/alr-1.1.1-bin-x86_64-macos.zip

unzip alr-1.1.1-bin-x86_64-macos.zip 

export PATH=$PWD/bin:$PATH
```

You also need `wget` for `xmlada` crate. If you don't have `wget` this simple `curl` wrapper should work:
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

After that `alr` should be able to build `ada_language_server`. The `alr` complains on absent `libgmp`, ignore it, because this "GNAT CE 2021" distribution has its-own copy of `libgmp` in `opt/gnat-ce-2021/lib/` directory.
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

