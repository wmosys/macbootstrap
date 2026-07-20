# Lazyload Function

## Setup a mock function for lazyload
## Usage:
## 1. Define function "_mosy_lazyload_command_[command name]" that will init the command
## 2. mosy_lazyload_add_command [command name]
function mosy_lazyload_add_command() {
    eval "$1() { \
        unfunction $1; \
        _mosy_lazyload_command_$1; \
        $1 \$@; \
    }"
}
## Setup autocompletion for lazyload
## Usage:
## 1. Define function "_mosy_lazyload_completion_[command name]" that will init the autocompletion
## 2. mosy_lazyload_add_comp [command name]
function mosy_lazyload_add_completion() {
    local comp_name="_mosy_lazyload__compfunc_$1"
    eval "${comp_name}() { \
        compdef -d $1; \
        _mosy_lazyload_completion_$1; \
    }"
    compdef $comp_name $1
}