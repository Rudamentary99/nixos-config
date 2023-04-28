{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      # Doom-emacs like experience
      {
        plugin = vim-which-key;
        type = "lua";
        # TODO: How to port this to Lua?
        config = ''
          vim.o.timeout = true
          vim.o.timeoutlen = 300
          require("which-key").setup {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
          }
        '';
      }
      # TODO: Don't know how to configure this correctly
      # nvim-whichkey-setup-lua


    ];
  };
}
