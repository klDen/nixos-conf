{ pkgs, inputs, system, ... }:
let
in
rec {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "klden";
  home.homeDirectory = "/home/klden";

  home.packages = with pkgs; [
    procs # no more: ps -ef | grep 
    curl tree git wget which htop file ntfs3g woeusb gnumake gcc binutils bc bind usbutils dmidecode arandr autocutsel
    ripgrep-all fd sd procs bandwhich
    signal-desktop
  ];

  programs = {
    git = {
      enable = true;
      userName = "Kenzyme Le";
      userEmail = "kl@kenzymele.com";
      ignores = [ "*~" "*.swp" ];
      extraConfig = {
        init.defaultBranch = "master";
        credential.helper = "store --file ~/.git-credentials";
      };
    };

    tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      newSession = true;
      # Stop tmux+escape craziness.
      escapeTime = 0;
      # Force tmux to use /tmp for sockets (WSL2 compat)
      secureSocket = false;

      extraConfig = ''
        # Mouse works as expected
        set-option -g mouse on
        # easy-to-remember split pane commands
        bind h split-window -h -c "#{pane_current_path}"
        bind v split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
      '';
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      shellAliases = {
        cat="bat";
        grep="rga";
      };
      sessionVariables = {
        EDITOR="vim";
        VISUAL="vim";
        BROWSER="firefox";
      };
      initExtra = ''
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

        if [[ $DISPLAY ]]; then
          # If not running interactively, don't do anything
          [[ $- != *i* ]] && return
       
          if [[ -z "$TMUX" ]] ;then
            ID="$( tmux ls | grep -vm1 attached | cut -d: -f1 )" # get the id of a deattached session
              # prevent starting TMUX in Jetbrain's Terminal
              if [[ "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" ]] ; then
                  ZSH_TMUX_AUTOSTART=false;
            elif [[ -z "$ID" ]] ;then # if not available create a new one
            	tmux new-session
            else
            	tmux attach-session -t "$ID" # if available attach to it
            fi
          fi
        fi
      '';
      prezto.enable = true;
      prezto.tmux.autoStartLocal = true;
      prezto.prompt.theme = "walters";
    };

    vim = {
      enable = true;
      extraConfig = ''
        set hlsearch
        set autoindent
        set smartindent
        set ruler
        set shiftwidth=4
        set softtabstop=4
        set expandtab
        set clipboard+=unnamedplus  " use the clipboards of vim and win
        set paste               " Paste from a windows or from vim
        set go+=a               " Visual selection automatically copied to the clipboardet nostartofline
        set nu
        set ignorecase
        set smartcase
        set incsearch
	set backspace=indent,eol,start
        color desert
        syntax on
      '';
    };

    autorandr = {
      enable = true;
      profiles = {
        "x1e3-docked" = {
          fingerprint = {
            eDP-1-1 = "00ffffffffffff000e6f001500000000001d0104b52213780317ecaa5138b2251150550000000101010101010101010101010101010140ce00a0f07028803020350058c210000018000000000000000000000000000000000018000000fe0043534f542054330a2020202020000000fe004d4e463630314541312d310a20014702030f00e3058000e6060501737321000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008b";
            DP-0 = "00ffffffffffff0006b351358f290100191c010380522378ea62f5aa524ca3260f5054bfcf00d1c0b30095008180814081c0714f0101e77c70a0d0a0295030203a00335a3100001a000000fd001e4b1e5921000a202020202020000000fc00415355532058473335560a2020000000ff004a364c4d54463037363137350a01bb020322f14f010304131f120211900f0e1d1e0514230907078301000065030c002000e77c70a0d0a0295030203a00335a3100001a9d6770a0d0a0225050205a04335a3100001e9f3d70a0d0a0155030203a00335a3100001e023a801871382d40582c4500335a3100001e000000000000000000000000000000000000000000d3";
          };
          config = {
            eDP-1-1.enable = false;
            DP-0 = {
              enable = true;
              primary = true;
              position = "0x0";
              mode = "3440x1440";
              rate = "59.97";
            };
          };
          #hooks.postswitch = "xrandr --output DP-0 --scale 2x2";
        };
        "x1e3-undocked" = {
          fingerprint = {
            eDP-1-1 = "00ffffffffffff000e6f001500000000001d0104b52213780317ecaa5138b2251150550000000101010101010101010101010101010140ce00a0f07028803020350058c210000018000000000000000000000000000000000018000000fe0043534f542054330a2020202020000000fe004d4e463630314541312d310a20014702030f00e3058000e6060501737321000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008b";
          };
          config = {
            eDP-1-1 = {
              enable = true;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              #mode = "3840x2160";
              rate = "60";
            };
          };
        };
      };
    };

    urxvt = {
      enable = true;
      extraConfig = {
        scrollBar= false;
        background= "black";
        foreground= "white";
        boldFont="";
        color3=           "DarkGoldenrod";
        color4=           "RoyalBlue";
        color11=          "LightGoldenrod";
        color12=          "LightSteelBlue";
        color7=           "gray75";
        colorBD=          "#ffffff";
        colorUL=          "LightSlateGrey";
        colorIT=          "SteelBlue";
        cursorColor=      "grey90";
        highlightColor=   "grey25";
        iso14755= false;
        iso14755_52= false;
        font= "xft:monoid:size=15";
        letterSpace= -2;
        perl-ext-common= "clipboard,selection-to-clipboard";
      };
    };

    jq.enable = true;
    ssh.enable = true;
    firefox.enable = true;
    bat.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
  };

  services = {
    xidlehook = {
      enable = true;
      not-when-audio = true;
      not-when-fullscreen = true;
      timers = [
        {
          delay = 120;
          command = "${pkgs.redshift}/bin/redshift -o -l 45.53:-73.59 -b 0.1:0.1";
          canceller = "${pkgs.redshift}/bin/redshift -o -l 45.53:-73.59 -b 1:1";
        }
        {
          delay = 10;
          command = "${pkgs.redshift}/bin/redshift -o -l 45.53:-73.59 -b 1:1; ${pkgs.i3lock-fancy}/bin/i3lock-fancy -gp -- ${pkgs.scrot}/bin/scrot -z -o";
        }
        {
          delay = 3600;
          command = "systemctl suspend";
        }
      ];
    };

    caffeine.enable = true;
    flameshot.enable = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
