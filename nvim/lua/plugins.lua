-- ==========
-- plugins --
-- ==========
vim.pack.add({
    "https://github.com/mellow-theme/mellow.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/romus204/tree-sitter-manager.nvim",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/neovim/nvim-lspconfig",
})


-- ===============
-- mellow theme --
-- ===============
vim.g.mellow_italic_comments = false
vim.g.mellow_highlight_overrides = {
    ["MatchParen"] = {
        fg = "#f2f4f8",
        bg = "#2a2c33",
        bold = true,
        underline = false,
    },

    -- match inactive background color to main theme
    ["NormalNC"] = { bg = "#161617", fg = "#a5afc2" },

    -- match floating elements, shadows, and borders with the background
    ["NormalFloat"] = { bg = "#161617", fg = "#f2f4f8" },
    ["FloatBorder"] = { bg = "#161617", fg = "#393b44" },
    ["FloatShadow"] = { bg = "#161617" },
}


-- ==========
-- mini icons
-- ==========
require("mini.icons").setup({})


-- =============
-- mini files --
-- =============
local MiniFiles = require("mini.files")
MiniFiles.setup({
    mappings = {
        go_in = "<CR>",
        go_in_plus = "L",
        go_out = "_",
        go_out_plus = "H",
    },
})

vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>-", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
end, { desc = "Toggle into currently opened file" })


-- ===============
-- mini statusline
-- ===============
local MiniStatusline = require("mini.statusline")

local original = MiniStatusline.section_fileinfo

MiniStatusline.section_fileinfo = function(...)
  return original(...):gsub("unix", "linux")
end

MiniStatusline.setup()


-- ==============
-- mini notify --
-- ==============
require("mini.notify").setup({
	-- only show messages
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
})


-- ========================== 
-- mini cmdline completion --
-- ==========================
require("mini.cmdline").setup({
    autocorrect = { enable = false }
})


-- ================
-- mini surround --
-- ================
require("mini.surround").setup()
-- Default Keymaps
-- | `sa` | Add surrounding or Direct with 'saiw' |
-- | `sd` | Delete surrounding |
-- | `sr` | Replace surrounding |
-- | `sf` | Find surrounding (right) |
-- | `sF` | Find surrounding (left) |
-- | `sh` | Highlight surrounding |
-- | `sn` | Update n_lines |
-- | `l` / `n` | as suffix for prev/next |


-- ==============
-- mini picker --
-- ==============
local MiniPick = require("mini.pick")
local MiniExtra = require("mini.extra")
MiniPick.setup()
MiniExtra.setup()

-- keymaps
vim.keymap.set("n", "<leader>pf", function() MiniPick.builtin.files() end, { desc = "Mini File Picker" })
vim.keymap.set("n", "<leader>ps", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, { desc = "Grep word/Search word" })
vim.keymap.set("n", "<leader>vh", function() MiniPick.builtin.help() end, { desc = "Mini Help" })

vim.keymap.set("n", "<leader>xx", function() MiniExtra.pickers.diagnostic() end, { desc = "Mini Picker Diagnostics" })
vim.keymap.set("n", "<leader>pk", function() MiniExtra.pickers.keymaps() end, { desc = 'Search keymaps' })


-- ===================
-- mini completions --
-- =================== 
require("mini.completion").setup({
    lsp_completion = {
        auto_setup = true,
    }
})


-- ================
-- mini snippets --
-- ================
local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(), -- loads friendly-snippets
    },
})
MiniSnippets.start_lsp_server({ match = false })


-- =========================
-- mini diff and fugitive --
-- =========================
local MiniDiff = require("mini.diff")
MiniDiff.setup({
	source = MiniDiff.gen_source.git({ index = false }),
})

vim.keymap.set("n", "<leader>gg", "<cmd>tabnew | Git | only<cr>", { desc = "Fugitive Full Page New Tab" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<CR>", { desc = "Git diff split", })


-- =====================
-- treesitter manager --
-- =====================
require("tree-sitter-manager").setup({
  ensure_installed = {
    "lua",

    "vim",
    "python",
    "html",
    "javascript",
    "css",
    "json",
    "typescript",
    "tsx",
    "go",
    "dockerfile",
    "bash",
    "yaml",
    "terraform",
    "toml",
    "regex",
    "markdown",
    "zig",
  },

  auto_install = true,
})


-- ======
-- lsp --
-- ======
require("mason").setup()

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format Local buffer" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

vim.diagnostic.config({ virtual_text = true })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())

vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
})

vim.lsp.enable({
    "ts_ls",
    "bashls",
    "cssls",
    "gopls",
    "basedpyright",
    "html",
    "jsonls",
    "lua_ls",
    "marksman",
    "tailwindcss",
    "taplo",
    "yamlls",
    "zls",
})
