if [ -z "${1}" ]; then
    echo "Project directory was not provided" 1>&2
    exit 1
fi

patch_file=$(pwd)/$(basename "${1}").patch
cd ${1}

if [ -d ./.git ]; then
    git diff > ${patch_file}
elif [ -d ./.hg ]; then
    hg export > ${patch_file}
elif [ -d ./.svn ]; then
    cat /dev/null > ${patch_file}
    filepaths=$(svn diff | lsdiff | LC_ALL=C sort)
    for filepath in ${filepaths}
    do
        echo "Index: ${filepath}" >> ${patch_file}
        echo "===================================================================" >> ${patch_file}
        svn diff --extensions --ignore-eol-style | filterdiff -i ${filepath} >> ${patch_file}
    done
else
    echo "Skipping diff, \"${1}\" is not under git/hg/svn version control"
fi

if [ -d ./.git ]; then
    patch --dry-run --forward --strip=1 --input=${patch_file}
elif [ -d ./.hg ]; then
    patch --dry-run --forward --strip=1 --input=${patch_file}
elif [ -d ./.svn ]; then
    patch --dry-run --forward --strip=0 --input=${patch_file}
else
    patch --dry-run --forward --input=${patch_file}
fi
