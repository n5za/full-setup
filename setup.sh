#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_DIR="$REPO_DIR/packages"
CONFIG_DIR="$REPO_DIR/config/hypr"
LOG_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/full-setup"

THEME_URL="https://ii.clsty.link/get"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

info()  { echo -e "${CYAN}[setup]${NC} $*"; }
ok()    { echo -e "${GREEN}[ ok ]${NC} $*"; }
warn()  { echo -e "${YELLOW}[warn]${NC} $*"; }
die()   { echo -e "${RED}[fail]${NC} $*" >&2; exit 1; }

need_root() {
  if [ "$(id -u)" -eq 0 ]; then return; fi
  if command -v sudo >/dev/null 2>&1; then
    sudo -v || die "sudo failed"
  else
    die "Need root. Run with sudo or as root."
  fi
}

detect_distro() {
  . /etc/os-release 2>/dev/null || die "Cannot read /etc/os-release"
  case "$ID $ID_LIKE" in
    arch*|cachyos*) DISTRO="arch" ;;
    debian*|ubuntu*) DISTRO="debian" ;;
    fedora*) DISTRO="fedora" ;;
    *suse*) DISTRO="suse" ;;
    *) die "Unsupported distro: $ID" ;;
  esac
}

install_packages() {
  local list="$1"
  [ -s "$list" ] || { warn "empty package list: $list"; return; }
  info "Installing packages from $(basename "$list")..."
  local pkgs
  mapfile -t pkgs < "$list"
  case "$DISTRO" in
    arch)
      sudo pacman -S --needed --noconfirm "${pkgs[@]}"
      ;;
    debian)
      sudo apt update
      sudo apt install -y "${pkgs[@]}"
      ;;
    fedora)
      sudo dnf install -y "${pkgs[@]}"
      ;;
    suse)
      sudo zypper -n install "${pkgs[@]}"
      ;;
  esac
  ok "Done: $(basename "$list")"
}

ensure_yay() {
  command -v yay >/dev/null 2>&1 && return
  info "yay not found, installing from AUR..."
  local tmp
  tmp="$(mktemp -d)"
  git clone --depth=1 https://aur.archlinux.org/yay.git "$tmp/yay"
  cd "$tmp/yay"
  makepkg -si --noconfirm
  cd "$REPO_DIR"
  rm -rf "$tmp"
  ok "yay installed"
}

install_aur_packages() {
  local list="$1"
  [ -s "$list" ] || { warn "empty AUR list: $list"; return; }
  info "Installing AUR packages..."
  local pkgs
  mapfile -t pkgs < "$list"
  yay -S --needed --noconfirm "${pkgs[@]}"
  ok "AUR packages installed"
}

install_theme() {
  info "Installing end-4 dots-hyprland theme..."
  info "Running: bash <(curl -s $THEME_URL)"
  bash <(curl -s -L "$THEME_URL")
  ok "Theme installed"
}

deploy_config() {
  [ -d "$CONFIG_DIR" ] || die "No config found at $CONFIG_DIR"
  local dest="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
  info "Backing up existing config (if any) to $dest.bak"
  [ -e "$dest" ] && rm -rf "$dest.bak" && mv "$dest" "$dest.bak"
  info "Deploying hypr config to $dest"
  cp -r "$CONFIG_DIR" "$dest"
  ok "Config deployed"
}

main() {
  info "Full system setup"
  detect_distro
  need_root

  install_packages "$PACKAGES_DIR/repo.txt"

  if [ "$DISTRO" = "arch" ]; then
    ensure_yay
    install_aur_packages "$PACKAGES_DIR/aur.txt"
  else
    warn "Skipping AUR packages (Arch only)"
  fi

  install_theme
  deploy_config

  echo
  ok "Setup complete! Reboot or restart hyprland."
}

main "$@"
