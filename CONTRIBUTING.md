# Contributing to GRUB Bootloader Theme Manager

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect different viewpoints and experiences

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/iemafzalhassan/GrubBootladerThemes/issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - System information (OS, distribution, version)
   - Relevant logs or error messages

### Suggesting Features

1. Check existing issues and feature requests
2. Create a new issue with:
   - Clear description of the feature
   - Use case and benefits
   - Possible implementation approach (if you have ideas)

### Adding a New Theme

1. **Theme Structure:**
   - Create a new directory in `themes/` with your theme name (lowercase, hyphens)
   - Include required files:
     - `theme.txt` - GRUB theme configuration file
     - `background.png` or `background.jpg` - Background image
     - Font files (`.pf2` format) - GRUB-compatible fonts
   - Optional files:
     - `preview.png` - Preview image for theme selection
     - `README.md` - Theme-specific documentation
     - `LICENSE` - Theme license (if different from project)

2. **Theme Guidelines:**
   - Follow GRUB theme format specifications
   - Test on multiple resolutions if possible
   - Ensure theme works with both UEFI and legacy BIOS
   - Include appropriate fonts for readability
   - Keep file sizes reasonable

3. **Testing:**
   - Test installation on at least one Linux distribution
   - Verify theme displays correctly
   - Test uninstallation
   - Check for any missing dependencies

4. **Documentation:**
   - Add theme name to theme detection (if needed)
   - Update README.md with theme preview
   - Include theme credits and sources

### Code Contributions

1. **Fork the Repository:**
   ```bash
   git clone https://github.com/yourusername/GrubBootladerThemes.git
   cd GrubBootladerThemes
   ```

2. **Create a Feature Branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Code Style:**
   - Follow existing Bash coding style
   - Use shellcheck for linting: `./run_linter.sh`
   - Add comments for complex logic
   - Use descriptive function and variable names
   - Follow the existing function structure

4. **Testing:**
   - Run tests: `./run_tests.sh`
   - Test your changes manually
   - Ensure backward compatibility

5. **Commit Messages:**
   - Use clear, descriptive commit messages
   - Reference issue numbers if applicable
   - Format: `type: brief description`
   - Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

6. **Submit Pull Request:**
   - Push to your fork
   - Create pull request with:
     - Clear title and description
     - Reference related issues
     - List changes made
     - Screenshots (if UI changes)

## Development Setup

### Prerequisites

- Bash shell
- shellcheck (for linting)
- bash_unit (for testing - auto-downloaded)
- Root/sudo access (for testing installation)

### Running Tests

```bash
# Run all tests
./run_tests.sh

# Run linter
./run_linter.sh
```

### Testing Installation

```bash
# Test in a VM or test environment
sudo ./install.sh --menu
```

## Project Structure

```
GrubBootladerThemes/
├── install.sh              # Main installation script
├── run_linter.sh           # Linter runner
├── run_tests.sh            # Test runner
├── README.md               # Project documentation
├── CONTRIBUTING.md         # This file
├── CHANGELOG.md            # Version history
├── LICENSE                 # MIT License
└── themes/                 # Theme collection
    └── theme-name/
        ├── theme.txt
        ├── background.png
        └── ...
```

## Coding Standards

### Bash Scripting

- Use `set -euo pipefail` for error handling
- Quote all variables: `"${variable}"`
- Use local variables in functions: `local var="value"`
- Check return codes of critical commands
- Provide meaningful error messages

### Function Structure

```bash
function function_name() {
    local local_var="value"
    
    # Validation
    if [[ condition ]]; then
        log_error "Error message"
        return 1
    fi
    
    # Main logic
    # ...
    
    # Success
    log_success "Success message"
}
```

### Error Handling

- Always check for errors
- Use `log_error` for errors
- Use `log_success` for successful operations
- Exit with appropriate codes

## Review Process

1. All pull requests will be reviewed
2. Address review comments promptly
3. Maintain test coverage
4. Ensure code passes linting
5. Update documentation as needed

## Questions?

- Open an issue for questions
- Check existing documentation
- Review closed issues for similar questions

Thank you for contributing! 🎉

