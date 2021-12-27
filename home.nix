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
    curl tree git wget which htop file ntfs3g woeusb gnumake gcc binutils bc bind usbutils dmidecode
    ripgrep-all fd sd procs bandwhich lsof
    vlc
    chromium # slow to build
    pcmanfm xournalpp zathura libsForQt5.ark
    libreoffice
    cmst pavucontrol
    yubikey-personalization yubikey-manager-qt
    texlive.combined.scheme-full kile
    pciutils
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
        # make sec ENVS available to all my terms
        source $HOME/.zshenv.sec 2>/dev/null || true
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
    bat.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
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

