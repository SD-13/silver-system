{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    # ./nvidia.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "birch-nixos";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${config.system.username} = {
    isNormalUser = true;
    description = config.system.userFullname;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  systemd.services.bar = {
    description = "Disable i8042 input";
    wantedBy = [ "multi-user.target" ];
    script = ''
      echo 1 | tee /sys/devices/platform/i8042/serio0/input/input0/inhibited
    '';
    path = [ pkgs.coreutils pkgs.gnugrep ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # https://nixos.wiki/wiki/Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Show battery charge of Bluetooth devices
        Experimental = true;
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
