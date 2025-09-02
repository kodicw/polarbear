{ pkgs
, config
, lib
, ...
}:
let
  namespace = "package_bundles";
  cfg = config.${namespace};
  packDef =
    let
      packImport = x: import x { inherit pkgs; };
    in
    {
      android-tools = packImport ./android-tools.nix;
      art = packImport ./art.nix;
      charm = packImport ./charm.nix;
      cli = packImport ./cli-apps.nix;
      desktop = packImport ./desktop.nix;
      dev = packImport ./dev.nix;
      gaming = packImport ./gaming.nix;
      hyprland = packImport ./hyprland.nix;
      network-tools = packImport ./network-tools.nix;
      nix = packImport ./nix.nix;
      media = packImport ./media.nix;
      python = (packImport ./python.nix) ++ [ pkgs.virtualenv ];
      tools = packImport ./tools.nix;
      sip-tools = packImport ./sip-tools.nix;
    };

  packOptions = x: lib.mapAttrs (name: value: { enable = lib.mkEnableOption ""; }) x;
  enablePacks = x: lib.mapAttrs
    (
      name: value: if cfg."${name}".enable then value else [ ]
    )
    packDef;
  getPacks = x: lib.flatten (lib.attrValues (enablePacks x));
in

{
  options.${namespace} = (packOptions packDef) // {
    mySystemDefaults.enable = lib.mkEnableOption "network-tools";
    openssh.enable = lib.mkEnableOption "openssh";
  };

  config = {
    environment.systemPackages =
      getPacks packDef
    ;

    nix = lib.mkIf cfg.nix.enable {
      settings = {
        experimental-features = "nix-commands flakes";
        auto-optimise-store = true;
      };
    };

    boot.kernel.sysctl = lib.mkIf cfg.gaming.enable {
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      "net.ipv4.tcp_fin_timeout" = 5;
      "vm.max_map_count" = 2147483642;
    };

    # ${namespace} = lib.mkIf cfg.mySystemDefaults.enable {
    #   system = {
    #     locale.enable = true;
    #     fonts.enable = true;
    #     time.enable = true;
    #     xkb.enable = true;
    #   };
    # };
  };
}
