# GRUB Bootloader Theme Manager

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/iemafzalhassan/GrubBootladerThemes)

A comprehensive collection of beautiful GRUB bootloader themes with an easy-to-use installer and theme management system.

## ✨ Features

- 🎨 **11+ Curated Themes** - Beautiful, professionally designed bootloader themes
- 🔄 **Easy Installation/Uninstallation** - Simple theme management
- 🖼️ **Auto Theme Detection** - Automatically finds all available themes
- 🔙 **Rollback Support** - Restore previous GRUB configurations
- 📋 **Theme Management** - List, install, and uninstall themes easily
- 🧪 **Comprehensive Testing** - Automated test suite
- 📦 **Multi-Distribution Support** - Works on Debian, Ubuntu, Fedora, openSUSE
- 📝 **Logging** - Detailed installation logs
- 🛡️ **Error Handling** - Robust error checking and validation
- 🎯 **Interactive Menu** - User-friendly menu system

## 🎨 Available Themes

- **CyberEXS** - Minimalist cyberpunk design
- **Cyberpunk** - Yellow/black color scheme with scrollbar support
- **CyberRe** - Red/cyan color scheme with progress bar
- **CyberSynchro** - Multiple UI elements (boot menu, sliders, password fields)
- **fallout** - Green terminal aesthetic (Fallout-inspired)
- **grub_linea** - Linea icon set integration
- **mr-robot** - Mr. Robot-inspired with multilingual support
- **shodan** - System Shock-inspired theme
- **vimix** - Vimix desktop theme adaptation
- **virtual_future** - Futuristic design

## 📋 Requirements

- Linux system with GRUB bootloader
- Root/sudo access
- Bash shell
- Basic dependencies: `sed`, `grep`, `cp`, `mkdir`, `find`

Optional:
- `figlet` (for enhanced banner display)
- `shellcheck` (for code linting)

## 🚀 Installation

### Quick Install

```bash
# Clone the repository
git clone https://github.com/iemafzalhassan/GrubBootladerThemes.git
cd GrubBootladerThemes

# Run the installer
sudo ./install.sh
```

### Interactive Menu Mode

```bash
# Launch the interactive menu
sudo ./install.sh --menu
```

The menu provides options to:
1. Install Theme
2. Uninstall Theme
3. List Installed Themes
4. Restore Default GRUB
5. Rollback GRUB Configuration
6. Install grub-customizer
7. Show Version
8. Quit

### Command Line Options

```bash
# Show version information
sudo ./install.sh --version

# Show help message
sudo ./install.sh --help

# Run in legacy installation mode (default)
sudo ./install.sh
```

## 📖 Usage

### Installing a Theme

1. Run the installer:
   ```bash
   sudo ./install.sh
   ```

2. Select a theme from the list

3. The script will:
   - Validate the theme
   - Create a backup of your GRUB configuration
   - Install the theme files
   - Update GRUB configuration
   - Update GRUB bootloader

4. Reboot to see your new theme!

### Uninstalling a Theme

Using the interactive menu:
```bash
sudo ./install.sh --menu
# Select option 2: Uninstall Theme
```

### Listing Installed Themes

```bash
sudo ./install.sh --menu
# Select option 3: List Installed Themes
```

### Restoring Default GRUB

```bash
sudo ./install.sh --menu
# Select option 4: Restore Default GRUB
```

### Rolling Back Configuration

If something goes wrong, you can rollback to a previous GRUB configuration:

```bash
sudo ./install.sh --menu
# Select option 5: Rollback GRUB Configuration
```

## 🔧 Advanced Usage

### Installing grub-customizer

GRUB Customizer is a graphical tool for customizing GRUB. You can install it optionally:

```bash
sudo ./install.sh --menu
# Select option 6: Install grub-customizer
```

Or it will be offered during the standard installation process.

### Manual Theme Installation

If you prefer manual installation:

1. Copy theme files to `/boot/grub/themes/theme-name/`
2. Edit `/etc/default/grub`:
   ```bash
   GRUB_THEME="/boot/grub/themes/theme-name/theme.txt"
   ```
3. Update GRUB:
   ```bash
   sudo update-grub
   ```

## 📁 Project Structure

```
GrubBootladerThemes/
├── install.sh              # Main installation script
├── run_linter.sh           # Linter runner
├── run_tests.sh            # Test runner
├── README.md               # This file
├── CONTRIBUTING.md         # Contribution guidelines
├── CHANGELOG.md            # Version history
├── LICENSE                 # MIT License
├── .gitignore              # Git ignore rules
└── themes/                 # Theme collection
    ├── CyberEXS/
    ├── Cyberpunk/
    ├── CyberRe/
    └── ...
```

## 🧪 Testing

Run the test suite:

```bash
./run_tests.sh
```

Run the linter:

```bash
./run_linter.sh
```

## 📝 Logging

Installation logs are saved to:
```
/var/log/grub-theme-installer.log
```

View recent logs:
```bash
sudo tail -f /var/log/grub-theme-installer.log
```

## 🛠️ Troubleshooting

### Theme Not Appearing After Installation

1. Verify GRUB configuration:
   ```bash
   grep GRUB_THEME /etc/default/grub
   ```

2. Check if theme files exist:
   ```bash
   ls -la /boot/grub/themes/
   ```

3. Update GRUB manually:
   ```bash
   sudo update-grub
   ```

4. Check logs:
   ```bash
   sudo cat /var/log/grub-theme-installer.log
   ```

### Rollback to Previous Configuration

Use the rollback feature:
```bash
sudo ./install.sh --menu
# Select option 5: Rollback GRUB Configuration
```

Or manually restore from backup:
```bash
sudo cp /etc/default/grub.bak.YYYYMMDD_HHMMSS /etc/default/grub
sudo update-grub
```

### Permission Errors

Ensure you're running with root privileges:
```bash
sudo ./install.sh
```

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Adding a New Theme

1. Create a new directory in `themes/` with your theme name
2. Include required files:
   - `theme.txt` - GRUB theme configuration
   - `background.png` or `background.jpg` - Background image
   - Font files (`.pf2` format)
3. Test your theme
4. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed instructions.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Original contributors and theme creators
- GRUB development team
- All theme designers and contributors

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/iemafzalhassan/GrubBootladerThemes/issues)
- **Discussions**: [GitHub Discussions](https://github.com/iemafzalhassan/GrubBootladerThemes/discussions)

## 🎯 Roadmap

- [ ] Theme preview functionality
- [ ] GUI interface option
- [ ] Theme package format support
- [ ] Automated theme testing
- [ ] CI/CD pipeline improvements
- [ ] More themes

## 📸 Theme Previews

![Theme Preview 1](https://github.com/iemafzalhassan/GrubBootladerThemes/assets/136967348/f7e91a05-a401-4441-992e-51bd0609ca56)
![Theme Preview 2](https://github.com/iemafzalhassan/GrubBootladerThemes/assets/136967348/2b779f33-bd2f-439a-a2ce-c682b1279de0)
![Theme Preview 3](https://github.com/iemafzalhassan/GrubBootladerThemes/assets/136967348/6e68db8b-b1d7-4947-a322-17c9391a1710)
![Theme Preview 4](https://github.com/iemafzalhassan/GrubBootladerThemes/assets/136967348/cf5d36d8-7df9-494b-b5d8-71da18e9dbce)
![Theme Preview 5](https://github.com/iemafzalhassan/GrubBootladerThemes/assets/136967348/ff1f2307-d9be-4e42-9b15-a0042a3f753b)

---

Made with ❤️ by [Md. Afzal Hassan Ehsani](https://linkedin.com/in/iemafzalhassan)
