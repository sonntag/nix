;;(require :plugins.conform)
(require :plugins.oil)
(require :plugins.treesitter)
(require :keymaps)

(vim.cmd.colorscheme :rose-pine)

(local nix-cats (require :nix-cats))
(nix-cats.load-if :lang.fennel)
(nix-cats.load-if :lang.nix)
