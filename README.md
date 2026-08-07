# Full Setup

One-shot setup for my Arch Linux system: packages, apps, theme and hypr config.

## Usage

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
