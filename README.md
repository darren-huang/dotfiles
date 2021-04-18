# Personal Dotfiles

## WSL 2 (windows)
1 Follow this [guide](https://docs.microsoft.com/en-us/windows/wsl/install-win10) in order to install WSL 2.

2. go to the `windows_terminal_settings` and then copy over the necessary parts

3. install the `CascadiaCodePL.ttf` into windows

## Ubuntu Setup
1. git clone this repo to your home directory 

```git clone git@github.com:darren-huang/dotfiles.git```

2. then copy the files to your home directory via the script 

```./OVERWRITE_HOME.sh```

3. finally run the setup vim plug to install vim plugins (note this will freeze vim after a while, so just run `vim` to double check everything is installed properly) 

```./setup_vim_plug```
