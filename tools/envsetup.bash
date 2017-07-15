if [[ $_ != $0 ]]; then
    export TOP=$(realpath $(dirname ${BASH_SOURCE[@]})/../ )
else
    echo "Error: only for sourcing."
fi

## NOTE import more tools BEGIN
export PATH=$TOP/tools:$TOP/tools/habit:$PATH
## END


# TODO move this out to separate file
#
# Habit Bash acutocompletion
function __ac_habit {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    subcmds=$(habit __ac_tool)

    # 'subcmds' only work immediately after `habit`
    if [[ ${prev} == 'habit' ]] ; then
        COMPREPLY=( $(compgen -W "${subcmds}" -- ${cur}) )
        return 0
    fi
}

complete  -o bashdefault -o default -o nospace -F __ac_habit habit
