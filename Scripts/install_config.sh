#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "${script_dir}/.." && pwd)"
config_source="${repo_dir}/config"
config_destination="${HOME}/.config"
nixos_source="${repo_dir}/nixos_config"
nixos_destination="/etc/nixos"
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
	printf 'Error: config directory does not exist: %s\n' "${config_source}" >&2
	exit 1
fi

if [[ ! -d "${nixos_source}" ]]; then
	printf 'Error: NixOS config directory does not exist: %s\n' "${nixos_source}" >&2
	exit 1
fi

source "${script_dir}/config_directories.sh"

rsync_options=(--archive --verbose --human-readable)
if [[ "${dry_run}" == true ]]; then
	rsync_options+=(--dry-run)
fi

printf 'Installing NixOS configuration...\n'
sudo rsync "${rsync_options[@]}" "${nixos_source}/" "${nixos_destination}/"

if [[ "${dry_run}" == false ]]; then
	mkdir -p "${config_destination}"
fi

for directory in "${config_directories[@]}"; do
	source="${config_source}/${directory}"

	if [[ ! -e "${source}" ]]; then
		printf 'Skipping missing repository config: %s\n' "${source}"
		continue
	fi

	if [[ "${directory}" == walker && -f "${config_destination}/${directory}" ]]; then
		printf 'Error: %s is a file. Move it to %s/config.toml before installing the Walker theme.\n' \
			"${config_destination}/${directory}" "${config_destination}/${directory}" >&2
		exit 1
	fi

	if [[ -d "${source}" ]]; then
		destination="${config_destination}/${directory}/"
		if [[ "${dry_run}" == false ]]; then
			mkdir -p "${destination}"
		fi
		rsync "${rsync_options[@]}" "${source}/" "${destination}"
	else
		rsync "${rsync_options[@]}" "${source}" "${config_destination}"
	fi

	printf 'Installed %s...\n' "${directory}"
done

if [[ "${dry_run}" == true ]]; then
	printf '%s\n' 'Dry run complete; no files were changed.'
else
	printf 'Configuration installation complete: %s\n' "${config_destination}"
fi
