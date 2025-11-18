# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Interactive main menu system (`--menu` flag)
- Auto-detection of available themes
- Theme validation before installation
- Theme uninstaller functionality
- Rollback/restore GRUB configuration feature
- Logging functionality to `/var/log/grub-theme-installer.log`
- Enhanced error handling with `set -euo pipefail`
- Dependency checking before installation
- Version information (`--version` flag)
- Help message (`--help` flag)
- List installed themes functionality
- Restore default GRUB functionality
- Optional grub-customizer installation (separated from main flow)
- Enhanced backup system with timestamps
- Better multi-distribution support

### Changed
- Refactored grub-customizer installation into separate optional function
- Improved theme selection with validation
- Enhanced GRUB update detection for multiple distributions
- Better error messages and user feedback
- Improved code organization and modularity

### Fixed
- Theme directory name mapping (mr-robot-theme, grub_linea)
- Backup file handling
- Error handling in theme installation
- GRUB configuration update for different distributions

### Security
- Added input validation
- Improved error handling to prevent partial installations
- Better permission checking

## [2.0.0] - 2023-XX-XX

### Added
- Initial enhanced version with menu system
- Comprehensive error handling
- Logging system
- Theme management features

## [1.0.0] - 2023-XX-XX

### Added
- Initial release
- 11 themes (CyberEXS, Cyberpunk, CyberRe, CyberSynchro, fallout, grub_linea, mr-robot, shodan, vimix, virtual_future)
- Basic installation script
- Theme installation functionality
- GRUB configuration management
- grub-customizer installation (integrated)

### Known Issues
- Hardcoded theme list
- Limited error handling
- No uninstall functionality
- No rollback capability

---

## Version History Notes

- **v2.0.0**: Major refactoring with new features and improved architecture
- **v1.0.0**: Initial release with basic functionality

## Future Plans

- Theme preview functionality
- Theme package format support
- GUI interface option
- Theme marketplace integration
- Automated theme testing
- CI/CD pipeline improvements

