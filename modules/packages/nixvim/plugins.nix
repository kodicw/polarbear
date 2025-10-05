{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [
    nim-vim
    nvim-nu
  ];
  plugins = {
    none-ls = {
      enable = true;
    };
    lsp-lines.enable = true;
    web-devicons.enable = true;
    chadtree = {
      enable = true;
    };
    nix.enable = true;
    image = {
      enable = true;
    };
    noice.enable = true;
    todo-comments.enable = true;
    toggleterm.enable = true;
    neogit.enable = true;
    dap.enable = true;
    dap-python.enable = true;
    dap-ui.enable = true;
    multicursors.enable = true;
    endwise.enable = true;
    mini = {
      enable = true;
      modules = {
        comment = { };
      };
    };
    avante = {
      enable = true;
      settings = {
        provider = "ollama";
        ollama = {
          model = "qwen3:8b";
        };
      };
    };
    bufferline.enable = true;
    luasnip.enable = true;
    treesitter.enable = true;
    lspkind.enable = true;
    lint.enable = true;
    wtf.enable = true;
    vim-surround.enable = true;

    oil = {
      enable = true;
      settings = {
        skip_confirm_for_simple_edits = true;
        delete_to_trash = true;
        # view_options = {
        #   show_hidden = false;
        # };
      };
    };

    lualine.enable = true;
    notify = {
      enable = true;
      settings = {
        level = "error";
      };
    };
    lsp-format.enable = true;
    cmp = {
      autoEnableSources = true;
      enable = true;
      settings = {
        completion.autoImport = true;
        snippet.expand = "luasnip";
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "treesitter"; }
          { name = "calc"; }
          { name = "dictionary"; }
          { name = "emoji"; }
          { name = "snippy"; }
          { name = "spell"; }
        ];
        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<S-CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };
    telescope = {
      enable = true;
      settings.defaults.file_ignore_patterns = [ "^.git/" ];
      keymaps."<leader>e" = "find_files";
    };
    which-key.enable = true;
    lsp = import ./lsp.nix;
  };
}

