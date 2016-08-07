# TODO much of the following are used often. Factored out into a library.
set TOP (realpath (dirname (status -f))/../)

function ctop -d 'cd back to top directory'
  cd $TOP
end

# TODO better posting environment by setting various env vars like current post and etc.
function jekyll
  docker run -it --rm -v $TOP:/srv/jekyll carltonf/jekyll-toolbox:latest jekyll $argv
end
