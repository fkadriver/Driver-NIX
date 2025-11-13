{ pkgs, ... }:

{
  # enable home-manager managed bash (provides program hooks)
  programs.bash.enable = true;

  # common user packages (available in the user's PATH)
  home.packages = with pkgs; [
    git
    htop
  ];

  # Common bash aliases for all hosts
  home.file."/.bash_aliases".text = ''
    alias ll='ls -la'
    alias gs='git status'
    alias ga='git add'
    alias gp='git push'
    alias gpo='git push origin'
  '';

  # Ensure the aliases are loaded in interactive shells
  programs.bash.initExtra = ''
    if [ -f $HOME/.bash_aliases ]; then
      . $HOME/.bash_aliases
    fi
  '';

  # Optionally expose some home-manager managed services
  # e.g. syncthing via home-manager (the system also enables syncthing)
  # programs.syncthing.enable = true;
}
