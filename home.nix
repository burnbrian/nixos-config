{ config, pkgs, ... }:

{
  # Source: https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
  home.username = "brian";
  home.homeDirectory = "/home/brian";

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 24;
    "Xft.dpi" = 100;
  };

  # DCONF prefer dark
  dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita-dark";
        color-scheme = "prefer-dark";
      };
    };

  # GTK Adwaita Dark
  gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome.gnome-themes-extra;
      };
    };

  # QT Adwaita Dark
  qt = {
    enable = true;
    platformTheme.name = "gtk";
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
    xclip # for tmux yank
    gparted
    vlc
    remmina
    imagemagick
    lxappearance
    keepassxc
    libreoffice
    hashcat
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

  # Scripts
  home.file."${config.xdg.configHome}/scripts" = {
    source = ./config/scripts;
    recursive = true;
    executable = true;
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
    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519_sk.pub";
    };
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
      alaska = "cd $HOME/nixos-config && sudo nixos-rebuild switch --flake .#alaska";
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
