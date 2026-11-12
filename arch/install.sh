#!/usr/bin/env bash
set -Eeuo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
config_root="$repo_root/nix_config/app-configs"
user_name=${SUDO_USER:-${USER}}
user_home=$(getent passwd "$user_name" | cut -d: -f6)

if [[ -z "$user_home" ]]; then
  printf 'Could not determine the home directory for %s.\n' "$user_name" >&2
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  exec sudo -- "$0" "$@"
fi

mapfile -t packages < <(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$repo_root/arch/packages.txt")
pacman -Syu --needed "${packages[@]}"

mapfile -t aur_packages < <(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$repo_root/arch/aur-packages.txt")
if command -v paru >/dev/null 2>&1; then
  runuser -u "$user_name" -- env HOME="$user_home" paru -S --needed "${aur_packages[@]}"
else
  printf 'paru is not installed; install these AUR packages separately: %s\n' "${aur_packages[*]}"
fi

systemctl enable --now NetworkManager
systemctl enable --now bluetooth
systemctl enable --now docker
systemctl enable --now sddm
systemctl enable --now sshd

usermod -aG docker "$user_name"

run_as_user() {
  runuser -u "$user_name" -- env HOME="$user_home" XDG_CONFIG_HOME="$user_home/.config" "$@"
}

backup_path() {
  local path=$1
  if [[ -e "$path" || -L "$path" ]]; then
    mv -- "$path" "$path.arch-backup.$(date +%Y%m%d-%H%M%S)"
  fi
}

link_config() {
  local name=$1
  local source="$config_root/$name"
  local target="$user_home/.config/$name"

  [[ -e "$source" ]] || { printf 'Missing config source: %s\n' "$source" >&2; exit 1; }
  backup_path "$target"
  ln -s "$source" "$target"
  chown -h "$user_name:$user_name" "$target"
}

run_as_user mkdir -p "$user_home/.config" "$user_home/.config/environment.d"
for config_name in hypr quickshell foot tofi walker fastfetch; do
  link_config "$config_name"
done

backup_path "$user_home/.config/gtk-3.0/settings.ini"
backup_path "$user_home/.config/gtk-4.0/settings.ini"
run_as_user mkdir -p "$user_home/.config/gtk-3.0" "$user_home/.config/gtk-4.0"
run_as_user ln -s "$repo_root/arch/gtk-settings.ini" "$user_home/.config/gtk-3.0/settings.ini"
run_as_user ln -s "$repo_root/arch/gtk-settings.ini" "$user_home/.config/gtk-4.0/settings.ini"
run_as_user ln -s "$repo_root/arch/environment.d/90-hyprland-rice.conf" \
  "$user_home/.config/environment.d/90-hyprland-rice.conf"

bashrc="$user_home/.bashrc"
source_line="source \"$repo_root/arch/bashrc.d/90-hyprland-rice.sh\""
touch "$bashrc"
if ! grep -Fqx "$source_line" "$bashrc"; then
  printf '\n%s\n' "$source_line" >> "$bashrc"
fi
chown "$user_name:$user_name" "$bashrc"

chown -R "$user_name:$user_name" "$user_home/.config"

printf '\nArch migration complete. Log out and back in so group and environment changes apply.\n'
printf 'Optional AUR packages are documented in arch/aur-packages.txt.\n'