{
  allowUnfree = true;

  packageOverrides = super: let self = super.pkgs; in with self; rec {
    firefox = {
        enableAdobeFlash = true;
    };

    firefox-unwrapped = super.firefox-unwrapped.override {
        enableGTK3 = true;
    };

    squirrelsql = super.callPackage ./packages/squirrelsql {};

    systemToolsEnv = with super; buildEnv {
      name = "systemToolsEnv";
      paths = [
        ctags
        file
        firefox
        gcc
        git
        gitAndTools.hub
        gnumake
        keychain
        nix-prefetch-scripts
        nix-repl
        nload
        telnet
        tmux
        tree
        unzip
        vim_configurable
        wget
        which
        zip
      ];
    };

    javaEnv = with super; buildEnv {
      name = "javaEnv";
      paths = [
        openjdk
        maven
      ];
    };

    pythonEnv = with super; buildEnv {
      name = "pythonEnv";
      paths = [
        python3
      ];
    };
  };
}
