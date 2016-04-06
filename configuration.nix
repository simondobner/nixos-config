# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.checkJournalingFS = false;

  networking.hostName = "dev"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  nix = {
    nixPath = [ "/home/lazar/dev" "nixos-config=/etc/nixos/configuration.nix" ];
    binaryCaches = [ https://cache.nixos.org http://hydra.cryp.to ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hydra.cryp.to-1:8g6Hxvnp/O//5Q1bjjMTd5RO8ztTsG8DKPOAg9ANr2g="
    ];
  };

  nixpkgs.config = {
      allowUnfree = true;

      firefox = {
          enableAdobeFlash = true;
      };

      packageOverrides = pkgs: rec {
          firefox-unwrapped = pkgs.firefox-unwrapped.override {
              enableGTK3 = true;
          };
      };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
     file
     wget
     git
     gitAndTools.hub
     vim_configurable
     gnumake
     python3
     graphviz
     xsel
     firefox
     nix-repl
     cabal-install
     cabal2nix
     nix-prefetch-scripts
     openjdk
     eclipses.eclipse-ee
     haskellPackages.xmonad
     haskellPackages.xmonad-contrib
     haskellPackages.xmonad-extras
     dmenu
     maven
     ctags
   ];

   fonts = {
       enableFontDir = true;
       enableGhostscriptFonts = true;
       fonts = with pkgs; [
           corefonts
           inconsolata
           ubuntu_font_family
           unifont
       ];
   };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.locate.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql95;
  services.postgresql.authentication =
      ''
        local all all ident
        host all all 127.0.0.1/32 md5
      '';

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  users.extraUsers.lazar = {
    isNormalUser = true;
    home = "/home/lazar";
    description = "Lazar Bodor";
    extraGroups = [ "wheel" ];
  };
  

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

}
