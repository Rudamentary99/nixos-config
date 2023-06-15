{ pkgs, ... }:
{
  imports = [
    ./neovim/lspconfig.nix
    ./neovim/telescope.nix
    # ./neovim/coc.nix
    # ./neovim/haskell.nix
    # ./neovim/rust.nix
    # ./neovim/zk.nix
    # which-key must be the last import for it to recognize the keybindings of
    # previous imports.
    ./neovim/which-key.nix
  ];
  programs.neovim = {
    enable = true;

    extraPackages = [
      pkgs.lazygit
      pkgs.himalaya
    ];

    # Full list here,
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/generated.nix
    plugins = with pkgs.vimPlugins; [
      # Status bar for vim

      # For working mouse support when running inside tmux
      terminus

      {
        plugin = lazygit-nvim;
        type = "lua";
        config = ''
          nmap("<leader>gg", ":LazyGit<cr>")
        '';
      }

      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      # Preferred theme
      # {
      #   plugin = gruvbox;
      #   type = "lua";
      #   config = '';
      #     require("gruvbox").setup()
      #   '';
      # }
      gruvbox
      # File browser
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require("nvim-tree").setup()
          nmap("<C-n>", ":NvimTreeFindFile<CR>")
        '';
      }
      nvim-web-devicons

      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup {
            options = {
              theme = 'gruvbox',
              icons_enabled = true
            }
          }
        '';
      }

      # Buffer tabs
      {
        plugin = barbar-nvim;
        type = "lua";
        config = ''
            require('barbar').setup()

          -- Move to previous/next
          nmap('<A-,>', '<Cmd>BufferPrevious<CR>')
          nmap('<A-.>', '<Cmd>BufferNext<CR>')
          -- Re-order to previous/next
          nmap('<A-<>', '<Cmd>BufferMovePrevious<CR>')
          nmap('<A->>', '<Cmd>BufferMoveNext<CR>')
          -- Goto buffer in position...
          nmap( '<A-1>', '<Cmd>BufferGoto 1<CR>')
          nmap( '<A-2>', '<Cmd>BufferGoto 2<CR>')
          nmap( '<A-3>', '<Cmd>BufferGoto 3<CR>')
          nmap( '<A-4>', '<Cmd>BufferGoto 4<CR>')
          nmap( '<A-5>', '<Cmd>BufferGoto 5<CR>')
          nmap( '<A-6>', '<Cmd>BufferGoto 6<CR>')
          nmap( '<A-7>', '<Cmd>BufferGoto 7<CR>')
          nmap( '<A-8>', '<Cmd>BufferGoto 8<CR>')
          nmap( '<A-9>', '<Cmd>BufferGoto 9<CR>')
          nmap( '<A-0>', '<Cmd>BufferLast<CR>')
          -- Pin/unpin buffer
          nmap( '<A-p>', '<Cmd>BufferPin<CR>')
          -- Close buffer
          nmap( '<A-c>', '<Cmd>BufferClose<CR>')
          -- Wipeout buffer
          --                 :BufferWipeout
          -- Close commands
          --                 :BufferCloseAllButCurrent
          --                 :BufferCloseAllButPinned
          --                 :BufferCloseAllButCurrentOrPinned
          --                 :BufferCloseBuffersLeft
          --                 :BufferCloseBuffersRight
          -- Magic buffer-picking mode
          nmap( '<C-p>', '<Cmd>BufferPick<CR>')
          -- Sort automatically by...
          nmap( '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>')
          nmap( '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>')
          nmap( '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>')
          nmap( '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>')

        '';
      }

      # {
      #   plugin = bufferline-nvim;
      #   type = "lua";intelephense
      #   config = ''
      #     require("bufferline").setup{ }
      #     nmap("<leader>b", ":BufferLineCycleNext<cr>")
      #     nmap("<leader>B", ":BufferLineCyclePrev<cr>")
      #   '';intelephense
      # }

      # Language support
      vim-nix
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require("Comment").setup()
        '';
      }
      {
        plugin = copilot-lua;
        type = "lua";
        config = ''
          require("copilot").setup()
        '';
      }
      # # nushell
      # null-ls-nvim
      # {
      #   plugin = nvim-nu;
      #   type = "lua";
      #   config = ''
      #       require'nu'.setup{
      #         use_lsp_features = true, -- requires https://github.com/jose-elias-alvarez/null-ls.nvim
      #         -- lsp_feature: all_cmd_names is the source for the cmd name completion.
      #         -- It can be
      #         --  * a string, which is interpreted as a shell command and the returned list is the source for completions (requires plenary.nvim)
      #         --  * a list, which is the direct source for completions (e.G. all_cmd_names = {"echo", "to csv", ...})
      #         --  * a function, returning a list of strings and the return value is used as the source for completions
      #         all_cmd_names = [[nu -c 'help commands | get name | str join "\n"']]
      #     }
      #   '';
      # }

      # vim-markdown
    ];

    # Add library code here for use in the Lua config from the
    # plugins list above.
    extraConfig = ''
      lua << EOF
      ${builtins.readFile ./neovim.lua}
      EOF
    '';
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "ee";
      text = ''
        set -x
        exec nvim "$(fzf)"
      '';
    })
  ];

}
