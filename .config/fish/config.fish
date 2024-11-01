if status is-interactive
    # Commands to run in interactive sessions can go here
    
    # Source the Nord theme dircolors
    eval (dircolors -c ~/.dircolors)

    # Initialize zoxide and alias it to d
    zoxide init --cmd cd fish | source

    # Initialize starship
    starship init fish | source
end

#test -e /Users/justin/.iterm2_shell_integration.fish ; and source /Users/justin/.iterm2_shell_integration.fish ; or true
source /Users/justin/.config/op/plugins.sh
