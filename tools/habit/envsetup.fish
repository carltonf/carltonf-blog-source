# habit's envsetup support script
#
# source this file in the project envsetup.fish

# NOTE env used by `habit`
set -x habit_working_post ''

# TODO: get rid of those `-` commands and unify them under `habit`.
function habit-cwp -d 'get/set cwp'
  if [ z"$argv" = z ]
    echo "*INFO: cwp is $post"
    return
  end
  # NOTE set post
  set post $argv
  set path ''
  if [ -e $post ]
    set path (realpath $post)
  else
    # NOTE try to be smart about $post
    set path __fish_habit_find_post $post
  end

  if [ -n $path ]
    echo "* INFO: set CWP to $post"
    set habit_working_post $path
  else
    echo "* Error: no post with name '$post'"
    return 1
  end

  # NOTE make sure CWP is known to Git
  git add $habit_working_post
end

function __fish_habit_find_post -d 'search post path with post name'
  set found (find $TOP/_drafts $TOP/_posts $TOP/_wiki -path "*$argv" | head -1)
  # NOTE: Remember to quote, as $found is empty and '[ -n ]' return true. WTF...
  if [ -n "$found" ]
    realpath $found
  else
    echo ''
  end
end

source (dirname (status -f))'/ac.fish'
