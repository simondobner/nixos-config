# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration-ga-vbox.nix
    ];

  # Use the GRUB 2 boot loader.
  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.checkJournalingFS = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "ga";
  networking.proxy.default = "http://sun-web-intdev.ga.gov.au:2710";

  time.timeZone = "Australia/Canberra";

  nixpkgs.config = {
    packageOverrides = pkgs: {
      eclipse-ee-452 = pkgs.eclipses.buildEclipse {
        name = "eclipse-ee-4.5.2";
        description = "Eclipse EE IDE";
        sources = {
          "x86_64-linux" = pkgs.fetchurl {
            url = http://download.eclipse.org/technology/epp/downloads/release/mars/2/eclipse-jee-mars-2-linux-gtk-x86_64.tar.gz;
            sha256 = "0fp2933qs9c7drz98imzis9knyyyi7r8chhvg6zxr7975c6lcmai";
          };
        };
      };
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    (import ./common-packages.nix pkgs) ++ [
    firefox
    eclipse-ee-452
    git
    vim
    wget
    tmux
  ];

  # List services that you want to enable:

  services.openssh.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.postgresql = import ./postgres/postgres-service.nix pkgs;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.lbodor = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "wheel" ];
   };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
