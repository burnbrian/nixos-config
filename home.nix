{ config, pkgs, ... }:

{
  # Source: https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
  home.username = "brian";
  home.homeDirectory = "/home/brian";

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 18;
    "Xft.dpi" = 100;
  };

  # Packages
  home.packages = with pkgs; [
    # Utilities
    neofetch
    nnn
    zip
    xz
    unzip
    p7zip
    ripgrep
    jq
    yq-go
    eza
    fzf
    mtr
    iperf3
    dnsutils
    ldns
    socat
    nmap
    ipcalc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    nix-output-monitor
    btop
    iotop
    iftop
    strace
    ltrace
    lsof
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
    # Programs, breakout later
    wget
    curl
    vim
    tmux
    alacritty
    # Others
    vscode
    firefox
    obsidian
    signal-desktop
    discord
    bitwarden-desktop
    slack
    zoom-us
  ];

  # VSCode
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      github.copilot
      github.copilot-chat
      bbenoist.nix
      yzhang.markdown-all-in-one
      davidanson.vscode-markdownlint
      esbenp.prettier-vscode
      shd101wyy.markdown-preview-enhanced
    ];
  };

  # Dotfiles recursive
  # https://discourse.nixos.org/t/deploy-files-into-home-directory-with-home-manager/24018
  home.file."${config.xdg.configHome}" = {
    source = ./config;
    recursive = true;
  };

  # GitHub.com, git-crypt these?
  programs.git = {
    enable = true;
    userName = "burnbrian";
    userEmail = "98911252+burnbrian@users.noreply.github.com";
  };

  # Starship
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # Alacritty 
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  # Bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # Aliases
    shellAliases = {
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
