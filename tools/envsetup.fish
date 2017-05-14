set TOP (realpath (dirname (status -f))/../)

## NOTE import habit tool
set -l habit_path $TOP/tools/habit
source "$habit_path/envsetup.fish"
## end

## Wrapper around dockerized-jekyll
# NOTE the followings are mostly from `envsetup-legacy.fish`
function __jekyll -d 'the real jekyll docker runner'
  docker run -it --rm -v $TOP:/srv/jekyll carltonf/jekyll-toolbox:20160808 jekyll $argv
end

# NOTE the following functions also have some enhancement to jekyll cli
function jekyll -d 'enhanced jekyll'
  __jekyll $argv
end

## jekyll ac
function __fish_jekyll_no_subcommand -d 'Test if jekyll has sub command'
  # TODO can be further simplifed
  for i in (commandline -opc)
    if contains -- $i edit draft publish unpublish
      return 1
    end
  end
  return 0
end

complete -e -c jekyll
# draft needs no file completion
complete -c jekyll -f -n '__fish_jekyll_no_subcommand' -a draft -d 'Jekyll Cmd'
# NOTE: I've found no good way to stop file completions shown without offering at least one candidate
complete -c jekyll -A -f -n '__fish_seen_subcommand_from draft' -a 'title'
for cmd in publish unpublish
  complete -c jekyll -f -n '__fish_jekyll_no_subcommand' -a $cmd -d 'Jekyll Cmd'
end
