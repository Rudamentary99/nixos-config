{ pkgs
, ...
}:

{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "thefuck"
        "z"
        "vi-mode"
        "command-not-found"
        "alias-finder"
        "aliases"
        "common-aliases"

      ];
    };
    plugins =
      [
        {
          # will source zsh-autosuggestions.plugin.zsh
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub
            {
              owner = "zsh-users";
              repo = "zsh-autosuggestions";
              rev = "v0.4.0";
              sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
            };
        }
      ];
  };
  # This must be envExtra (rather than initExtra), because doom-emacs requires it
  # https://github.com/doomemacs/doomemacs/issues/687#issuecomment-409889275
  #
  # But also see: 'doom env', which is what works.
  programs.zsh.envExtra = ''
    export PATH=/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin/:$PATH
    # For 1Password CLI. This requires `pkgs.gh` to be installed.
    source $HOME/.config/op/plugins.sh
    # Because, adding it in .ssh/config is not enough.
    # cf. https://developer.1password.com/docs/ssh/get-started#step-4-configure-your-ssh-or-git-client
    export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
    ZSH_THEME='jonathan'
  '';

  programs.nix-index.enableZshIntegration = true;
}
