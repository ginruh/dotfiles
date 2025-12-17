local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

function configure_theme()
  require('nightfox').setup({
    options = {
      transparent = true,
      styles = {
        comments = "italic",
        keywords = "bold",
        types = "italic,bold",
      }
    }
  })
end

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

--set leader
vim.g.mapleader = " "

-- setting vim options
vim.opt.rtp:prepend(lazypath)
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.wo.wrap = false
vim.o.clipboard = 'unnamedplus'

-- configure folding
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldcolumn = "0"
-- vim.opt.foldtext = "v:folddashes.substitute(getline(v:foldstart),'/\\*\\\\|\\*/\\\\|{{{\\d\\=','','g')"
-- vim.opt.foldnestmax = 2
-- vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 1

-- configure tab size
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- setup plugins with lazy.nvim
require("lazy").setup({
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",
  "christoomey/vim-tmux-navigator",
  "nmac427/guess-indent.nvim",
  "norcalli/nvim-colorizer.lua",
  "kevinhwang91/promise-async",
  "kevinhwang91/nvim-ufo",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },
  { "rebelot/kanagawa.nvim", priority = 1000 },
  { "EdenEast/nightfox.nvim", priority = 1001 },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      set_dark_mode = function()
        configure_theme()
        vim.cmd("colorscheme nordfox")
      end,
      set_light_mode = function()
        configure_theme()
        vim.cmd("colorscheme dayfox")
      end,
      update_interval = 3000,
      fallback = "dark"
    }
  },
  -- Telescope
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  -- lsp, linters, formatters plugins
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
  },
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "mhartington/formatter.nvim",
  "mfussenegger/nvim-lint",
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  -- mini.nvim plugins
  { "echasnovski/mini.starter", version = false },
  { "echasnovski/mini.comment", version = false },
  { "echasnovski/mini.pairs", version = false },
  { "echasnovski/mini.clue", version = false },
  { "echasnovski/mini.animate", opts = {}, version = false },
  { "echasnovski/mini-git", opts = {}, main = "mini.git", version = false },
  { "echasnovski/mini.diff", opts = {}, version = false },
})

-- configuration of plugins start here
-- buffer keybindings

vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", {})
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", {})

-- nvim-tree setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.nvim_tree = {
  default = "",
  symlink = "",
  git = {
    unstaged = "",
    staged = "",
  },
  folder = {
    default = "",
    arrow_open = "",
    arrow_closed = "",
    symlink_open = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
  },
}
require("nvim-tree").setup({
  view = {
    side = "right",
  },
  renderer = {
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
        git = false,
        modified = false,
      },
    },
  },
})

vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<cr>", {})
vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFocus<cr>", {})


-- colorizer setup
require("colorizer").setup()

-- mini plugins setup
require("mini.starter").setup()
require("mini.comment").setup()
require("mini.pairs").setup()
require("mini.clue").setup()
require("mini.animate").setup()

-- guess-indent setup
require("guess-indent").setup({})

-- configure telescope
local builtin = require("telescope.builtin")
local defaults = { previewer = false, disable_devicons = true }
local pickers = setmetatable({}, {
  __index = function(_, key)
    if builtin[key] == nil then
      error("Invalid key, please check :h telescope.builtin")
      return
    end
    return function(opts)
      opts = vim.tbl_extend("keep", opts or {}, defaults)
      builtin[key](opts)
    end
  end,
})
vim.keymap.set("n", "<leader>ff", pickers.find_files, {})
vim.keymap.set("n", "<leader>fg", pickers.live_grep, {})
vim.keymap.set("n", "<leader>fb", pickers.buffers, {})
vim.keymap.set("n", "<leader>fh", pickers.help_tags, {})

-- configure treesitter
local treesitter_config = require("nvim-treesitter.configs")
treesitter_config.setup({
  ensure_installed = {
    "css",
    "lua",
    "typescript",
    "tsx",
    "jsdoc",
    "graphql",
    "yaml",
    "javascript",
    "html",
    "bash",
    "dockerfile",
    "go",
    "gomod",
    "gosum",
    "jq",
    "python",
    "scss",
    "sql",
    "toml",
  },
  highlight = { enable = true },
  indent = { enable = true },
})

-- LSP
local cmp = require("cmp")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
local luasnip = require("luasnip")

local lsp_list = {
  "gopls",
  "pyright",
  "ts_ls",
  "lua_ls",
}

local formatters_linters_list = {
  "black", -- python
  "prettier", -- js/ts
  "eslint"
}

-- require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = lsp_list,
})
require("mason-tool-installer").setup({
  ensure_installed = formatters_linters_list,
})

vim.keymap.set({ "n", "v" }, "<M-y>", [["+Y]])
vim.keymap.set({ "n", "v" }, "<M-p>", [["+P]])

local on_attach = function()
  -- lsp
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0 })

  -- diagnostic
  vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { buffer = 0 })
  vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { buffer = 0 })
  vim.keymap.set("n", "E", vim.diagnostic.open_float, { buffer = 0 })
  vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", { buffer = 0 })

  -- code action
  vim.keymap.set("n", "<leader>cc", vim.lsp.buf.code_action, { buffer = 0 })

  -- format
  vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { buffer = 0 })
end

-- Configure netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
})

for _, lsp_name in pairs(lsp_list) do
  if lsp_name == "gopls" then
    lspconfig.gopls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        gopls = {
          experimentalPostfixCompletions = true,
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
        },
      },
    })
  else
    lspconfig[lsp_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
end

-- fold
-- require('ufo').setup()

-- formatter
require("formatter").setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    typescript = {
      require("formatter.filetypes.typescript").prettier,
    },
    typescriptreact = {
      require("formatter.filetypes.typescript").prettier,
    },
    javascript = {
      require("formatter.filetypes.javascript").prettier,
    },
    javascriptreact = {
      require("formatter.filetypes.javascriptreact").prettier,
    },
    python = {
      require("formatter.filetypes.python").black,
    },
    json = {
      require("formatter.filetypes.json").prettier,
    },
    html = {
      require("formatter.filetypes.html").prettier,
    },
    go = {
      require("formatter.filetypes.go").gofmt,
    },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
})

-- linters
require("lint").linters_by_ft = {
  javascript = { "eslint" },
  javascriptreact = { "eslint" },
  typescript = { "eslint" },
  typescriptreact = { "eslint" },
  python = { "black" },
}
