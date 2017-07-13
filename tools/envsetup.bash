if [[ $_ != $0 ]]; then
    export TOP=$(realpath $(dirname ${BASH_SOURCE[@]})/../ )
else
    echo "Error: only for sourcing."
fi

## NOTE import more tools BEGIN
export PATH=$TOP/tools:$TOP/tools/habit:$PATH
## END
