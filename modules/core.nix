{ config, ... }:
let
  user = config.modules.user.name;
  userHome = "/home/${user}";
  onePassAgent = "${userHome}/.1password/agent.sock";
  lunitSessionVariables = rec {
    INCL_SERVER_HOST = "34.47.100.100";
    INCL_DJANGO_PORT = "30000";
    INCL_GIN_PORT = "30010";
    INCL_RECORD_SERVER_URL = "http://${INCL_SERVER_HOST}:${INCL_GIN_PORT}/api/v1";
    INCL_BACKEND_SERVER_URL = "http://${INCL_SERVER_HOST}:${INCL_DJANGO_PORT}/api/v1";
    INCL_DATA_ROOT = "./data_root";
  };
in
{
  programs = {
    zsh.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ user ];
    };
  };
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
  environment = {
    sessionVariables = lunitSessionVariables;
    etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          google-chrome
          google-chrome-stable
          .google-chrome-wrapped
          .zen-wrapped
          zen
        '';
        mode = "0755";
      };
    };
    variables = {
      OP_SERVICE_ACCOUNT_TOKEN = "/etc/1password/service-account-token";
      SSH_AUTH_SOCK = onePassAgent;
    };
  };
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        extraConfig = builtins.readFile ./keyd.conf;
      };
    };
  };
}
