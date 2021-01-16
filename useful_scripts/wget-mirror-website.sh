#!/bin/sh -eu
# A script to mirror a website using wget

usage() {
    cat << EOF
Usage: $(basename "$0") [-w website] [-u user_agent] [-b]
Where:
    -w      The website to mirror. The website will be like "https://example.com/"
    -u      The User agent to use. If no User agent is specified,
            a Firefox default one is used.
    -b      Backup the website. If it's not added, it will not backedup.
    -h      This help

EOF
}

# Print the error, the usage and exit
#
# $1: The error to print
print_error_exit() {
    error_print="${1}"

    echo "${error_print}"
    usage
    exit 1
}

# Backup a directory
#
# The format of the backup file will be
# "Directory name to backup"_Backup-"The size of the directory"-"Current date in format %Y%m%d-%H%M%S".tar.xz
# For example, if the directory is "example.com" the backup file will look like the following
# example.com_Backup-12K-20210116-173838.tar.xz
#
# $1: The directory to backup
backup_dir() {
    directory_to_backup="${1}"

    # The time is in UTC/GMT
    current_date=$(date -u +%Y%m%d-%H%M%S)
    # The size of the directory before compressed
    dir_size=$(du -sh "${directory_to_backup}" | cut -f 1)

    filename_of_backup_dir="${directory_to_backup}_Backup-${dir_size}-${current_date}.tar"

    # Create back up tar file of the dir
    tar cvf "${filename_of_backup_dir}" "${directory_to_backup}"

    # Compress tar file
    xz "${filename_of_backup_dir}"
}

# Check if wget is present in the system
IS_WGET_INSTALLED="$(command -v wget)"
if [ -z "${IS_WGET_INSTALLED}" ] ; then
    print_error_exit "wget command is missing!!!"
fi

while getopts "w:u:bh" opt; do
    case "${opt}" in
        w)
            website=${OPTARG}
            ;;
        u)
            user_agent=${OPTARG}
            ;;
        b)
            backup_dir=1
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

# Check if any options are used
if [ ${OPTIND} = 1 ] ; then
    print_error_exit "No options specified!"
fi

# The website is a mandatory argument
if [ -z "${website}" ] ; then
    print_error_exit "The [-w website] is required."
fi

# The user_agent is a *NOT* mandatory argument
if [ -z "${user_agent}" ] ; then
    user_agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"
fi


website_host=$(echo "$website" | cut -d / -f 3)

# The main wget command
wget \
    --debug \
    --mirror \
    --timestamping \
    --convert-links \
    --backup-converted \
    --adjust-extension \
    --page-requisites \
    --wait 30 \
    --random-wait \
    --continue \
    --limit-rate=2k \
    --no-if-modified-since \
    --append-output="${website_host}.log" \
    --rejected-log="${website_host}-rejected.log" \
    --user-agent="${user_agent}" \
    --directory-prefix="${website_host}/" \
    "${website}"

# Backuo the directory of mirrored website if backup is enabled
if [ -n "${backup_dir}" ] ; then
    backup_dir "${website_host}"
fi

