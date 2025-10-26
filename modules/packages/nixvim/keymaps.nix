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
      action = "<cmd>CHADopen<CR>";
      key = "<leader>l";
      options = {
        desc = "Open CHADTree";
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
    {
      action = "<cmd>DapToggleBreakpoint<CR>";
      key = "<leader>db";
      options = {
        desc = "Toggle breakpoint";
      };
    }
    {
      action = "<cmd>DapContinue<CR>";
      key = "<leader>dc";
      options = {
        desc = "Start/Continue debugging";
      };
    }
    {
      action = "<cmd>DapStepOver<CR>";
      key = "<leader>dn";
      options = {
        desc = "Step over";
      };
    }
    {
      action = "<cmd>DapStepInto<CR>";
      key = "<leader>di";
      options = {
        desc = "Step into";
      };
    }
    {
      action = "<cmd>DapStepOut<CR>";
      key = "<leader>do";
      options = {
        desc = "Step out";
      };
    }
    {
      action = "<cmd>DapTerminate<CR>";
      key = "<leader>dt";
      options = {
        desc = "Terminate debugging";
      };
    }
  ];
}

