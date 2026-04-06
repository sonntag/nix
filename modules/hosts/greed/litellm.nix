{
  den.aspects.greed.darwin = {config, ...}: {
    services.litellm = {
      enable = false;
      secretFiles = {
        OPENAI_AMPERITY_UE2_KEY = config.sops.secrets.openai_amperity_ue2_key.path;
        OPENAI_API_KEY = config.sops.secrets.openai_api_key.path;
      };
      settings = {
        model_list = [
          {
            model_name = "gpt-5.3-codex";
            litellm_params = {
              model = "azure/gpt-5.3-codex";
              api_base = "https://amperity-ue2.openai.azure.com/";
              api_version = "2025-04-01-preview";
              api_key = "os.environ/OPENAI_AMPERITY_UE2_KEY";
              base_model = "gpt-5.3-codex";
            };
          }
          {
            model_name = "gpt-5.2-codex";
            litellm_params = {
              model = "azure/gpt-5.2-codex";
              api_base = "https://amperity-ue2.openai.azure.com/";
              api_version = "2025-04-01-preview";
              api_key = "os.environ/OPENAI_AMPERITY_UE2_KEY";
              base_model = "gpt-5.2-codex";
            };
          }
          {
            model_name = "gpt-5.2";
            litellm_params = {
              model = "azure/gpt-5.2";
              api_base = "https://amperity-ue2.openai.azure.com/";
              api_version = "2025-03-01-preview";
              api_key = "os.environ/OPENAI_AMPERITY_UE2_KEY";
              base_model = "gpt-5.2";
            };
          }
          {
            model_name = "gpt-5.1-codex-max";
            litellm_params = {
              model = "azure/gpt-5.1-codex-max";
              api_base = "https://amperity-ue2.openai.azure.com/";
              api_version = "2025-03-01-preview";
              api_key = "os.environ/OPENAI_AMPERITY_UE2_KEY";
              base_model = "gpt-5.1-codex-max";
            };
          }
          {
            model_name = "gpt-5.1-codex";
            litellm_params = {
              model = "azure/gpt-5.1-codex";
              api_base = "https://amperity-ue2.openai.azure.com/";
              api_version = "2025-03-01-preview";
              api_key = "os.environ/OPENAI_AMPERITY_UE2_KEY";
              base_model = "gpt-5.1-codex";
            };
          }
          {
            model_name = "gpt-5.1";
            litellm_params = {
              model = "azure/gpt-5.1";
              api_base = "https://amperity-ue2.openai.azure.com/";
              api_version = "2025-03-01-preview";
              api_key = "os.environ/OPENAI_AMPERITY_UE2_KEY";
              base_model = "gpt-5.1";
            };
          }
          {
            model_name = "gpt-5-codex";
            litellm_params = {
              model = "azure/gpt-5-codex";
              api_base = "https://amperity-ue2.openai.azure.com/";
              api_version = "2025-03-01-preview";
              api_key = "os.environ/OPENAI_AMPERITY_UE2_KEY";
              base_model = "gpt-5-codex";
            };
          }
          {
            model_name = "gpt-5";
            litellm_params = {
              model = "azure/gpt-5";
              api_base = "https://amperity-ue2.openai.azure.com/";
              api_version = "2025-03-01-preview";
              api_key = "os.environ/OPENAI_AMPERITY_UE2_KEY";
              base_model = "gpt-5";
            };
          }
          {
            model_name = "gpt-5-mini";
            litellm_params = {
              model = "azure/gpt-5-mini";
              api_base = "https://amperity-ue2.openai.azure.com/";
              api_version = "2025-03-01-preview";
              api_key = "os.environ/OPENAI_AMPERITY_UE2_KEY";
              base_model = "gpt-5-mini";
            };
          }
          {
            model_name = "gpt-5-nano";
            litellm_params = {
              model = "azure/gpt-5-nano";
              api_base = "https://amperity-ue2.openai.azure.com/";
              api_version = "2025-03-01-preview";
              api_key = "os.environ/OPENAI_AMPERITY_UE2_KEY";
              base_model = "gpt-5-nano";
            };
          }
          {
            model_name = "gpt-4o";
            litellm_params = {
              model = "azure/gpt-4o";
              api_base = "https://amperity-engineering.openai.azure.com/";
              api_version = "2024-12-01-preview";
              api_key = "os.environ/OPENAI_API_KEY";
            };
          }
          {
            model_name = "gpt-4o-mini";
            litellm_params = {
              model = "azure/gpt-4o-mini";
              api_base = "https://amperity-engineering.openai.azure.com/";
              api_version = "2024-12-01-preview";
              api_key = "os.environ/OPENAI_API_KEY";
            };
          }
          {
            model_name = "o1-mini";
            litellm_params = {
              model = "azure/o1-mini";
              api_base = "https://amperity-engineering.openai.azure.com/";
              api_version = "2024-12-01-preview";
              api_key = "os.environ/OPENAI_API_KEY";
            };
          }
          {
            model_name = "o1";
            litellm_params = {
              model = "azure/o1";
              api_base = "https://amperity-ue2.openai.azure.com/";
              api_version = "2024-12-01-preview";
              api_key = "os.environ/OPENAI_AMPERITY_UE2_KEY";
            };
          }
          {
            model_name = "claude-3.5-sonnet";
            litellm_params = {
              model = "bedrock/anthropic.claude-3-5-sonnet-20241022-v2:0";
              aws_profile_name = "sre";
            };
          }
          {
            model_name = "claude-3.7-sonnet";
            litellm_params = {
              model = "bedrock/us.anthropic.claude-3-7-sonnet-20250219-v1:0";
              aws_profile_name = "sre";
              aws_region_name = "us-west-2";
            };
          }
          {
            model_name = "claude-4-sonnet";
            litellm_params = {
              model = "bedrock/us.anthropic.claude-sonnet-4-20250514-v1:0";
              aws_profile_name = "sre";
              aws_region_name = "us-west-2";
            };
          }
          {
            model_name = "claude-4-opus";
            litellm_params = {
              model = "bedrock/us.anthropic.claude-opus-4-20250514-v1:0";
              aws_profile_name = "sre";
              aws_region_name = "us-west-2";
            };
          }
          {
            model_name = "claude-4.1-opus";
            litellm_params = {
              model = "bedrock/us.anthropic.claude-opus-4-1-20250805-v1:0";
              aws_profile_name = "sre";
              aws_region_name = "us-west-2";
            };
          }
          {
            model_name = "claude-4.5-opus";
            litellm_params = {
              model = "bedrock/us.anthropic.claude-opus-4-5-20251101-v1:0";
              aws_profile_name = "sre";
              aws_region_name = "us-west-2";
            };
          }
        ];
        litellm_settings = {
          drop_params = true;
        };
      };
    };
  };
}
