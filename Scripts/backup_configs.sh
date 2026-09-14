#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "${script_dir}/.." && pwd)"
config_source="${HOME}/.config"
config_destination="${repo_dir}/config/"
nixos_source="/etc/nixos/"
nixos_destination="${repo_dir}/nixos_config/"
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

if [[ ! -d "${nixos_source}" ]]; then
	printf 'Error: NixOS config directory does not exist: %s\n' "${nixos_source}" >&2
	exit 1
fi

source "${script_dir}/config_directories.sh"

rsync_options=(--archive --copy-links --verbose --human-readable --delete)
if [[ "${dry_run}" == true ]]; then
	rsync_options+=(--dry-run)
fi

if [[ "${dry_run}" == false ]]; then
	mkdir -p "${nixos_destination}"
fi

printf 'Backing up NixOS configuration...\n'
sudo rsync "${rsync_options[@]}" "${nixos_source}" "${nixos_destination}"

if [[ "${dry_run}" == false ]]; then
	mkdir -p "${config_destination}"
fi

for directory in "${config_directories[@]}"; do
	source="${config_source}/${directory}"

	if [[ ! -e "${source}" ]]; then
		printf 'Skipping missing config directory: %s\n' "${source}"
		continue
	fi

	if [[ "${directory}" == walker && -f "${source}" ]]; then
		destination="${config_destination}/${directory}"
		if [[ "${dry_run}" == false ]]; then
			mkdir -p "${destination}"
		fi
		rsync "${rsync_options[@]}" "${source}" "${destination}/config.toml"
	elif [[ -d "${source}" ]]; then
		destination="${config_destination}/${directory}/"
		if [[ "${dry_run}" == false ]]; then
			mkdir -p "${destination}"
		fi
		rsync "${rsync_options[@]}" "${source}/" "${destination}"
	else
		rsync "${rsync_options[@]}" "${source}" "${config_destination}"
	fi

	printf 'Backed up %s...\n' "${directory}"
done

if [[ "${dry_run}" == true ]]; then
	printf '%s\n' 'Dry run complete; no files were changed.'
else
	printf 'Configuration backup complete: %s\n' "${repo_dir}"
fi
