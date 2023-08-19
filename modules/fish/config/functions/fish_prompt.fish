# Color reference here: https://github.com/sainnhe/everforest/blob/master/autoload/everforest.vim#L129

source ~/.config/fish/functions/__utils.fish 

function configure_git
  set -g __fish_git_prompt_char_stateseparator ' '
  set -g __fish_git_prompt_color 83c092
  set -g __fish_git_prompt_color_flags d699b6
  set -g __fish_git_prompt_color_prefix white
  set -g __fish_git_prompt_color_suffix white
  set -g __fish_git_prompt_showdirtystate true
  set -g __fish_git_prompt_showuntrackedfiles true
  set -g __fish_git_prompt_showstashstate true

  # Might cause issues in fish v3.2.0
  set -g __fish_git_prompt_show_informative_status true 
end

function create_vcs
  if command git rev-parse --is-inside-work-tree > /dev/null 2>&1
    configure_git
    
    section $argv[1] (__fish_git_prompt '%s')
  else
    echo ""
  end
end

function create_working_dir
  set -g fish_prompt_pwd_dir_length 0

  section $argv[1] (prompt_pwd)
end

function fish_prompt
  set -l normal normal
  set -l white d3c6aa
  set -l green a7c080

  set -l down (color_section $green "┏")
  set -l up (color_section $green "┖")
 
  set -l name (section $green $USER)
  # TODO: battery
  set -l time (section $green (date "+%H:%M:%S"))
  set -l vcs (create_vcs $green) 
  set -l working_dir (create_working_dir $green)
    
  printf "%s%s%s%s\n%s%s" \
    $down \
    $name \
    $time \
    $vcs \
    $working_dir \
    (color_section $green "> ")
end

