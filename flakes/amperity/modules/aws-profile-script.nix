{pkgs, ...}:
pkgs.writeShellScriptBin "aws-profile" ''
  export AWS_PROFILE="$1"
  ${pkgs.awscli2}/bin/aws sso login
  ${pkgs.awscli2}/bin/aws configure list
''
