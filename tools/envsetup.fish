set TOP (realpath (dirname (status -f))/../)

function __jekyll -d 'the real jekyll docker runner'
  docker run -it --rm -v $TOP:/srv/jekyll carltonf/jekyll-toolbox:latest jekyll $argv
end

# NOTE the following functions also have some enhancement to jekyll cli
function jekyll -d 'enhanced jekyll'
  set argv_len (count $argv)

  switch "$argv_len"
    case "0"
      set cmd ''
      set rest_argv ''
    case "1"
      set cmd $argv[1]
      set rest_argv ''
    case '*'
      set cmd $argv[1]
      set rest_argv $argv[2..-1]
  end

  # NOTE remove 'edit'. string sub starts from 1 (instead of 0)
  switch $cmd
    case edit
      jekyll-edit $rest_argv
    case draft
      jekyll-draft $rest_argv
    case publish
      jekyll-publish $rest_argv
    case '*'
      __jekyll $argv
  end
end

# NOTE path to the working post. Keep it absolute
set jekyll_working_post ''
function __envsetup_set_cwp -d 'set cwp'
  echo "* INFO: set CWP to $argv"
  set jekyll_working_post (realpath $argv)
end

function jekyll-edit -d 'edit cwp, optionally set cwp'
  set argv_len (count $argv)
  # NOTE: the first arg should be option to select editor, default to vi.
  switch $argv_len
    case 0
      set editor vi
      set post ''
    case 1
      set editor $argv[1]
      set post ''
    case '*'
      set editor $argv[1]
      set post $argv[2]
  end

  switch $editor
    case '-v'
      set editor vi
    case '-e'
      set editor ecn
    case '*'
      echo "* WARNING: unrecognised editor setting. Fall back to vi"
      set editor vi
  end

  if [ -z "$post" ]
    if [ -z "jekyll_working_post" ]
      echo "* Error: current working post is not set."
      return
    else
      set post $jekyll_working_post
    end
  else
    __envsetup_set_cwp $post
  end

  eval $editor $jekyll_working_post
end

# NOTE due to the nature of draft command, the following only deals with the
# most common situation:
# 1. Title has no special chars other than whitespace (no tab)
# 2. The draft format will always be in '.md'
# 3. No other draft options are given (use __jekyll instead)
function jekyll-draft -d 'enhance draft (alpha)'
  set title "$argv[-1]"
  set filename (string replace -a ' ' '-' "$title")'.md'
  set path '_drafts/'$filename

  __envsetup_set_cwp $path
  # NOTE always offer the title as draft is not that smart
  __jekyll draft "$title"
end

function jekyll-publish -d 'enhance publish'
  __envsetup_set_cwp $argv
  __jekyll publish $argv
end
