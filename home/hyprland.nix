{ config, pkgs, lib, ... }:

let
  wallpaper = "${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/backgrounds/nixos/nixos-wallpaper-simple-dark-gray.png";
in
{
  imports = [ ];

  home.packages = with pkgs; [
    waybar
    hyprpaper
    hyprlock
    rofi-wayland
    kitty
    wlogout
    brightnessctl
    pamixer
    wl-clipboard
  ];

  xdg.configFile = {
    "hypr/hyprland.conf".text = ''
      #####################
      ### Hyprland.conf ###
      #####################

      monitor = ,preferred,auto,1
      monitor = HDMI-A-1,1920x1080@60,0x0,1
      monitor = DP-1,1920x1080@60,1920x0,1

      exec-once = hyprpaper & waybar

      general {
        gaps_in = 6
        gaps_out = 12
        border_size = 2
        layout = dwindle
        col.active_border = rgba(5ac8faee)
        col.inactive_border = rgba(3a3a3aaa)
      }

      decoration {
        rounding = 8
        blur = yes
        blur_size = 4
        blur_passes = 2
      }

      animations {
        enabled = true
        animation = windows, 1, 7, default, popin
        animation = border, 1, 10, default
        animation = fade, 1, 10, default
      }

      input {
        kb_layout = us
        follow_mouse = 1
        sensitivity = 0
        touchpad {
          natural_scroll = true
          disable_while_typing = true
        }
      }

      bind = SUPER, Return, exec, kitty
      bind = SUPER, W, exec, firefox
      bind = SUPER, E, exec, codium
      bind = SUPER, Q, killactive,
      bind = SUPER, M, exit,
      bind = SUPER, D, exec, rofi -show drun
      bind = SUPER, SPACE, togglefloating,
      bind = SUPER, L, exec, hyprlock
      bind = SUPER, T, exec, wlogout

      # volume
      bind = ,XF86AudioRaiseVolume, exec, pamixer -i 5
      bind = ,XF86AudioLowerVolume, exec, pamixer -d 5
      bind = ,XF86AudioMute, exec, pamixer -t

      # brightness
      bind = ,XF86MonBrightnessUp, exec, brightnessctl s +5%
      bind = ,XF86MonBrightnessDown, exec, brightnessctl s 5%-

      workspace = 1, monitor:HDMI-A-1
      workspace = 2, monitor:DP-1
    '';

    "hypr/hyprpaper.conf".text = ''
      preload = ${wallpaper}
      wallpaper = HDMI-A-1,${wallpaper}
      wallpaper = DP-1,${wallpaper}
      wallpaper = eDP-1,${wallpaper}
    '';

    "waybar/config".text = ''
      {
        "layer": "top",
        "position": "top",
        "output": ["*"],
        "modules-left": ["workspaces", "window"],
        "modules-center": ["clock"],
        "modules-right": ["tray", "network", "bluetooth", "pulseaudio"],
        "clock": { "format": "%Y-%m-%d %H:%M" }
      }
    '';

    "waybar/style.css".text = ''
      * {
        font-family: JetBrainsMono, monospace;
        font-size: 12px;
        color: #e0e0e0;
      }

      window#waybar {
        background: rgba(20, 20, 20, 0.7);
        border-bottom: 1px solid #444;
      }
    '';
  };
}
