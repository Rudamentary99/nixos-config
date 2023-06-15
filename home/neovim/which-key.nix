{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''

          require("which-key").setup()
        '';
      }
      # TODO: Don't know how to configure this correctly
      # nvim-whichkey-setup-lua

    ];
  };
}
