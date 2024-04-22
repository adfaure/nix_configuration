vim.loader.enable()

vim.opt.conceallevel = 1

require("obsidian").setup({
  workspaces = {
    {
      name = 'personal',
      path = '~/Vault',
    },
  },

  templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
  },
  disable_frontmatter = false,
  daily_notes = {
    folder = "journal",
    template = "daily.md"
  },
})
