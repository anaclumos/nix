{
  lib,
  pkgs,
  username,
  ...
}:
let
  homeDir = "/home/${username}";
  onePassAgent = "${homeDir}/.1password/agent.sock";
in
{
  programs = {
    git = {
      enable = true;
      signing = {
        signByDefault = true;
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGaWDMcfAJMbWDorZP8z1beEAz+fjLb+VFqFm8hkAlpt";
      };
      settings = {
        user = {
          name = "Sunghyun Cho";
          email = "hey@cho.sh";
        };
        core = {
          editor = "zeditor --wait";
        };
        credential = {
          helper = "${lib.getExe pkgs.gh} auth git-credential";
        };
        gpg = {
          format = "ssh";
        };
        "gpg \"ssh\"" = {
          program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        };
        commit = {
          gpgsign = true;
        };
      };
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          forwardAgent = true;
          identityAgent = onePassAgent;
        };
      };
    };
  };
}
