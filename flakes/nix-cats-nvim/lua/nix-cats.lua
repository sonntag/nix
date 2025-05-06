-- [nfnl] Compiled from fnl/nix-cats.fnl by https://github.com/Olical/nfnl, do not edit.
local nix_cats = require("nixCats")
local function load_if(path)
  if nix_cats(path) then
    return require(path)
  else
    return nil
  end
end
return {["load-if"] = load_if}
