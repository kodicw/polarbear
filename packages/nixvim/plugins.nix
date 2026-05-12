{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [
    nim-vim
    nvim-nu
  ];
  plugins = {
    lsp-lines.enable = true;
    web-devicons.enable = false;
    nix.enable = true;
    todo-comments = {
      enable = true;
      settings = {
        signs = false;
      };
    };
    toggleterm.enable = true;
    neogit.enable = true;
    multicursors.enable = true;
    endwise.enable = true;
    mini = {
      enable = true;
      modules = {
        comment = { };
      };
    };
    bufferline = {
      enable = true;
      settings = {
        options = {
          show_buffer_icons = false;
          show_buffer_close_icons = false;
          show_close_icon = false;
        };
      };
    };
    luasnip.enable = true;
    treesitter.enable = true;
    lspkind = {
      enable = true;
      settings = {
        mode = "text";
      };
    };
    lint = {
      enable = true;
      lintersByFt = {
        rust = [ "clippy" ];
        nix = [ "nix" ];
        python = [ "ruff" ];
        markdown = [ "markdownlint" ];
      };
    };
    wtf.enable = true;
    vim-surround.enable = true;

    llm = {
      enable = true;
      settings = {
        backend = "ollama";
        model = "qwen2.5-coder:0.5b-base";
        url = "http://localhost:11434";
        request_body = {
          options = {
            temperature = 0.2;
            top_p = 0.95;
          };
        };
        fim = {
          enabled = true;
          prefix = "<|fim_prefix|>";
          middle = "<|fim_middle|>";
          suffix = "<|fim_suffix|>";
        };
        accept_keymap = "<C-y>";
        dismiss_keymap = "<C-e>";
        context_window = 1024;
        debounce_ms = 200;
        enable_suggestions_on_startup = true;
      };
    };

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

    lualine = {
      enable = true;
      settings = {
        options = {
          icons_enabled = false;
        };
      };
    };
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

