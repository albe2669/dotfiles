_: {
  flake.modules.homeManager.worktree = _: {
    programs.fish.shellInit = ''
      # $argv[1] = worktree path, $argv[2..] = files to copy
      function __worktree_copy_files
        set path $argv[1]
        for file in $argv[2..]
          if test -f $file
            mkdir -p $path/(dirname $file)
            cp $file $path/$file
          end
        end
      end

      function __worktree_launch
        set path $argv[1]
        set tool $argv[2]
        set branch $argv[3]
        echo "Worktree for branch $branch created at $path"
        echo "Starting $tool in $path..."
        cd $path
        $tool
      end

      # $argv[1] = tool, $argv[2] = copy-file list, $argv[3] = branch, $argv[4] = base (optional)
      function __worktree_create_new
        set tool $argv[1]
        set files $argv[2]
        set branch $argv[3]
        set base "main"
        if test (count $argv) -ge 4
          set base $argv[4]
        end

        if not git rev-parse --verify $base > /dev/null 2>&1
          echo "Base branch $base does not exist."
          return 1
        end

        set path "./.worktrees/$branch"
        if git rev-parse --verify $branch > /dev/null 2>&1
          echo "Branch $branch already exists. Please choose a different name."
          return 1
        end
        git worktree add -b $branch $path $base
        __worktree_copy_files $path $files
        __worktree_launch $path $tool $branch
      end

      # $argv[1] = tool, $argv[2] = copy-file list, $argv[3] = existing branch
      function __worktree_checkout
        set tool $argv[1]
        set files $argv[2]
        set branch $argv[3]
        set basepath "./.worktrees"
        set path "$basepath/$branch"
        mkdir -p $basepath
        if not git rev-parse --verify $branch > /dev/null 2>&1
          echo "Branch $branch does not exist. Please choose an existing branch."
          return 1
        end
        git worktree add --checkout $path $branch
        __worktree_copy_files $path $files
        __worktree_launch $path $tool $branch
      end
    '';
  };
}
