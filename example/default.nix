{
  pkgs,
  lib,
  ...
}: {
  time.timeZone = "America/Bahia";
  users.users = {
    root = {
      initialPassword = "root";
    };
    sonja = {
      isNormalUser = true;
      description = "sonja";
      initialPassword = "123456";
      shell = pkgs.zsh;
      extraGroups = ["networkmanager" "wheel" "input" "docker" "kvm" "libvirtd"];
    };
  };

  networking = {
    hostName = "example";
    interfaces = {
      wlan0.useDHCP = true;
      eth0.useDHCP = true;
    };
    networkmanager.enable = true;
    firewall.enable = true;
    enableIPv6 = false;
    # no need to wait interfaces to have an IP to continue booting
    dhcpcd.wait = "background";
    # avoid checking if IP is already taken to boot a few seconds faster
    dhcpcd.extraConfig = "noarp";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
      http-connections = 50;
      warn-dirty = false;
      log-lines = 50;
      sandbox = "relaxed";
      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  programs = {
    zsh = {
      enable = true;
    };
    sway = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  raspberry-pi-nix.board = "bcm2712";
  hardware = {
    raspberry-pi = {
      config = {
        pi5 = {
          dt-overlays = {
            vc4-kms-v3d-pi5 = {
              enable = true;
              params = {};
            };
          };
        };
        all = {
          base-dt-params = {
            BOOT_UART = {
              value = 1;
              enable = true;
            };
            uart_2ndstage = {
              value = 1;
              enable = true;
            };
          };
          dt-overlays = {
            disable-bt = {
              enable = true;
              params = {};
            };
          };
        };
      };
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  console = {keyMap = "br-abnt2";};

  i18n = {
    defaultLocale = "pt_BR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };
}
