local u = require('utils')

-- Configuration
local getConfig = function(location)
  return {
    home                = location,
    take_over_my_home   = true,
    dailies             = location,
    weeklies            = location,
    templates           = location .. '/templates',
    template_new_note   = location .. '/templates/new_note.md',
    template_new_daily  = location .. '/templates/daily.md',
    template_new_weekly = location .. '/templates/weekly.md',

    auto_set_filetype           = true,
    image_subdir                = "img",
    extension                   = ".md",
    new_note_filename           = "title",
    uuid_type                   = "%Y%m%d%H%M",
    uuid_sep                    = "-",
    follow_creates_nonexisting  = true,
    dailies_create_nonexisting  = true,
    weeklies_create_nonexisting = true,
    journal_auto_open           = false,
    image_link_style            = "markdown",
    sort                        = "filename",
    plug_into_calendar          = false,
    calendar_opts               = {
      weeknm = 4,
      calendar_monday = 1,
      calendar_mark = 'left-fit',
    },
    close_after_yanking         = false,
    insert_after_inserting      = true,
    tag_notation                = "yaml-bare",
    command_palette_theme       = "dropdown",
    show_tags_theme             = "ivy",
    subdirs_in_links            = true,
    template_handling           = "prefer_new_note",
    new_note_location           = "same_as_current",
    rename_update_links         = true,
    media_previewer             = "telescope-media-files",
  }
end

local baseHome = vim.fn.expand('~')
local uniHome = baseHome .. '/Documents/Uni/'

local telekastenConfig = getConfig(baseHome .. '/Documents/Zettelkasten')
telekastenConfig.vaults = {
  bosc = getConfig(uniHome .. '/semester-5/BOSC/notes')
}

print(vim.inspect(telekastenConfig))
require('telekasten').setup(telekastenConfig)

-- Commands
u.rq_cmd("NewNote", "telekasten", "new_note()")
u.rq_cmd("FindNotes", "telekasten", "find_notes()")
u.rq_cmd("SearchNotes", "telekasten", "search_notes()")
u.rq_cmd("FollowLink", "telekasten", "follow_link()")
u.rq_cmd("TelekastenPanel", "telekasten", "panel()")

-- Keymaps
u.nmap("<leader>z", "<cmd>TelekastenPanel<cr>")
u.nmap("<leader>zn", "<cmd>NewNote<cr>")
u.nmap("<leader>zf", "<cmd>FindNotes<cr>")
u.nmap("<leader>zg", "<cmd>SearchNotes<cr>")
u.nmap("<leader>zz", "<cmd>FollowLink<cr>")
