{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration-x1.nix
    ];

  hardware.bluetooth.enable = false;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.checkJournalingFS = false;

  virtualisation.docker.enable = true;

  networking = {
    hostName = "dev";
    wireless.enable = true;
  };

  time.timeZone = "Australia/Sydney";

  nix = {
    nixPath = [ "/home/lbodor/dev" "nixos-config=/etc/nixos/configuration.nix" ];
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

  # Set SSL_CERT_FILE, so that nix-shell doesn't make it up.
  # See https://github.com/NixOS/nixpkgs/issues/13744.
  environment.variables."SSL_CERT_FILE" = "/etc/ssl/certs/ca-bundle.crt";

  environment.systemPackages = with pkgs; [
     xorg.xbacklight
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
     haskellPackages.X11
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

  programs.ssh.startAgent = true;

  services.upower.enable = true;
  services.locate.enable = true;

  services.acpid.enable = true;

  services.xserver = {
    enable = true;
    synaptics.enable = true;
    synaptics.palmDetect = true;
    synaptics.twoFingerScroll = true;
    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
  };

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

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.extraUsers.lbodor = {
    uid = 1000;
    isNormalUser = true;
    home = "/home/lbodor";
    description = "Lazar Bodor";
    extraGroups = [ "docker" "wheel" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";
}
