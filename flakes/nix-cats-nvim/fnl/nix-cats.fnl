(local nix-cats (require :nixCats))

(fn load-if
  [path]
  (when (nix-cats path)
    (require path)))

{: load-if}
