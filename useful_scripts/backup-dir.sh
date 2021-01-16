#!/bin/sh -eu
# A script to backup a directory

usage() {
    cat << EOF
Usage: $(basename "$0") [-d directory]
Where:
    -d      The directory to backup.
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
# For example, if the directory is "example" the backup file will look like the following
# example_Backup-12K-20210116-173838.tar.xz
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

while getopts "d:h" opt; do
    case "${opt}" in
        d)
            directory=${OPTARG}
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

# The directory is a mandatory argument
if [ -z "${directory}" ] ; then
    print_error_exit "The [-d directory] is required."
fi

# Check if the directory exists
if [ ! -d "${directory}" ] ; then
    print_error_exit "The directory ${directory} does not exist."
fi

# If the directory is eg /tmp/example/, we need only the "example"
get_basename_of_directory=$(basename "${directory}")

backup_dir "${get_basename_of_directory}"
