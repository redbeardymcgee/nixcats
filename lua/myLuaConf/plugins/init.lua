local colorschemeName = nixCats("colorscheme")
if not require("nixCatsUtils").isNixCats then
    colorschemeName = "onedark"
end
-- Could I lazy load on colorscheme with lze?
-- sure. But I was going to call vim.cmd.colorscheme() during startup anyway
-- this is just an example, feel free to do a better job!
vim.cmd.colorscheme(colorschemeName)

local ok, notify = pcall(require, "notify")
if ok then
    notify.setup({
        on_open = function(win)
            vim.api.nvim_win_set_config(win, { focusable = false })
        end,
    })
    vim.notify = notify
    vim.keymap.set("n", "<Esc>", function()
        notify.dismiss({ silent = true })
        vim.cmd("nohlsearch")
    end, { desc = "dismiss notify popup and clear hlsearch" })
end

-- NOTE: you can check if you included the category with the thing wherever you want.
if nixCats("general.extra") then
    -- I didnt want to bother with lazy loading this.
    -- I could put it in opt and put it in a spec anyway
    -- and then not set any handlers and it would load at startup,
    -- but why... I guess I could make it load
    -- after the other lze definitions in the next call using priority value?
    -- didnt seem necessary.
    vim.g.loaded_netrwPlugin = 1
    require("oil").setup({
        default_file_explorer = true,
        view_options = {
            show_hidden = true,
        },
        columns = {
            "icon",
            "permissions",
            "size",
            -- "mtime",
        },
        keymaps = {
            ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            ["<C-s>"] = "actions.select_vsplit",
            ["<C-h>"] = "actions.select_split",
            ["<C-t>"] = "actions.select_tab",
            ["<C-p>"] = "actions.preview",
            ["<C-c>"] = "actions.close",
            ["<C-l>"] = "actions.refresh",
            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["`"] = "actions.cd",
            ["~"] = "actions.tcd",
            ["gs"] = "actions.change_sort",
            ["gx"] = "actions.open_external",
            ["g."] = "actions.toggle_hidden",
            ["g\\"] = "actions.toggle_trash",
        },
    })
    vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, desc = "Open Parent Directory" })
    vim.keymap.set("n", "<leader>-", "<cmd>Oil .<CR>", { noremap = true, desc = "Open nvim root directory" })
end

require("lze").load({
    { import = "myLuaConf.plugins.telescope" },
    { import = "myLuaConf.plugins.treesitter" },
    { import = "myLuaConf.plugins.completion" },
    {
        "markdown-preview.nvim",
        -- NOTE: for_cat is a custom handler that just sets enabled value for us,
        -- based on result of nixCats('cat.name') and allows us to set a different default if we wish
        -- it is defined in luaUtils template in lua/nixCatsUtils/lzUtils.lua
        -- you could replace this with enabled = nixCats('cat.name') == true
        -- if you didnt care to set a different default for when not using nix than the default you already set
        for_cat = "markdown",
        cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
        ft = "markdown",
        keys = {
            {
                "<leader>mp",
                "<cmd>MarkdownPreview <CR>",
                mode = { "n" },
                noremap = true,
                desc = "markdown preview",
            },
            {
                "<leader>ms",
                "<cmd>MarkdownPreviewStop <CR>",
                mode = { "n" },
                noremap = true,
                desc = "markdown preview stop",
            },
            {
                "<leader>mt",
                "<cmd>MarkdownPreviewToggle <CR>",
                mode = { "n" },
                noremap = true,
                desc = "markdown preview toggle",
            },
        },
        before = function(plugin)
            vim.g.mkdp_auto_close = 0
        end,
    },
    {
        "image.nvim",
        for_cat = "markdown",
        ft = "markdown",
        after = function(plugin)
            require("image").setup({
                processor = "magick_rock",
            })
        end,
    },
    {
        "render-markdown.nvim",
        for_cat = "markdown",
        ft = "markdown",
        after = function(plugin)
            require("render-markdown").setup({
                completions = { lsp = { enabled = true } },
            })
        end,
    },
    {
        "toggleterm.nvim",
        for_cat = "general.extra",
        event = "DeferredUIEnter",
        keys = {
            {
                "<leader>gg",
                "<cmd>lua _lazygit_toggle()<cr>",
                mode = { "n", "t" },
                desc = "Toggle lazygit",
            },
        },
        after = function(plugin)
            require("toggleterm").setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return math.floor(vim.o.lines * 0.4)
                    elseif term.direction == "vertical" then
                        return math.floor(vim.o.columns * 0.4)
                    end
                end,
                open_mapping = [[<c-\>]],
                direction = "vertical",
                float_opts = {
                    border = "curved",
                    width = math.floor(vim.o.columns * 0.8),
                    height = math.floor(vim.o.lines * 0.8),
                    title_pos = "center",
                },
            })

            function _G.set_terminal_keymaps()
                local opts = { buffer = 0 }
                vim.keymap.set("t", "<A-esc>", [[<C-\><C-n>]], opts)
                -- vim.keymap.set("t", "<A-h>", [[<Cmd>wincmd h<CR>]], opts)
                -- vim.keymap.set("t", "<A-j>", [[<Cmd>wincmd j<CR>]], opts)
                -- vim.keymap.set("t", "<A-k>", [[<Cmd>wincmd k<CR>]], opts)
                -- vim.keymap.set("t", "<A-l>", [[<Cmd>wincmd l<CR>]], opts)
                vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
            end

            -- if you only want these mappings for toggle term use term://*toggleterm#* instead
            vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                hidden = true,
                direction = "float",
            })

            function _lazygit_toggle()
                lazygit:toggle()
            end
        end,
    },
    {
        "undotree",
        for_cat = "general.extra",
        cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeShow", "UndotreeFocus", "UndotreePersistUndo" },
        keys = { { "<leader>U", "<cmd>UndotreeToggle<CR>", mode = { "n" }, desc = "Undo Tree" } },
        before = function(_)
            vim.g.undotree_WindowLayout = 1
            vim.g.undotree_SplitWidth = 40
        end,
    },
    {
        "comment.nvim",
        for_cat = "general.extra",
        event = "BufEnter",
        after = function(plugin)
            require("Comment").setup()
        end,
    },
    {
        "indent-blankline.nvim",
        for_cat = "general.extra",
        event = "BufEnter",
        after = function(plugin)
            require("ibl").setup()
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
        for_cat = "general.always",
        event = "BufEnter",
        after = function(plugin)
            require("nvim-ts-autotag").setup()
        end,
    },
    {
        "nvim-treesitter-endwise",
        for_cat = "general.always",
        event = "BufEnter",
        -- after = function(plugin)
        --     require("nvim-treesitter-endwise").setup()
        -- end,
    },
    {
        "rainbow-delimiters.nvim",
        for_cat = "general.always",
        event = "BufEnter",
        after = function(plugin)
            require("rainbow-delimiters.setup").setup()
        end,
    },
    {
        "vim-startuptime",
        for_cat = "general.extra",
        cmd = { "StartupTime" },
        before = function(_)
            vim.g.startuptime_event_width = 0
            vim.g.startuptime_tries = 10
            vim.g.startuptime_exe_path = nixCats.packageBinPath
        end,
    },
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
        "mini-animate.nvim",
        for_cat = "general.extra",
        event = "DeferredUIEnter",
        -- keys = "",
        after = function(plugin)
            require("mini.animate").setup({})
        end,
    },
    -- {
    --     "mini-align.nvim",
    --     for_cat = "general.extra",
    --     event = "BufEnter",
    --     -- keys = "",
    --     after = function(plugin)
    --         require("mini.align").setup({
    --             mappings = {
    --                 start = "gA",
    --                 start_with_preview = "ga",
    --             },
    --         })
    --     end,
    -- },
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
            local augend = require("dial.augend")
            return require("dial.config").augends:register_group({
                default = {
                    augend.constant.alias.Alpha,
                    augend.constant.alias.alpha,
                    augend.constant.alias.bool,
                    augend.constant.alias.semver,
                    augend.integer.alias.binary,
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.integer.alias.octal,
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
                },
            })
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
        -- cmd = { "" },
        -- ft = "",
        -- keys = "",
        -- colorscheme = "",
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
                    map("v", "<leader>hs", function()
                        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "stage git hunk" })
                    map("v", "<leader>hr", function()
                        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "reset git hunk" })
                    -- normal mode
                    map("n", "<leader>gs", gs.stage_hunk, { desc = "git stage hunk" })
                    map("n", "<leader>gr", gs.reset_hunk, { desc = "git reset hunk" })
                    map("n", "<leader>gS", gs.stage_buffer, { desc = "git Stage buffer" })
                    map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
                    map("n", "<leader>gR", gs.reset_buffer, { desc = "git Reset buffer" })
                    map("n", "<leader>gp", gs.preview_hunk, { desc = "preview git hunk" })
                    map("n", "<leader>gb", function()
                        gs.blame_line({ full = false })
                    end, { desc = "git blame line" })
                    map("n", "<leader>gd", gs.diffthis, { desc = "git diff against index" })
                    map("n", "<leader>gD", function()
                        gs.diffthis("~")
                    end, { desc = "git diff against last commit" })

                    -- Toggles
                    map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
                    map("n", "<leader>gtd", gs.toggle_deleted, { desc = "toggle git show deleted" })

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
                end,
            })
            vim.cmd([[hi GitSignsAdd guifg=#04de21]])
            vim.cmd([[hi GitSignsChange guifg=#83fce6]])
            vim.cmd([[hi GitSignsDelete guifg=#fa2525]])
        end,
    },
    {
        "which-key.nvim",
        for_cat = "general.extra",
        -- cmd = { "" },
        event = "DeferredUIEnter",
        -- ft = "",
        -- keys = "",
        -- colorscheme = "",
        after = function(plugin)
            require("which-key").setup({})
            require("which-key").add({
                { "<leader><leader>", group = "buffer commands" },
                { "<leader><leader>_", hidden = true },
                {
                    "<leader>b",
                    group = "[b]uffers",
                    expand = function()
                        return require("which-key.extras").expand.buf()
                    end,
                },
                { "<leader>b_", hidden = true },
                { "<leader>c", group = "[c]ode" },
                { "<leader>c_", hidden = true },
                { "<leader>d", group = "[d]ocument" },
                { "<leader>d_", hidden = true },
                { "<leader>g", group = "[g]it" },
                { "<leader>g_", hidden = true },
                { "<leader>m", group = "[m]arkdown" },
                { "<leader>m_", hidden = true },
                { "<leader>r", group = "[r]ename" },
                { "<leader>r_", hidden = true },
                { "<leader>s", group = "[s]earch" },
                { "<leader>s_", hidden = true },
                { "<leader>t", group = "[t]oggles" },
                { "<leader>t_", hidden = true },
                { "<leader>W", group = "[W]orkspace" },
                { "<leader>W_", hidden = true },
                { "<leader>x", group = "Debug" },
                { "<leader>x_", hidden = true },
                {
                    "<leader>w",
                    function()
                        return require("which-key").show({
                            keys = "<c-w>",
                            loop = true,
                        })
                    end,
                    group = "[w]indows",
                },
                { "<leader>w_", hidden = true },
            })
        end,
    },
})
