local keymap = vim.keymap
local wk = require('which-key')

keymap.set({"n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Use option + up/down keys to move lines
keymap.set("n", "<M-down>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
keymap.set("n", "<M-up>", ":m .-2<CR>==", { desc = "Move line up", silent = true })

keymap.set("n", "<M-o>", "o<ESC>", { desc = "Insert a new line down in normal mode" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<leader>j", "J", { desc = "Join lines" })
keymap.set("n", "<leader>qq", "<cmd> qa <CR>", { desc = "Close neovim" })
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })

-- Maintaining windown splits
wk.register({
    s = {
        name = "Window Splits",
        e = { "<C-w>=", "Make splits equal size" },
        h = { "<c-w>s", "Split window horizontally" },
        v = { "<C-w>v", "Split window vertically" },
        x = { "<cmd>close<CR>", "Close current split" },
    }
}, { prefix = "<leader>" })

-- Line movement improvements
keymap.set("n", "J", "5j", { desc = "Move 5 lines down" })
keymap.set("n", "K", "5k", { desc = "Move 5 lines up" })
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- I don't know what these do...
keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move line down" })
keymap.set("v", "<M-k>", ":m '>+1<CR>gv=gv", { desc = "Move line up" })
