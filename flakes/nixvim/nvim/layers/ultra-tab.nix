{
  # fully custom keybinding for <tab>, with behavior changes based on current context
  # 1. if autocompletion is showing but nothing has been selected yet, then <tab> will select and fill out the first item in the list
  # 2. after the first <tab> press, further <tab> presses will cycle through the items on the list.
  # 3. if there's no autocomplete, but there is an active snippet, then pressing <tab> will move to the next position in the snippet
  # 4. if there's no active snippet, then pressing <tab> will attempt to tab-out of the current treesitter context
  # 5. if there is no treesitter context to tab-out of, then <tab> will do nothing
}
