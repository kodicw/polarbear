{
  imports = [
    ./treesitter.nix
    ./keymaps.nix
    ./plugins.nix
  ];
  opts = {
    number = true;
    relativenumber = true;
    cursorline = true;

    # 2 space tab
    tabstop = 2;
    softtabstop = 2;
    showtabline = 2;
    expandtab = true;

    # Enable auto indent
    smartindent = true;
    shiftwidth = 2;

    # Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
    breakindent = true;

    updatetime = 50; # faster completion (4000ms default)

    # Enable persistent undo history
    swapfile = false;
    backup = false;
    undofile = true;

    termguicolors = true;

    # set encoding
    encoding = "utf-8";
    fileencoding = "utf-8";

  };
  globals = {
    mapleader = " ";
  };
  viAlias = true;
  vimAlias = true;
  clipboard.register = "unnamedplus";
  colorschemes.oxocarbon.enable = true;
  clipboard.providers.wl-copy.enable = true;
}


