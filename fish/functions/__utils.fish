function color_section
  printf "%s%s%s" \
      (set_color "$argv[1]") \
      $argv[2..-1] \
      (set_color normal)
end

function section
  set -l color "$argv[1]"

  printf "%s%s%s" \
    (color_section $color "[") \
    $argv[2..-1] \
    (color_section $color "]")
end

