(local ts (require :nvim-treesitter))
(ts.setup {})

(local cfgs (require :nvim-treesitter.configs))
(cfgs.setup {:autotag   {:enable true}
             :highlight {:enable true}
             :indent    {:enable true}})

{}
