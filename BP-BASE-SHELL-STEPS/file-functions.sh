function isFileExist() {
    FILEPATH=$1

    if [ -f "$FILEPATH" ]; then
        echo 0
    else
        echo 1
    fi
}