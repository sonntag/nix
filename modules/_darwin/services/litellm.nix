{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.litellm;
  settingsFormat = pkgs.formats.yaml {};
  configFile =
    if cfg.configFile != null
    then cfg.configFile
    else settingsFormat.generate "litellm-config.yaml" cfg.settings;

  # Generate shell commands to export secrets as environment variables
  secretExports = concatStringsSep "\n" (mapAttrsToList
    (envVar: secretPath: ''export ${envVar}="$(cat ${secretPath})"'')
    cfg.secretFiles);

  # Wrapper script that loads secrets and runs litellm
  wrapperScript = pkgs.writeShellScript "litellm-wrapper" ''
    ${secretExports}
    exec ${cfg.package}/bin/litellm \
      --host ${cfg.host} \
      --port ${toString cfg.port} \
      ${optionalString (cfg.configFile != null || cfg.settings != {}) "--config ${configFile}"} \
      ${concatStringsSep " " cfg.extraArgs}
  '';
in {
  options.services.litellm = {
    enable = mkEnableOption "litellm LLM proxy service";

    package = mkOption {
      type = types.package;
      default = pkgs.litellm;
      defaultText = literalExpression "pkgs.litellm";
      description = "The litellm package to use.";
    };

    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Host address to bind to.";
    };

    port = mkOption {
      type = types.port;
      default = 4000;
      description = "Port to run litellm on.";
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to litellm config file (YAML).
        If null, the config will be generated from the settings option.
      '';
    };

    settings = mkOption {
      type = settingsFormat.type;
      default = {};
      description = ''
        litellm configuration as a Nix attribute set.
        Will be converted to YAML. Ignored if configFile is set.
      '';
      example = literalExpression ''
        {
          model_list = [
            {
              model_name = "gpt-4";
              litellm_params = {
                model = "azure/gpt-4";
                api_base = "https://my-endpoint.openai.azure.com";
                api_key = "os.environ/AZURE_API_KEY";
              };
            }
          ];
        }
      '';
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = ''
        Environment variables to pass to litellm directly.
        For secrets managed by sops-nix, use secretFiles instead.
      '';
      example = literalExpression ''
        {
          SOME_VAR = "value";
        }
      '';
    };

    secretFiles = mkOption {
      type = types.attrsOf types.path;
      default = {};
      description = ''
        Mapping of environment variable names to secret file paths.
        These files (typically from sops-nix) will be read at runtime
        and exported as environment variables.
      '';
      example = literalExpression ''
        {
          OPENAI_API_KEY = config.sops.secrets.openai_api_key.path;
          OPENAI_AMPERITY_UE2_KEY = config.sops.secrets.openai_amperity_ue2_key.path;
        }
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra command-line arguments to pass to litellm.";
      example = ["--debug" "--detailed_debug"];
    };

    logDir = mkOption {
      type = types.str;
      default = "/Library/Logs/LiteLLM";
      description = "Directory for litellm logs.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    environment.shellAliases = {
      kickstart-litellm = "sudo launchctl kickstart -k system/org.nixos.litellm";
    };

    launchd.daemons.litellm = {
      serviceConfig =
        {
          RunAtLoad = true;
          KeepAlive = true;
          StandardErrorPath = "${cfg.logDir}/litellm.err.log";
          StandardOutPath = "${cfg.logDir}/litellm.out.log";
          EnvironmentVariables = cfg.environment;
        }
        // (
          if cfg.secretFiles != {}
          then {
            # Use wrapper script to load secrets
            ProgramArguments = ["${wrapperScript}"];
          }
          else {
            # Direct invocation without secrets
            ProgramArguments =
              [
                "${cfg.package}/bin/litellm"
                "--host"
                cfg.host
                "--port"
                (toString cfg.port)
              ]
              ++ (optionals (cfg.configFile != null || cfg.settings != {}) [
                "--config"
                (toString configFile)
              ])
              ++ cfg.extraArgs;
          }
        );
    };
  };
}
