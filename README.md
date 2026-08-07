# Full Setup

One-shot setup for my Arch Linux system: packages, apps, theme and hypr config.

## Install / Update (one-liner)

```bash
bash <(curl -s https://raw.githubusercontent.com/n5za/full-setup/master/get)
```

This downloads/clones the repo to `~/.cache/full-setup` (and pulls updates if it already exists), then runs `./setup.sh`.

## Usage (manual)

```bash
git clone https://github.com/n5za/full-setup.git
cd full-setup
./setup.sh
```

## What it does

1. Installs all repo packages (`packages/repo.txt`)
2. Installs all AUR packages via yay (`packages/aur.txt`)
3. Installs the end-4 dots-hyprland theme:
   ```bash
   bash <(curl -s https://ii.clsty.link/get)
   ```
4. Deploys the customized hypr config (`config/hypr`) to `~/.config/hypr`

## Update package lists

```bash
pacman -Qqn > packages/repo.txt
pacman -Qmq > packages/aur.txt
```
