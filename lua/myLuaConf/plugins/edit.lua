return {
  {
    "nvim-spider",
    for_cat = "general.extra",
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "<c-f>",
        "<esc>l<cmd>lua require('spider').motion('w')<cr>i",
        mode = { "i" },
      },
      {
        "<c-b>",
        "<esc><cmd>lua require('spider').motion('b')<cr>i",
        mode = { "i" },
      },
    },
    after = function()
      require("spider").setup({
        consistentOperatorPending = true,
      })
    end,
  },
  {
    "nvim-lastplace",
    for_cat = "general.extra",
    event = "BufEnter",
    after = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit",
          "gitrebase",
          "svn",
          "hgcommit",
        },
        lastplace_open_folds = true,
      })
    end,
  },
  {
    "dial.nvim",
    for_cat = "general.extra",
    event = "BufEnter",
    keys = {
      {
        "<C-a>",
        function()
          require("dial.map").manipulate("increment", "normal")
        end,
        mode = { "n" },
        noremap = true,
      },
      {
        "<C-x>",
        function()
          require("dial.map").manipulate("decrement", "normal")
        end,
        mode = { "n" },
        noremap = true,
      },
      {
        "g<C-a>",
        function()
          require("dial.map").manipulate("increment", "gnormal")
        end,
        mode = { "n" },
        noremap = true,
      },
      {
        "g<C-x>",
        function()
          require("dial.map").manipulate("decrement", "gnormal")
        end,
        mode = { "n" },
        noremap = true,
      },
      {
        "<C-a>",
        function()
          require("dial.map").manipulate("increment", "visual")
        end,
        mode = { "x" },
        noremap = true,
      },
      {
        "<C-x>",
        function()
          require("dial.map").manipulate("decrement", "visual")
        end,
        mode = { "x" },
        noremap = true,
      },
      {
        "g<C-a>",
        function()
          require("dial.map").manipulate("increment", "gvisual")
        end,
        mode = { "x" },
        noremap = true,
      },
      {
        "g<C-x>",
        function()
          require("dial.map").manipulate("decrement", "gvisual")
        end,
        mode = { "x" },
        noremap = true,
      },
    },
    after = function(plugin)
      local optsSetup = function()
        local augend = require("dial.augend")

        local logical_alias = augend.constant.new({
          elements = { "&&", "||" },
          word = false,
          cyclic = true,
        })

        local ordinal_numbers = augend.constant.new({
          -- elements through which we cycle. When we increment, we go down
          -- On decrement we go up
          elements = {
            "first",
            "second",
            "third",
            "fourth",
            "fifth",
            "sixth",
            "seventh",
            "eighth",
            "ninth",
            "tenth",
          },
          -- if true, it only matches strings with word boundary. firstDate wouldn't work for example
          word = false,
          -- do we cycle back and forth (tenth to first on increment, first to tenth on decrement).
          -- Otherwise nothing will happen when there are no further values
          cyclic = true,
        })

        local weekdays = augend.constant.new({
          elements = {
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday",
            "Sunday",
          },
          word = true,
          cyclic = true,
        })

        local months = augend.constant.new({
          elements = {
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December",
          },
          word = true,
          cyclic = true,
        })

        local capitalized_boolean = augend.constant.new({
          elements = {
            "True",
            "False",
          },
          word = true,
          cyclic = true,
        })

        return {
          groups = {
            default = {
              augend.constant.alias.Alpha,
              augend.constant.alias.alpha,
              augend.constant.alias.bool,
              augend.date.alias["%-d.%-m."],
              augend.date.alias["%-m/%-d"],
              augend.date.alias["%H:%M"],
              augend.date.alias["%H:%M:%S"],
              augend.date.alias["%Y-%m-%d"],
              augend.date.alias["%Y/%m/%d"],
              augend.date.alias["%d.%m."],
              augend.date.alias["%d.%m.%Y"],
              augend.date.alias["%d.%m.%y"],
              augend.date.alias["%d/%m/%Y"],
              augend.date.alias["%d/%m/%y"],
              augend.date.alias["%m/%d"],
              augend.date.alias["%m/%d/%Y"],
              augend.date.alias["%m/%d/%y"],
              augend.integer.alias.binary,
              augend.integer.alias.decimal,
              augend.integer.alias.decimal_int,
              augend.integer.alias.hex,
              augend.integer.alias.octal,
              capitalized_boolean,
              logical_alias,
              months,
              ordinal_numbers,
              weekdays,
            },
            vue = {
              augend.constant.new({ elements = { "let", "const" } }),
              augend.hexcolor.new({ case = "lower" }),
              augend.hexcolor.new({ case = "upper" }),
            },
            typescript = {
              augend.constant.new({ elements = { "let", "const" } }),
            },
            typescriptreact = {
              augend.constant.new({ elements = { "let", "const" } }),
            },
            javascript = {
              augend.constant.new({ elements = { "let", "const" } }),
            },
            javascriptreact = {
              augend.constant.new({ elements = { "let", "const" } }),
            },
            css = {
              augend.hexcolor.new({
                case = "lower",
              }),
              augend.hexcolor.new({
                case = "upper",
              }),
            },
            markdown = {
              augend.constant.new({
                elements = { "[ ]", "[x]" },
                word = false,
                cyclic = true,
              }),
              augend.misc.alias.markdown_header,
            },
            json = {
              augend.semver.alias.semver,
            },
            lua = {
              augend.constant.new({
                elements = { "and", "or" },
                word = true,
                cyclic = true,
              }),
            },
            python = {
              augend.constant.new({
                elements = { "and", "or" },
              }),
            },
          },
        }
      end

      -- copy defaults to each group
      local opts = optsSetup()
      for name, group in pairs(opts.groups) do
        if name ~= "default" then
          vim.list_extend(group, opts.groups.default)
        end
      end
      require("dial.config").augends:register_group(opts.groups)
    end,
  },
  {
    "mini-align",
    for_cat = "general.extra",
    event = "BufEnter",
    after = function(plugin)
      require("mini.align").setup({
        mappings = {
          start = "gA",
          start_with_preview = "ga",
        },
      })
    end,
  },
  {
    "mini.ai",
    for_cat = "general.extra",
    event = "BufEnter",
    after = function()
      require("mini.ai").setup()
    end,
  },
  {
    "mini.indentscope",
    for_cat = "general.extra",
    event = "BufEnter",
    before = function()
      local function disable(args)
        vim.b[args.buf].miniindentscope_disable = true
      end
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "dashboard",
        callback = disable,
      })
      vim.api.nvim_create_autocmd("TermOpen", {
        callback = disable,
      })
    end,
    after = function()
      require("mini.indentscope").setup()
    end,
  },
  {
    "neotab",
    for_cat = "general.extra",
    event = "BufEnter",
    after = function()
      require("neotab").setup({})
    end,
  },
  {
    "rainbow-delimiters.nvim",
    for_cat = "general.always",
    event = "BufEnter",
    after = function(plugin)
      require("rainbow-delimiters.setup").setup({})
    end,
  },
  {
    "hlargs",
    for_cat = "general.extra",
    event = "BufEnter",
    -- keys = "",
    dep_of = { "nvim-lspconfig" },
    after = function(plugin)
      require("hlargs").setup({
        color = "#32a88f",
      })
      vim.cmd([[hi clear @lsp.type.parameter]])
      vim.cmd([[hi link @lsp.type.parameter Hlargs]])
    end,
  },
  {
    "grug-far.nvim",
    for_cat = "general.extra",
    keys = {
      {
        "<leader>sR",
        function()
          require("grug-far").open()
        end,
        mode = { "n", "x" },
        desc = "[S]earch within [R]ange",
      },
    },
    after = function()
      require("grug-far").setup()
    end,
  },
  {
    "treesj",
    for_cat = "general.treesitter",
    keys = {
      {
        "<leader>cS",
        function()
          require("treesj").toggle()
        end,
        mode = { "n" },
        noremap = true,
        desc = "Split/Join node",
      },
    },
    after = function(plugin)
      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
  },
  {
    "undotree",
    for_cat = "general.extra",
    cmd = {
      "UndotreeToggle",
      "UndotreeHide",
      "UndotreeShow",
      "UndotreeFocus",
      "UndotreePersistUndo",
    },
    keys = {
      {
        "<leader>U",
        "<cmd>UndotreeToggle<CR>",
        mode = { "n" },
        desc = "Undo Tree",
      },
    },
    before = function(_)
      vim.g.undotree_WindowLayout = 1
      vim.g.undotree_SplitWidth = 40
    end,
  },
  {
    "nvim-surround",
    for_cat = "general.always",
    event = "BufEnter",
    after = function(plugin)
      require("nvim-surround").setup()
    end,
  },
  {
    "nvim-autopairs",
    for_cat = "general.always",
    event = "BufEnter",
    after = function(plugin)
      require("nvim-autopairs").setup()
    end,
  },
  {
    "nvim-ts-autotag",
    for_cat = "general.treesitter",
    event = "BufEnter",
    after = function(plugin)
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "nvim-treesitter-endwise",
    for_cat = "general.treesitter",
    event = "BufEnter",
    -- after = function(plugin)
    --     require("nvim-treesitter-endwise").setup()
    -- end,
  },
  -- {
  --   "substitute.nvim",
  --   for_cat = "general.extra",
  --   event = "BufEnter",
  --   keys = {
  --     {
  --       "<leader>cso",
  --       require("substitute").operator,
  --       noremap = true,
  --       desc = "[S]ubstitute [O]perator",
  --     },
  --     {
  --       "<leader>csl",
  --       require("substitute").line,
  --       noremap = true,
  --       desc = "[S]ubstitute [L]ine",
  --     },
  --     {
  --       "<leader>cse",
  --       require("substitute").eol,
  --       noremap = true,
  --       desc = "[S]ubstitute [E]OL",
  --     },
  --     {
  --       "<leader>cs",
  --       require("substitute").visual,
  --       mode = { "x" },
  --       noremap = true,
  --       desc = "[S]ubstitute Visual",
  --     },
  --     {
  --       "<leader>cxo",
  --       require("substitute.exchange").operator,
  --       noremap = true,
  --       desc = "e[X]change [O]perator",
  --     },
  --     {
  --       "<leader>cxl",
  --       require("substitute.exchange").line,
  --       mode = { "x" },
  --       noremap = true,
  --       desc = "e[X]change [L]ine",
  --     },
  --     {
  --       "<leader>cx",
  --       require("substitute.exchange").visual,
  --       mode = { "x" },
  --       noremap = true,
  --       desc = "e[X]change Visual",
  --     },
  --   },
  --   after = function()
  --     require("substitute").setup({
  --       on_substitute = require("tiny-glimmer.support.substitute").substitute_cb,
  --       highlight_substituted_text = {
  --         enabled = false,
  --       },
  --     })
  --   end,
  -- },
}
