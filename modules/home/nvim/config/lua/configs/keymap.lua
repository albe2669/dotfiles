local u = require("utils")

-- Insert blank line below
u.nmap("<Enter>", "o<ESC>") -- For some odd reason this does not work
-- Insert blank line above
u.nmap("<S-Enter>", "O<ESC>")

-- gw : Swap word with next word
u.nmap("gw", ":s/\\(\\%#\\w\\+\\)\\(\\_W\\+\\)\\(\\w\\+\\)/\\3\\2\\1/<cr><c-o><c-l>")
