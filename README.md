## Common commands

When adding a new config file to this repo, use this to create the symlink to the proper location:

```
stow .
```

When installing something new with homebrew, use this to rebuild the brewfile:

```
rm Brewfile && brew bundle dump
```
