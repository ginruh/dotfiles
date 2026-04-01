local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

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
vim.o.clipboard = "unnamedplus"

-- configure tab size
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- setup plugins with lazy.nvim
require("lazy").setup({
  -- kanso theme
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanso").setup({
        transparent = false,
      })
    end,
  },

  -- vscode theme
  {
    "mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({
        transparent = true,
      })
    end,
  },

  -- status bar customization
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },

  -- autoswitch themes on the basis of system themes
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      set_light_mode = function()
        vim.cmd("colorscheme kanso-pearl")
      end,
      set_dark_mode = function()
        vim.cmd("colorscheme vscode")
      end,
      update_interval = 3000,
      fallback = "dark",
    },
  },

  -- file tree
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- color codes highlighter
  "brenoprata10/nvim-highlight-colors",

  -- for closing brackets
  {
    "m4xshen/autoclose.nvim",
    config = function()
      require("autoclose").setup()
    end,
  },

  -- quick file and text search
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },

  -- lsp, formatters, linters setup
  { "mason-org/mason.nvim", opts = {} },
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    opts = {
      servers = {
        lua_ls = {},
        vtsls = {},
        pyrefly = {},
      },
    },
    config = function(_, opts)
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      for server, config in pairs(opts.servers) do
        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    opts = {
      -- keymap = { preset = 'default' },
      keymap = { preset = "super-tab" },
      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },
      completion = { documentation = { auto_show = false } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
    },
  },
})

-- formatter

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

-- configuration of plugins start here
-- buffer keybindings
vim.api.nvim_create_user_command("Format", function()
  require("conform").format({
    async = true,
    lsp_format = "fallback",
  })
end, { desc = "Format current buffer" })

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
-- require("colorizer").setup()

-- mini plugins setup
-- require("mini.starter").setup()
-- require("mini.comment").setup()
-- require("mini.pairs").setup()
-- require("mini.clue").setup()
-- require("mini.animate").setup()

-- guess-indent setup
-- require("guess-indent").setup({})

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
