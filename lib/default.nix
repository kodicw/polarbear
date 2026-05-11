{
  /**
    Creates a hardened boot configuration with secure boot settings.

    # Example

    ```nix
    lib.mkHardenedBoot true
    ```
  */
  mkHardenedBoot = enable: {
    inherit enable;
    kernelParams = [ "security=apparmor" "lockdown=confidentiality" ];
  };

  /**
    Generates user groups based on a list of usernames.

    # Arguments

    users
    : List of usernames to create groups for

    # Example

    ```nix
    lib.mkUserGroups [ "charles" "alice" ]
    ```
  */
  mkUserGroups = users:
    builtins.listToAttrs (
      builtins.map (user: {
        name = user;
        value = {
          name = user;
          gid = 1000;
        };
      }) users
    );
}