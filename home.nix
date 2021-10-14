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

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    monoid
    curl tree git wget which htop file ntfs3g woeusb gnumake gcc binutils bc bind usbutils dmidecode arandr autocutsel
    ripgrep-all fd sd procs bandwhich
    #signal-desktop # currently using flatpak cause broken on sway/wayland
    vlc
    #chromium # slow to build
    pcmanfm xournalpp zathura
    libreoffice
    docker-compose
    cmst pavucontrol
    libsForQt5.ark
    yubikey-personalization yubikey-manager-qt
    texlive.combined.scheme-full kile
    #scrcpy
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
        #gpg-connect-agent /bye
        #export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

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
      prezto = {
        enable = true;
        tmux.autoStartLocal = true;
        prompt.theme = "walters";
      };
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

    jq.enable = true;
    ssh.enable = true;
    firefox.enable = true;
    bat.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
    autorandr = {
      enable = false;
      profiles = {
        "x1e3-docked" = {
          fingerprint = {
            eDP-1-1 = "00ffffffffffff000e6f001500000000001d0104b52213780317ecaa5138b2251150550000000101010101010101010101010101010140ce00a0f07028803020350058c210000018000000000000000000000000000000000018000000fe0043534f542054330a2020202020000000fe004d4e463630314541312d310a20014702030f00e3058000e6060501737321000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008b";
            HDMI-0 = "00ffffffffffff0006b351358f290100191c010380522378ea62f5aa524ca3260f5054bfcf00d1c0b30095008180814081c0714f0101e77c70a0d0a0295030203a00335a3100001a000000fd001e4b1e5921000a202020202020000000fc00415355532058473335560a2020000000ff004a364c4d54463037363137350a01bb020322f14f010304131f120211900f0e1d1e0514230907078301000065030c002000e77c70a0d0a0295030203a00335a3100001a9d6770a0d0a0225050205a04335a3100001e9f3d70a0d0a0155030203a00335a3100001e023a801871382d40582c4500335a3100001e000000000000000000000000000000000000000000d3";
          };
          config = {
            eDP-1-1.enable = false;
            HDMI-0 = {
              enable = true;
              primary = true;
              mode = "3440x1440";
              transform = [
                [2.000000 0.000000 0.000000]
                [0.000000 2.000000 0.000000]
                [0.000000 0.000000 1.000000]
              ];
            };
          };
          hooks.preswitch = "xrandr --output eDP-1-1 --off";
        };
        "default" = {
          fingerprint = {
            eDP-1-1 = "00ffffffffffff000e6f001500000000001d0104b52213780317ecaa5138b2251150550000000101010101010101010101010101010140ce00a0f07028803020350058c210000018000000000000000000000000000000000018000000fe0043534f542054330a2020202020000000fe004d4e463630314541312d310a20014702030f00e3058000e6060501737321000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008b";
          };
          config = {
            eDP-1-1 = {
              enable = true;
              primary = true;
              mode = "3840x2160";
            };
          };
        };
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "gtk2";
    };
    caffeine.enable = true;
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
