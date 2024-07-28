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
    networkmanager.enable = false;
    firewall.enable = false;
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
      displayManager.gdm.enable = false;
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
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  programs = {
    zsh = {
      enable = true;
    };
    sway = {
      enable = false;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  raspberry-pi-nix = {
    board = "bcm2712";
    uboot = true;
  };
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
          options = {
            # The firmware will start our u-boot binary rather than a
            # linux kernel.
            arm_64bit = {
              enable = true;
              value = true;
            };
            enable_uart = {
              enable = true;
              value = true;
            };
            avoid_warnings = {
              enable = true;
              value = true;
            };
            camera_auto_detect = {
              enable = true;
              value = true;
            };
            display_auto_detect = {
              enable = true;
              value = true;
            };
            disable_overscan = {
              enable = true;
              value = true;
            };
          };
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
            vc4-kms-v3d = {
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
