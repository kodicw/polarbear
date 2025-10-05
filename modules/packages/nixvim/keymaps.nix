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
  ];
}

