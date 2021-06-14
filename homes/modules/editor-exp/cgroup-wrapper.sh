# Assert that FILE exists and is executable
#
# assertExecutable FILE
assertExecutable() {
    local file="$1"
    [[ -f "$file" && -x "$file" ]] || \
        die "Cannot wrap '$file' because it is not an executable file"
}

# construct an executable file that wraps the actual executable
# makeWrapper EXECUTABLE OUT_PATH ARGS

# ARGS:
# --argv0       NAME    : set name of executed process to NAME
#                         (otherwise it’s called …-wrapped)
# --set         VAR VAL : add VAR with value VAL to the executable’s
#                         environment
# --set-default VAR VAL : like --set, but only adds VAR if not already set in
#                         the environment
# --unset       VAR     : remove VAR from the environment
# --run         COMMAND : run command before the executable
# --add-flags   FLAGS   : add FLAGS to invocation of executable

# --prefix          ENV SEP VAL   : suffix/prefix ENV with VAL, separated by SEP
# --suffix
# --suffix-each     ENV SEP VALS  : like --suffix, but VALS is a list
# --prefix-contents ENV SEP FILES : like --suffix-each, but contents of FILES
#                                   are read first and used as VALS
# --suffix-contents
makeWrapper() {
    set -x
    local original="$1"
    local wrapper="$2"
    local params varName value command separator n fileNames
    local argv0 flagsBefore flags
    cgroupname=$(basename $wrapper)

    assertExecutable "$original"

    mkdir -p "$(dirname "$wrapper")"

    echo "#! @shell@ -e" > "$wrapper"

    echo exec -a systemd-run --slice=exp-${cgroupname}.slice --scope -p \"Delegate=yes\" \""$original"\" '"$@"' >> "$wrapper"
    chmod +x "$wrapper"
}

# Syntax: wrapProgram <PROGRAM> <MAKE-WRAPPER FLAGS...>
wrapProgram() {
    local prog="$1"
    local hidden

    assertExecutable "$prog"

    hidden="$(dirname "$prog")/.$(basename "$prog")"-wrapped
    while [ -e "$hidden" ]; do
      hidden="${hidden}_"
    done
    mv "$prog" "$hidden"
    # Silence warning about unexpanded $0:
    # shellcheck disable=SC2016
    makeWrapper "$hidden" "$prog" --argv0 '$0' "${@:2}"
}