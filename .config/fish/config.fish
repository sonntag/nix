if status is-interactive
    # Commands to run in interactive sessions can go here
end

source /opt/homebrew/opt/asdf/libexec/asdf.fish
#test -e /Users/justin/.iterm2_shell_integration.fish ; and source /Users/justin/.iterm2_shell_integration.fish ; or true
source /Users/justin/.config/op/plugins.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/Caskroom/mambaforge/base/bin/conda
    eval /opt/homebrew/Caskroom/mambaforge/base/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

# Source the Nord theme dircolors
eval (gdircolors -c ~/.dircolors)

# Initialize zoxide and alias it to d
zoxide init --cmd cd fish | source

# Initialize starship
starship init fish | source
