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
  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.checkJournalingFS = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "ga";
  networking.proxy.default = "http://sun-web-intdev.ga.gov.au:2710";
  #wireless
  #networking.proxy.default = "http://proxy.inno.lan:3128";

  time.timeZone = "Australia/Canberra";

  nixpkgs.config = import ../../config.nix;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    systemToolsEnv
    javaEnv
    pythonEnv
  ];

  # List services that you want to enable:

  services.openssh.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.postgresql = import ../../postgres/postgres-service.nix pkgs;

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
  system.autoUpgrade.enable = true;
}
