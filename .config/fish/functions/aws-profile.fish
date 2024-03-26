function aws-profile
    set -gx AWS_PROFILE $argv[1]
    aws sso login
    aws configure list
end
