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
    case '*'
      __jekyll $argv
  end
end

# NOTE path to the working post. Keep it absolute.
#
# NOTE Also export it s.t. child processes have access to it.
set -x jekyll_working_post ''
function __fish_jekyll_cwp -d 'set cwp'
  set post $argv
  set path ''
  if [ -e $post ]
    set path (realpath $post)
  else
    # NOTE try to be smart about $post
    set path __fish_jekyll_find_post $post
  end

  if [ -n $path ]
    echo "* INFO: set CWP to $post"
    set jekyll_working_post $path
  else
    echo "* Error: no post with name '$post'"
    return 1
  end
end

function __fish_jekyll_find_post -d 'search post path with post name'
  set found (find $TOP/_drafts $TOP/_posts $TOP/_wiki -path "*$argv" | head -1)
  # NOTE: Remember to quote, as $found is empty and '[ -n ]' return true. WTF...
  if [ -n "$found" ]
    realpath $found
  else
    echo ''
  end
end


function jekyll-edit -d 'edit cwp, optionally set cwp'
  set editor vi
  set editor_opt ''
  set post ''

  # NOTE looping through argv may be the best native way of handling args
  # see: http://stackoverflow.com/a/14203146/2526378
  for arg in $argv
    switch $arg
      case '-v'
        set editor vi
      case '-e'
        set editor ecn
      case '*'
        set post (__fish_jekyll_find_post $arg)
        if [ -n $post ]
          break
        end
    end
  end

  if [ -z "$post" ]
    if [ -z "$jekyll_working_post" ]
      echo "* Error: current working post is not set."
      return
    else
      if [ ! -f "$jekyll_working_post" ]
        echo "* Error: $jekyll_working_post no longer exists."
        return
      end
      set post $jekyll_working_post
    end
  else
    __fish_jekyll_cwp $post
  end

  eval $editor $jekyll_working_post
end

# NOTE this may be learned from __fish_contains_opt
function __fish_jekyll_no_subcommand -d 'Test if jekyll has sub command'
  # TODO can be further simplifed
  for i in (commandline -opc)
    if contains -- $i edit draft publish unpublish
      return 1
    end
  end
  return 0
end

function __fish_jekyll_list_recent_drafts -d 'List the TWO most recent files from _drafts and _posts/'
  set draft_files $TOP/_drafts/*.md
  set post_files $TOP/_posts/*.md $TOP/_posts/*.html
  set files ''
  switch $argv
    case drafts
      set files $draft_files
    case posts
      set files $post_files
    case all
      set files $draft_files $post_files
    case '*'
      # NOTE just empty string
      return ''
  end

  # NOTE I'm using '-P' here, an experimental feature to use '\K' switch. Use
  # '-E' extended regexp to have easier reg and 'sed' is also an option.
  #
  # '-Q' can be supplied to ls to have file name quoted, which makes the output
  # uglier. Quotes should not be necessary as no whitespace is allowed in both
  # drafts and posts file names
  ls -t $files | grep -m 7 -oP "$TOP/\K.*(md|html)\$"
end

# NOTE: much learned from https://github.com/docker/docker/blob/master/contrib/completion/fish/docker.fish
complete -e -c jekyll
# extras (maybe better to fall back to autocomplete wrapper)
for cmd in edit publish unpublish
  complete -c jekyll -f -n '__fish_jekyll_no_subcommand' -a $cmd -d 'Jekyll Cmd'
  # NOTE use '-a' for 'edit' in case we want edit some older files. Remember to neglect condition '-a' in the default completions and omit '-f' for '-a'
  complete -c jekyll -A -f -n "__fish_seen_subcommand_from $cmd" -s a -d 'toggle all files'
  complete -c jekyll -A -n "__fish_seen_subcommand_from $cmd; and __fish_contains_opt -s a"
end
# draft needs no file completion
complete -c jekyll -f -n '__fish_jekyll_no_subcommand' -a draft -d 'Jekyll Cmd'
# NOTE: I've found no good way to stop file completions shown without offering at least one candidate
complete -c jekyll -A -f -n '__fish_seen_subcommand_from draft' -a 'title'

# Edit: more options
complete -c jekyll -A -f -n '__fish_seen_subcommand_from edit' -s v -d 'Edit with vi (default)'
complete -c jekyll -A -f -n '__fish_seen_subcommand_from edit' -s e -d 'Edit with emacsclient -nc'

# recent completions
# NOTE publish unpublish seems to only work
complete -c jekyll -A -f -n "__fish_seen_subcommand_from edit; and not __fish_contains_opt -s a" -a '(__fish_jekyll_list_recent_drafts all)' -d 'recent'
complete -c jekyll -A -f -n "__fish_seen_subcommand_from publish; and not __fish_contains_opt -s a" -a '(__fish_jekyll_list_recent_drafts drafts)' -d 'recent'
complete -c jekyll -A -f -n "__fish_seen_subcommand_from unpublish; and not __fish_contains_opt -s a" -a '(__fish_jekyll_list_recent_drafts posts)' -d 'recent'
