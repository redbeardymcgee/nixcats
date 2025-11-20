return {
  {
    "fidget.nvim",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    -- keys = "",
    after = function(plugin)
      require("fidget").setup({})
    end,
  },
  {
    "mini-animate",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    -- keys = "",
    after = function(plugin)
      require("mini.animate").setup({})
    end,
  },
  {
    "lualine.nvim",
    for_cat = "general.always",
    -- cmd = { "" },
    event = "DeferredUIEnter",
    -- ft = "",
    -- keys = "",
    -- colorscheme = "",
    after = function(plugin)
      require("lualine").setup({
        options = {
          icons_enabled = false,
          theme = colorschemeName,
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_c = {
            {
              "filename",
              path = 1,
              status = true,
            },
          },
        },
        inactive_sections = {
          lualine_b = {
            {
              "filename",
              path = 3,
              status = true,
            },
          },
          lualine_x = { "filetype" },
        },
        tabline = {
          lualine_a = { "buffers" },
          -- if you use lualine-lsp-progress, I have mine here instead of fidget
          -- lualine_b = { 'lsp_progress', },
          lualine_z = { "tabs" },
        },
      })
    end,
  },
  {
    "gitsigns.nvim",
    for_cat = "general.always",
    event = "BufEnter",
    after = function(plugin)
      require("gitsigns").setup({
        -- See `:help gitsigns.txt`
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map({ "n", "v" }, "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Jump to next hunk" })

          map({ "n", "v" }, "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Jump to previous hunk" })

          -- Actions
          -- visual mode
          map("v", "<leader>gs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "stage git hunk" })
          map("v", "<leader>gr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "reset git hunk" })
          -- normal mode
          map("n", "<leader>gs", gs.stage_hunk, { desc = "git stage hunk" })
          map("n", "<leader>gr", gs.reset_hunk, { desc = "git reset hunk" })
          map("n", "<leader>gS", gs.stage_buffer, { desc = "git Stage buffer" })
          map(
            "n",
            "<leader>gu",
            gs.undo_stage_hunk,
            { desc = "undo stage hunk" }
          )
          map("n", "<leader>gR", gs.reset_buffer, { desc = "git Reset buffer" })
          map("n", "<leader>gp", gs.preview_hunk, { desc = "preview git hunk" })
          map("n", "<leader>gb", function()
            gs.blame_line({ full = false })
          end, { desc = "git blame line" })
          map(
            "n",
            "<leader>gd",
            gs.diffthis,
            { desc = "git diff against index" }
          )
          map("n", "<leader>gD", function()
            gs.diffthis("~")
          end, { desc = "git diff against last commit" })

          -- Toggles
          map(
            "n",
            "<leader>gtb",
            gs.toggle_current_line_blame,
            { desc = "toggle git blame line" }
          )
          map(
            "n",
            "<leader>gtd",
            gs.toggle_deleted,
            { desc = "toggle git show deleted" }
          )

          -- Text object
          map(
            { "o", "x" },
            "ih",
            ":<C-U>Gitsigns select_hunk<CR>",
            { desc = "select git hunk" }
          )
        end,
      })
      vim.cmd([[hi GitSignsAdd guifg=#04de21]])
      vim.cmd([[hi GitSignsChange guifg=#83fce6]])
      vim.cmd([[hi GitSignsDelete guifg=#fa2525]])
    end,
  },
  {
    "noice.nvim",
    for_cat = "general.extra",
    -- FIXME: This just about works, but fails on first trigger
    -- Copied idea from telescope.lua so not sure why it's broken
    -- on_require = { "noice" },
    event = "DeferredUIEnter",
    keys = {
      {
        "<leader>ns",
        function()
          require("noice").cmd("telescope")
        end,
        mode = { "n" },
        desc = "[N]otification [S]earch",
      },
      {
        "<leader>nh",
        function()
          require("noice").cmd("history")
        end,
        mode = { "n" },
        desc = "[N]otification [H]istory",
      },
      {
        "<leader>nl",
        function()
          require("noice").cmd("last")
        end,
        mode = { "n" },
        desc = "[N]otification [L]ast",
      },
      {
        "<leader>nd",
        function()
          require("noice").cmd("dismiss")
        end,
        mode = { "n" },
        desc = "[N]otification [D]ismiss",
      },
      -- TODO: Is this even important?
      -- {
      --   "<c-f>",
      --   function()
      --     if not require("noice.lsp").scroll(4) then
      --       return "<c-f>"
      --     end
      --   end,
      --   mode = { "n", "i", "s" },
      --   silent = true,
      --   expr = true,
      -- },
      -- {
      --   "<c-b>",
      --   function()
      --     if not require("noice.lsp").scroll(-4) then
      --       return "<c-b>"
      --     end
      --   end,
      --   mode = { "n", "i", "s" },
      --   silent = true,
      --   expr = true,
      -- },
    },
    after = function(plugin)
      -- local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
      -- if client ~= nil and client.name == "Firenvim" then
      --   return
      -- end
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = true, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      })
    end,
  },
  {
    "image.nvim",
    for_cat = "general.extra",
    after = function(plugin)
      require("image").setup({
        processor = "magick_rock",
      })
    end,
  },
  {
    "tiny-glimmer.nvim",
    for_cat = "general.extra",
    event = "BufEnter",
    after = function()
      require("tiny-glimmer").setup({
        overwrite = {
          search = {
            enabled = true,
          },
        },
      })
    end,
  },
}
