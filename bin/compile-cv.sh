#!/bin/sh

die() {
	# Print an error message to stderr and exit with status 1.
	printf "%s\n" "$1" >&2
	exit 1
}

usage() {
	# Display usage information.
	printf "Usage: %s --src=DIR --input=FILE --output=FILE\n" "${0##*/}" >&2
}

parse_args() {
	# Parse command-line arguments and set corresponding variables.
	for arg in "${@}"; do
		case "${arg}" in
		--src=*)
			SRC="${arg#*=}"
			;;
		--input=*)
			INPUT="${arg#*=}"
			;;
		--output=*)
			OUTPUT="${arg#*=}"
			;;
		--help | -h)
			usage
			exit 0
			;;
		*)
			usage
			die "Error: Unknown option: ${arg}"
			;;
		esac
	done
}

validate_args() {
	# Ensure that all required arguments have been provided.
	[ -z "${SRC}" ] || [ -z "${INPUT}" ] || [ -z "${OUTPUT}" ] && {
		usage
		die "Error: Missing required arguments."
	}
}

compile_typst() {
	# Execute the typst compile command with the provided arguments.

	# Adjust INPUT to be relative to SRC if it's not an absolute path.
	case "${INPUT}" in
		/*) INPUT_PATH="${INPUT}" ;;        # Absolute path; use as is.
		*) INPUT_PATH="${SRC}/${INPUT}" ;;  # Relative path; prepend SRC.
	esac

	! typst compile --root="${SRC}" "${INPUT_PATH}" "${OUTPUT}" &&
		die "Error: typst compile failed."
}

main() {
	parse_args "${@}"
	validate_args
	compile_typst
}

main "${@}"

exit 0
