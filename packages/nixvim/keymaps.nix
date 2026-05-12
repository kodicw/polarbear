{ ... }: {
  keymaps = [
    {
      action = "<cmd>Telescope buffers<CR>";
      key = "<leader>b";
      options = {
        desc = "Find buffers";
      };
    }
    {
      action = "<cmd>Neogit<CR>";
      key = "<leader>g";
      options = {
        desc = "Git UI";
      };
    }
    {
      action = "<cmd>\'<,\'>!mods 'make corrections to my notes'<CR>";
      key = "<leader>s";
      options = {
        desc = "AI correct";
      };
    }
    {
      action = "<cmd>Oil<CR>";
      key = "<leader>f";
      options = {
        desc = "Open oil";
      };
    }
    {
      action = "<cmd>MCunderCursor<CR>";
      key = "<leader>c";
      options = {
        desc = "Start multicursor";
      };
    }
    {
      action = "<cmd>ToggleTerm<CR>";
      key = "<leader>t";
      options = {
        desc = "Toggle terminal";
      };
    }
    {
      action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";
      key = "<leader>p";
      options = {
        desc = "Format buffer";
      };
    }
    {
      action = "<cmd>Telescope diagnostics<CR>";
      key = "<leader>d";
      options = {
        desc = "Show diagnostics";
      };
    }
  ];
}

