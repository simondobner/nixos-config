# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration-x1.nix
    ];

  hardware.bluetooth.enable = false;

  # boot.loader.gummiboot.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.device = "nodev";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.docker.enable = true;
  boot.initrd.checkJournalingFS = false;

  networking.hostName = "dev";
  networking.wireless.enable = true;

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
     haskellPackages.xmonad
     haskellPackages.xmonad-contrib
     haskellPackages.xmonad-extras
     dmenu
     maven
     ctags
     zip
     unzip
     tree
     which
     keychain
     telnet
     nload
     gcc
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

  # services.openssh.enable = true;
  # services.printing.enable = true;

  programs.ssh.startAgent = true;

  services.upower.enable = true;
  services.locate.enable = true;

  services.xserver.enable = true;
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.palmDetect = true;
  services.xserver.synaptics.twoFingerScroll = true;
  services.xserver.xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  # services.xserver.displayManager.kdm.enable = true;
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql95;
    extraPlugins = [ pkgs.postgis.v_2_2_1 ];
    authentication =
        ''
          local postgres all ident
          local all lazar ident
          local all all md5
          host all all 127.0.0.1/32 md5
        '';
  };

  users.extraUsers.lazar = {
    isNormalUser = true;
    home = "/home/lazar";
    description = "Lazar Bodor";
    extraGroups = [ "docker" "wheel" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";
}
