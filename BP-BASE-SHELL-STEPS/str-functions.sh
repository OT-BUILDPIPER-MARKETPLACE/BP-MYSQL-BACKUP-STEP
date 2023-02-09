function isStrNonEmpty() {
    STR=$1
    if [ -z "$STR" ]; then
        echo 1
    else
        echo 0
    fi
}