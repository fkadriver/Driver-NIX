# Grab config, pkgs, lib, and all the other inputs on the way in
{ config, pkgs, lib, flakeInputBundle, hostName, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      ../../modules/myZFS
#      ../../modules/headset
#      ../../modules/samsung-printer
      
      # Here we're using the package of all inputs from the flake to find the nixos-hardware input, and get the modules from there
      # NixOS modules for AMD processors
#      flakeInputBundle.nixos-hardware.nixosModules.common-cpu-amd-zenpower
#      flakeInputBundle.nixos-hardware.nixosModules.common-cpu-amd-pstate
#      flakeInputBundle.nixos-hardware.nixosModules.common-cpu-amd
          
      ../../modules/syncthing

 #     ../../modules/world-of-warcraft

      # ../../modules/android-flashing
    ];

  hardware.keyboard.zsa.enable = true;

  networking = {
    hostName = latitude-nixos;
    networkmanager.enable = true;
  };
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.  Override the default of UTC in configuration.nix
  time.timeZone = lib.mkForce "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the KDE Plasma Desktop Environment with Wayland
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users= {
    users.scott = {
      extraGroups = [ "networkmanager" "media" ];
      # packages = with pkgs; [ ];
    };
    # For Jellyfin, etc
#    groups.media = {
#      gid = 125;
#    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    glib #an undeclared soft-dependancy for PSD
    discord
#    signal-desktop-bin
#    logseq
    sops
    vscode
#    yubioath-flutter
#    wally-cli
    kdePackages.kcalc
    kdePackages.konqueror
    kdePackages.filelight
    kdePackages.kcharselect
    kdePackages.kolourpaint
    kdePackages.kate
    #kdePackages.kdeconnect-kde  #programs.kdeconnect.enable=true instead.
    #microsoft-edge
    chromium
    lynx
    firefox
    vorta
#    virt-viewer  #for SPICE consoles from Proxmox
#    amdgpu_top
    libreoffice-qt
    hunspell
    hunspellDicts.en-ca-large
    hunspellDicts.fr-moderne
    mumble
    element-desktop
    calibre
    cameractrls-gtk4
    finamp
    supersonic
    vlc
    handbrake
    inkscape
    # Doing Android work?  Enable the Android-flashing module above
  ];

  fonts = {
    enableDefaultPackages = true;
    # Fix for Firefox not displaying noto-fonts-color-emoji on web pages
    fontconfig.useEmbeddedBitmaps = true;
    packages = with pkgs; [
      monaspace  # Fancy "self-healing" font family.  Is supposed to dynamically adjust even monospace characters for better spacing
      noto-fonts  # Focused on making sure there are no unknown glyphs anywhere
      noto-fonts-color-emoji  # Should add some emoji to places like https://docs.gitlab.com/ee/user/markdown.html#emoji
    ];
  };

  # Don't use environment.systemPackages.pkgs.steam; it didn't work.  This did.
#  programs.steam.enable = true;

  programs.kdeconnect.enable = true;

  programs.gnupg.agent.enable = true;
 # programs.yubikey-touch-detector.enable = true;
#  services.udev.packages = [pkgs.yubikey-personalization];
#  programs.partition-manager.enable = true;

  security.sudo.extraRules = [
    { users = [ "scott" ]; commands = [ { command = "${pkgs.profile-sync-daemon}/bin/psd-overlay-helper"; options = [ "NOPASSWD" ]; } ]; }
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Profile Sync Daemon for Firefox profile in RAM
  services.psd.enable = true;


  #QEMU guest services OFF, since this is a desktop
  services.spice-vdagentd.enable = false;
  services.qemuGuest.enable = false;

}
