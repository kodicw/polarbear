{
  enable = true;
  inlayHints = true;

  keymaps = {
    diagnostic = {
      "<leader>j" = {
        action = "goto_next";
        desc = "Next diagnostic";
      };
      "<leader>k" = {
        action = "goto_prev";
        desc = "Previous diagnostic";
      };
      "gl" = {
        action = "open_float";
        desc = "Show diagnostic";
      };
    };
    lspBuf = {
      K = {
        action = "hover";
        desc = "Hover documentation";
      };
      gD = {
        action = "declaration";
        desc = "Go to declaration";
      };
      gd = {
        action = "definition";
        desc = "Go to definition";
      };
      gi = {
        action = "implementation";
        desc = "Go to implementation";
      };
      gr = {
        action = "references";
        desc = "Show references";
      };
      "<leader>ca" = {
        action = "code_action";
        desc = "Code actions";
      };
      "<leader>rn" = {
        action = "rename";
        desc = "Rename symbol";
      };
      "gt" = {
        action = "type_definition";
        desc = "Type definition";
      };
    };
  };

  servers = {
    nushell = {
      enable = true;
    };

    html = {
      enable = false;
    };
    superhtml = {
      enable = true;
    };
    lua_ls = {
      enable = true;
    };

    biome = {
      enable = true;
    };

    ruff = {
      enable = true;
    };

    pylsp = {
      enable = true;
      settings = {
        plugins = {
          rope_autoimport.enable = true;
        };
      };
    };

    nil_ls = {
      enable = true;
    };

    systemd_ls = {
      enable = true;
    };

    zls = {
      enable = true;
    };

    rust_analyzer = {
      enable = true;
      installCargo = false;
      installRustc = false;
      settings = {
        checkOnSave = true;
        check.command = "clippy";
      };
    };
  };
}
