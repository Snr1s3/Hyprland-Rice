#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "${script_dir}/.." && pwd)"
config_source="${HOME}/.config"
config_destination="${repo_dir}/config/"
dry_run=false

if [[ "${1:-}" == "--dry-run" ]]; then
	dry_run=true
elif [[ $# -gt 0 ]]; then
	printf 'Usage: %s [--dry-run]\n' "${0}" >&2
	exit 2
fi

if ! command -v rsync >/dev/null 2>&1; then
	printf '%s\n' "Error: rsync is required but is not installed." >&2
	exit 1
fi

if [[ ! -d "${config_source}" ]]; then
	printf 'Error: source directory does not exist: %s\n' "${config_source}" >&2
	exit 1
fi

config_directories=(
	environment.d
	fastfetch
	fontconfig
	foot
	gtk-3.0
	gtk-4.0
	hypr
	tofi
	waybar
)

rsync_options=(--archive --copy-links --verbose --human-readable --delete)
if [[ "${dry_run}" == true ]]; then
	rsync_options+=(--dry-run)
fi

mkdir -p "${config_destination}"

for directory in "${config_directories[@]}"; do
	source="${config_source}/${directory}/"
	destination="${config_destination}/${directory}/"

	if [[ ! -d "${source}" ]]; then
		printf 'Skipping missing config directory: %s\n' "${source}"
		continue
	fi

	mkdir -p "${destination}"
	printf 'Backing up %s...\n' "${directory}"
	rsync "${rsync_options[@]}" "${source}" "${destination}"
done

if [[ "${dry_run}" == true ]]; then
	printf '%s\n' 'Dry run complete; no files were changed.'
else
	printf 'Configuration backup complete: %s\n' "${repo_dir}"
fi
