# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Networking
  networking = {
    hostName = "alaska";
    networkmanager.enable = true;
    firewall.enable = true;
    wireless.enable = false;
    enableIPv6 = false;
  };

  # Network Share
  fileSystems."/mnt/Idaho" = {
  device = "//192.168.80.51/Idaho";
  fsType = "cifs";
  options = let
    # this line prevents hanging on network split
    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

  in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
  };
  
  # Enable DCONF
  programs.dconf.enable = true;

  # Audio, this is enough to get audio working on most laptops/desktops
  hardware.pulseaudio.enable = true;

  # Audio fix https://major.io/p/stop-audio-pops-on-intel-hd-audio/
  # Custom kernel module -> https://nixos.wiki/wiki/Linux_kernel
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0
  '';

  # Thunar file manager
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  # Thumbnails?
  services.tumbler.enable = true;

  # Virtualbox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "brian" ];  
  
  # Window Manager i3
  environment.pathsToLink = [ "/libexec" ];
  services.displayManager.defaultSession = "none+i3";
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu # launcher for i3
        i3lock # screen locker
        i3status # status information
        xautolock # automatic screen lock
        i3blocks # status bar
        pavucontrol # sound
        maim # screenshot app for i3 config
        xclip # copy screenshot to clipboard
        xdotool # screenshot, select window
     ];
    };
  };

  # Enable OpenGL, part of Nvidia setup
  hardware.opengl = {
    enable = true;
  };
  
  # Nvidia Drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  # More NVIDIA Settings
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brian = {
    isNormalUser = true;
    description = "Brian";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    git # required for flakes
    vim # nano is only installed default
    tmux # terminal multiplexer magic
    cifs-utils # for file shares
  ];

  # Editor VIM
  environment.variables.EDITOR = "vim";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
