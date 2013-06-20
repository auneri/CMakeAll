if [ -z "${1}" ]; then
    echo "ERROR! project source directory was not provided"
    exit 1
fi

patch_file=$(pwd)/$(basename "${1}").patch
cd ${1}

if [ -d ./.svn ]; then
    cat /dev/null > ${patch_file}
    filepaths=$(svn diff | lsdiff | LC_ALL=C sort)
    for filepath in ${filepaths}
    do
        echo "Index: ${filepath}" >> ${patch_file}
        echo "===================================================================" >> ${patch_file}
        svn diff --extensions --ignore-eol-style | filterdiff -i ${filepath} >> ${patch_file}
    done
elif [ -d ./.git ]; then
    git diff --no-prefix > ${patch_file}
else
    echo "ERROR! source directory \"${1}\" is not under svn/git control"
    exit 1
fi

patch --dry-run --strip 0 --forward --fuzz 1 --input ${patch_file}
