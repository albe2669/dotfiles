function color_section
    printf "%s%s%s" \
      (set_color CB4B16) \
      $argv \
      (set_color normal)
end

function section
  printf "%s%s%s" \
    (color_section "[") \
    $argv \
    (color_section "]")
end

function create_vcs
  set branch (echo (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'))
  section $branch
end

function create_working_dir
  set -g fish_prompt_pwd_dir_length 0

  section (prompt_pwd)
end

function fish_prompt
  set down (color_section "┏")
  set up (color_section "┖")

  set name (section $USER)
  # TODO: battery
  set time (section (date "+%H:%M:%S"))
  set vcs (create_vcs) 
  set working_dir (create_working_dir)
   
  printf "%s%s%s%s\n%s%s" \
    $down \
    $name \
    $time \
    $vcs \
    $working_dir \
    (color_section "> ")
end
