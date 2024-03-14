function aws-profile
    set -x AWS_PROFILE $argv[1]
    aws sso login
    aws configure list
end
