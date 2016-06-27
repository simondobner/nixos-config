{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql94;
    extraPlugins = [ (pkgs.postgis.override { postgresql = pkgs.postgresql94; }).v_2_1_4 ];
    authentication =
      ''
        local all root ident
        local all postgres ident
        local all all md5
        host all all 127.0.0.1/32 md5
      '';
    # If you want nixos to re-run the initial script, touch /var/db/postgres/.first_startup
    initialScript = ./postgres-initial-script.sql;
  };
}
