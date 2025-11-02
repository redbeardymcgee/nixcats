require("dashboard").setup({
  theme = "hyper", -- "doom"
  shortcut_type = "letter",
  change_to_vcs_root = true,
  config = {
    week_header = {
      enable = true,
    },
    shortcut = {
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Files',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f',
      },
    },
  },
})
