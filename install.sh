#!/bin/bash

#/**
# * GRUB Bootloader Theme Manager
# *
# * @license MIT
# * @copyright Copyright (c) 2023 iemafzalhassan
# * @author "iemafzalhassan" <iemafzalhassan@gmail.com>
# * @version 2.0.0
# * @link https://github.com/iemafzalhassan/GrubBootladerThemes
# */

# Enable strict error handling
set -euo pipefail
IFS=$'\n\t'

# Version information
VERSION="2.0.0"
BUILD_DATE=$(date +%Y-%m-%d)

# Configuration
THEME_DIR='/boot/grub/themes'
THEME_NAME=''
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/var/log/grub-theme-installer.log"

# Color output functions
function echo_title() {     echo -ne "\033[1;44;37m${*}\033[0m\n"; }
function echo_caption() {   echo -ne "\033[0;1;44m${*}\033[0m\n"; }
function echo_bold() {      echo -ne "\033[0;1;34m${*}\033[0m\n"; }
function echo_danger() {    echo -ne "\033[0;31m${*}\033[0m\n"; }
function echo_success() {   echo -ne "\033[0;32m${*}\033[0m\n"; }
function echo_warning() {   echo -ne "\033[0;33m${*}\033[0m\n"; }
function echo_secondary() { echo -ne "\033[0;34m${*}\033[0m\n"; }
function echo_info() {      echo -ne "\033[0;35m${*}\033[0m\n"; }
function echo_primary() {   echo -ne "\033[0;36m${*}\033[0m\n"; }
function echo_error() {     echo -ne "\033[0;1;31merror:\033[0;31m\t${*}\033[0m\n"; }
function echo_label() {     echo -ne "\033[0;1;32m${*}:\033[0m\t"; }
function echo_prompt() {    echo -ne "\033[0;36m${*}\033[0m "; }

# Logging functions
function log() {
    local message="$*"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${message}" | tee -a "${LOG_FILE}" 2>/dev/null || true
}

function log_error() {
    log "ERROR: $*"
    echo_error "$*"
}

function log_success() {
    log "SUCCESS: $*"
    echo_success "$*"
}

function log_info() {
    log "INFO: $*"
    echo_info "$*"
}

# Banner display
function splash() {
    local hr
    hr=" **$(printf "%${#1}s" | tr ' ' '*')** "
    echo_title "${hr}"
    echo_title " * $1 * "
    echo_title "${hr}"
    echo
}

# Show version information
function show_version() {
    echo_bold "GRUB Theme Manager v${VERSION}"
    echo_info "Build Date: ${BUILD_DATE}"
    echo_info "License: MIT"
    echo_info "Repository: https://github.com/iemafzalhassan/GrubBootladerThemes"
}

# Check for root access
function check_root() {
    local ROOT_UID=0
    if [[ ! "${UID}" -eq "${ROOT_UID}" ]]; then
        log_error 'Run me as root.'
        echo_info 'try sudo ./install.sh'
        exit 1
    fi
}

# Check for required dependencies
function check_dependencies() {
    local deps=('sed' 'grep' 'cp' 'mkdir' 'find')
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "${dep}" &> /dev/null; then
            missing+=("${dep}")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        echo_info "Install with: sudo apt-get install ${missing[*]}"
        exit 1
    fi
    
    # Optional dependency check for figlet
    if ! command -v figlet &> /dev/null; then
        echo_warning "figlet not found. Banner display will be limited."
        echo_info "Install with: sudo apt-get install figlet"
    fi
}

# Display banner (with fallback if figlet not available)
function display_banner() {
    if command -v figlet &> /dev/null; then
        figlet -f smblock -c "GRUB Theme Manager" 2>/dev/null || true
        figlet -f smbraille -c "v${VERSION}" 2>/dev/null || true
    else
        echo_title "GRUB Theme Manager v${VERSION}"
    fi
    echo
}

# Auto-detect available themes
function detect_themes() {
    local themes_dir="${SCRIPT_DIR}/themes"
    local themes=()
    
    if [[ ! -d "${themes_dir}" ]]; then
        log_error "Themes directory not found: ${themes_dir}"
        exit 1
    fi
    
    # Find all directories with theme.txt
    while IFS= read -r -d '' theme_dir; do
        local theme_name=$(basename "${theme_dir}")
        # Handle special case for mr-robot-theme directory
        if [[ "${theme_name}" == "mr-robot-theme" ]]; then
            themes+=("mr-robot")
        else
            themes+=("${theme_name}")
        fi
    done < <(find "${themes_dir}" -maxdepth 2 -name "theme.txt" -type f -print0 | xargs -0 dirname)
    
    # Sort themes alphabetically
    IFS=$'\n' themes=($(printf '%s\n' "${themes[@]}" | sort))
    unset IFS
    
    echo "${themes[@]}"
}

# Validate theme before installation
function validate_theme() {
    local theme_display_name="${THEME_NAME}"
    local theme_dir_name="${THEME_NAME}"
    
    # Map display names to directory names
    case "${THEME_NAME}" in
        'mr-robot')
            theme_dir_name='mr-robot-theme'
            ;;
        'grub_linea')
            theme_dir_name='grub_linea/linea_grub'
            ;;
    esac
    
    local theme_path="${SCRIPT_DIR}/themes/${theme_dir_name}"
    
    if [[ ! -d "${theme_path}" ]]; then
        log_error "Theme directory not found: ${theme_path}"
        return 1
    fi
    
    if [[ ! -f "${theme_path}/theme.txt" ]]; then
        log_error "Theme file missing: ${theme_path}/theme.txt"
        return 1
    fi
    
    if [[ ! -f "${theme_path}/background.png" ]] && [[ ! -f "${theme_path}/background.jpg" ]]; then
        echo_warning "Background image missing in theme directory"
    fi
    
    # Store the actual directory name for installation
    THEME_DIR_NAME="${theme_dir_name}"
    return 0
}

# Select theme from available themes
function select_theme() {
    local themes_array
    read -ra themes_array <<< "$(detect_themes)"
    
    if [[ ${#themes_array[@]} -eq 0 ]]; then
        log_error "No themes found in themes directory"
        exit 1
    fi
    
    themes_array+=("Quit")
    
    echo_primary "Available themes:"
    PS3=$(echo_prompt '\nChoose The Theme You Want: ')
    select THEME_NAME in "${themes_array[@]}"; do
        if [[ "${THEME_NAME}" == "Quit" ]]; then
            log_info 'User requested exit'
            exit 0
        elif [[ -n "${THEME_NAME}" ]]; then
            if validate_theme; then
                splash "Installing ${THEME_NAME} Theme..."
                break
            else
                echo_warning "Theme validation failed. Please select another theme."
                continue
            fi
        else
            echo_warning "Invalid option \"${REPLY}\""
        fi
    done
}

# Create backup of GRUB configuration
function backup() {
    local backup_file="/etc/default/grub.bak.$(date +%Y%m%d_%H%M%S)"
    
    if [[ ! -f /etc/default/grub ]]; then
        log_error "GRUB config file not found: /etc/default/grub"
        exit 1
    fi
    
    if ! cp -an /etc/default/grub "${backup_file}"; then
        log_error "Failed to create backup"
        exit 1
    fi
    
    log_success "Backup created: ${backup_file}"
    echo "${backup_file}"  # Return backup file path
}

# Install selected theme
function install_theme() {
    local theme_display_name="${THEME_NAME}"
    local theme_dir_name="${THEME_DIR_NAME:-${THEME_NAME}}"
    local source_path="${SCRIPT_DIR}/themes/${theme_dir_name}"
    local target_path="${THEME_DIR}/${theme_display_name}"
    
    # Create themes directory if it doesn't exist
    if [[ ! -d "${THEME_DIR}" ]]; then
        log_info "Creating themes directory: ${THEME_DIR}"
        mkdir -p "${THEME_DIR}"
    fi
    
    # Remove existing theme if present
    if [[ -d "${target_path}" ]]; then
        echo_warning "Theme already exists. Removing old installation..."
        rm -rf "${target_path}"
    fi
    
    # Copy theme files
    echo_primary "Installing ${theme_display_name} theme..."
    log_info "Copying from: ${source_path}"
    log_info "Copying to: ${target_path}"
    
    if ! mkdir -p "${target_path}"; then
        log_error "Failed to create theme directory"
        exit 1
    fi
    
    if ! cp -a "${source_path}"/* "${target_path}/" 2>/dev/null; then
        log_error "Failed to copy theme files"
        exit 1
    fi
    
    log_success "Theme ${theme_display_name} installed successfully"
}

# Configure GRUB settings
function config_grub() {
    echo_primary 'Configuring GRUB settings...'
    
    # Backup before making changes
    local backup_file
    backup_file=$(backup)
    
    # Enable grub menu
    log_info "Enabling GRUB menu"
    sed -i '/GRUB_TIMEOUT_STYLE=/d' /etc/default/grub || true
    echo 'GRUB_TIMEOUT_STYLE="menu"' >> /etc/default/grub
    
    # Set grub timeout
    log_info "Setting GRUB timeout to 60 seconds"
    sed -i '/GRUB_TIMEOUT=/d' /etc/default/grub || true
    echo 'GRUB_TIMEOUT="60"' >> /etc/default/grub
    
    # Set theme
    log_primary "Setting ${THEME_NAME} as default theme"
    sed -i '/GRUB_THEME=/d' /etc/default/grub || true
    echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub
    
    # Set graphics mode
    log_info "Setting GRUB graphics mode to auto"
    sed -i '/GRUB_GFXMODE=/d' /etc/default/grub || true
    echo 'GRUB_GFXMODE="auto"' >> /etc/default/grub
    
    log_success "GRUB configuration updated"
}

# Update GRUB configuration
function update_grub() {
    echo_primary 'Updating GRUB configuration...'
    
    if [[ -x "$(command -v update-grub)" ]]; then
        log_info 'Running update-grub'
        if update-grub; then
            log_success "GRUB updated successfully"
        else
            log_error "Failed to update GRUB"
            exit 1
        fi
    elif [[ -x "$(command -v grub-mkconfig)" ]]; then
        log_info 'Running grub-mkconfig'
        if grub-mkconfig -o /boot/grub/grub.cfg; then
            log_success "GRUB updated successfully"
        else
            log_error "Failed to update GRUB"
            exit 1
        fi
    elif [[ -x "$(command -v grub2-mkconfig)" ]]; then
        if [[ -x "$(command -v zypper)" ]]; then
            log_info 'Running grub2-mkconfig (openSUSE)'
            if grub2-mkconfig -o /boot/grub2/grub.cfg; then
                log_success "GRUB updated successfully"
            else
                log_error "Failed to update GRUB"
                exit 1
            fi
        elif [[ -x "$(command -v dnf)" ]]; then
            log_info 'Running grub2-mkconfig (Fedora)'
            if grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg; then
                log_success "GRUB updated successfully"
            else
                log_error "Failed to update GRUB"
                exit 1
            fi
        else
            log_error "Could not determine GRUB update method"
            exit 1
        fi
    else
        log_error "No GRUB update command found"
        exit 1
    fi
}

# List installed themes
function list_installed_themes() {
    local installed_themes=()
    
    if [[ ! -d "${THEME_DIR}" ]]; then
        echo_info "No themes directory found. No themes installed."
        return 0
    fi
    
    while IFS= read -r -d '' theme; do
        installed_themes+=("$(basename "${theme}")")
    done < <(find "${THEME_DIR}" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)
    
    if [[ ${#installed_themes[@]} -eq 0 ]]; then
        echo_info "No themes installed"
        return 0
    fi
    
    echo_primary "Installed themes:"
    for theme in "${installed_themes[@]}"; do
        local current_theme=""
        if grep -q "GRUB_THEME.*${theme}" /etc/default/grub 2>/dev/null; then
            current_theme=" (active)"
        fi
        echo_info "  - ${theme}${current_theme}"
    done
}

# Uninstall theme
function uninstall_theme() {
    local installed_themes=()
    
    if [[ ! -d "${THEME_DIR}" ]]; then
        echo_info "No themes directory found"
        return 0
    fi
    
    while IFS= read -r -d '' theme; do
        installed_themes+=("$(basename "${theme}")")
    done < <(find "${THEME_DIR}" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)
    
    if [[ ${#installed_themes[@]} -eq 0 ]]; then
        echo_info "No themes installed"
        return 0
    fi
    
    installed_themes+=("Quit")
    PS3=$(echo_prompt '\nChoose Theme to Uninstall: ')
    select theme_to_remove in "${installed_themes[@]}"; do
        if [[ "${theme_to_remove}" == "Quit" ]]; then
            return 0
        elif [[ -n "${theme_to_remove}" ]]; then
            echo_warning "Removing theme: ${theme_to_remove}"
            
            # Check if it's the active theme
            local is_active=false
            if grep -q "GRUB_THEME.*${theme_to_remove}" /etc/default/grub 2>/dev/null; then
                is_active=true
            fi
            
            if rm -rf "${THEME_DIR}/${theme_to_remove}"; then
                log_success "Theme ${theme_to_remove} removed"
                
                # Remove theme from grub config if it was active
                if [[ "${is_active}" == "true" ]]; then
                    echo_warning "Removed theme was active. Clearing GRUB_THEME setting..."
                    sed -i '/GRUB_THEME=/d' /etc/default/grub || true
                    echo 'GRUB_THEME=""' >> /etc/default/grub
                    update_grub
                fi
            else
                log_error "Failed to remove theme"
            fi
            return 0
        fi
    done
}

# Restore default GRUB (remove theme)
function restore_default_grub() {
    echo_warning "This will remove the current theme and restore default GRUB appearance"
    echo_prompt "Continue? (y/N): "
    read -r confirm
    
    if [[ ! "${confirm}" =~ ^[Yy]$ ]]; then
        echo_info "Cancelled"
        return 0
    fi
    
    # Remove GRUB_THEME setting
    sed -i '/GRUB_THEME=/d' /etc/default/grub || true
    echo 'GRUB_THEME=""' >> /etc/default/grub
    
    update_grub
    log_success "Default GRUB restored"
}

# Rollback to previous GRUB configuration
function rollback() {
    local backup_files=()
    
    # Find all backup files
    while IFS= read -r -d '' backup; do
        backup_files+=("${backup}")
    done < <(find /etc/default -maxdepth 1 -name "grub.bak.*" -type f -print0 2>/dev/null | sort -z -r)
    
    if [[ ${#backup_files[@]} -eq 0 ]]; then
        echo_error "No backup files found"
        return 1
    fi
    
    echo_primary "Available backups:"
    select backup in "${backup_files[@]}" "Cancel"; do
        if [[ "${backup}" == "Cancel" ]]; then
            return 0
        elif [[ -n "${backup}" ]]; then
            echo_warning "Restoring from: ${backup}"
            if cp -f "${backup}" /etc/default/grub; then
                update_grub
                log_success "Rolled back to: ${backup}"
            else
                log_error "Failed to restore backup"
            fi
            return 0
        fi
    done
}

# Install grub-customizer (optional)
function install_grub_customizer() {
    echo_primary "GRUB Customizer Installation"
    echo_info "GRUB Customizer is a graphical tool for customizing GRUB bootloader"
    echo_prompt "Do you want to install grub-customizer? (y/N): "
    read -r install_customizer
    
    if [[ ! "${install_customizer}" =~ ^[Yy]$ ]]; then
        echo_info "Skipping grub-customizer installation"
        return 0
    fi
    
    # Check if running on Debian/Ubuntu
    if ! command -v apt-get &> /dev/null; then
        echo_warning "grub-customizer installation only supported on Debian/Ubuntu systems"
        return 1
    fi
    
    log_primary "Installing grub-customizer for Debian/Ubuntu..."
    
    # Add repository
    if ! add-apt-repository -y ppa:danielrichter2007/grub-customizer; then
        log_error "Failed to add grub-customizer repository"
        return 1
    fi
    
    # Update package list
    if ! apt-get update; then
        log_error "Failed to update package list"
        return 1
    fi
    
    # Install grub-customizer
    if apt-get install -y grub-customizer; then
        log_success "grub-customizer installed successfully"
        echo_info "You can now launch grub-customizer from your applications menu"
    else
        log_error "Failed to install grub-customizer"
        return 1
    fi
}

# Main menu
function show_main_menu() {
    while true; do
        clear
        display_banner
        echo_title "Main Menu"
        echo
        echo "1) Install Theme"
        echo "2) Uninstall Theme"
        echo "3) List Installed Themes"
        echo "4) Restore Default GRUB"
        echo "5) Rollback GRUB Configuration"
        echo "6) Install grub-customizer"
        echo "7) Show Version"
        echo "8) Quit"
        echo
        
        read -p "$(echo_prompt 'Choose an option: ')" choice
        
        case "${choice}" in
            1)
                select_theme
                install_theme
                config_grub
                update_grub
                echo
                echo_success 'Boot Theme Update Successful!'
                echo_prompt "Press Enter to continue..."
                read -r
                ;;
            2)
                uninstall_theme
                echo_prompt "Press Enter to continue..."
                read -r
                ;;
            3)
                list_installed_themes
                echo_prompt "Press Enter to continue..."
                read -r
                ;;
            4)
                restore_default_grub
                echo_prompt "Press Enter to continue..."
                read -r
                ;;
            5)
                rollback
                echo_prompt "Press Enter to continue..."
                read -r
                ;;
            6)
                install_grub_customizer
                echo_prompt "Press Enter to continue..."
                read -r
                ;;
            7)
                show_version
                echo_prompt "Press Enter to continue..."
                read -r
                ;;
            8)
                echo_info "Goodbye!"
                exit 0
                ;;
            *)
                echo_warning "Invalid option"
                sleep 1
                ;;
        esac
    done
}

# Legacy main function (for backward compatibility)
function main() {
    splash 'The Matrix awaits you...'
    
    check_root
    check_dependencies
    select_theme
    
    install_theme
    config_grub
    update_grub
    
    log_success 'Boot Theme Update Successful!'
    echo_success 'Boot Theme Update Successful!'
    
    # Ask about grub-customizer
    echo
    install_grub_customizer
}

# Check if script is being run directly or sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Check for command line arguments
    case "${1:-}" in
        --menu|-m)
            check_root
            check_dependencies
            show_main_menu
            ;;
        --version|-v)
            show_version
            exit 0
            ;;
        --help|-h)
            echo_bold "GRUB Theme Manager"
            echo
            echo "Usage: $0 [OPTIONS]"
            echo
            echo "Options:"
            echo "  --menu, -m     Show interactive menu"
            echo "  --version, -v  Show version information"
            echo "  --help, -h     Show this help message"
            echo
            echo "If no option is provided, the script will run in installation mode."
            exit 0
            ;;
        *)
            # Run in legacy installation mode
            main
            ;;
    esac
fi
