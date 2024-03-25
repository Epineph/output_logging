#!/bin/bash

# locate at e.g., /usr/bin or someone else included in the environment variable "$PATH" to be able to execute as a script.

# Help information
show_help() {
    cat << EOF
Usage: $(basename "$0") [path] [OPTIONS]...
Change ownership and/or permissions of a given file or directory.

Arguments:
  path                  Specify the path to the file or directory.

Options:
  --help                Show this help message and exit.
  -R                    Apply changes recursively. You will be prompted for confirmation.
  ownership [username]  Change the ownership. Use "activeuser" to set to the current user.
  permissions [perms]   Set permissions in numeric (octal) or symbolic format.

Examples:
  $(basename "$0") /path/to/file # shows current ownership and permissions
  $(basename "$0") /path/to/file ownership # shows current ownership
  $(basename "$0") /path/to/dir permissions 755
  $(basename "$0") /path/to/dir -R permissions u=rwx,g=rx,o=rx
  $(basename "$0") /path/to/dir ownership root permissions rwx---r-- (704/u=rwx,o=r)
EOF
}

# Recursive operation confirmation
recursive_change_confirmation() {
    echo "You have requested a recursive operation. This action may modify permissions for a large number of files and can break your system if not used carefully."
    echo -n "Are you sure you want to continue with this recursive change? [y/N]: "
    read response
    if [[ "$response" != "y" ]]; then
        echo "Recursive change cancelled."
        exit 1
    fi
}

# Main script functionality
main() {
    if [[ -z "$1" || "$1" == "--help" ]]; then
        show_help
        exit 0
    fi

    local target=$1; shift
    local recursive=""
    local operation_set=false
    local last_operation=""  # Track the last operation specifiedcurrentownership or currentpermissions

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -R)
                recursive="-R"
                shift
                recursive_change_confirmation || return
                ;;
            currentownership)
                echo "Current ownership of $target:"
                # Fetch and display owner and group
                local owner=$(stat -c %U "$target")
                local group=$(stat -c %G "$target")
                echo "Owner: $owner, Group: $group"
                operation_set=true
                shift
                ;;
            currentpermissions)
                echo "Current permissions of $target:"
                # Fetch and display permissions in symbolic and numeric formats
                local symbolic_perms=$(stat -c %A "$target")
                local numeric_perms=$(stat -c %a "$target")
                # Extract user, group, and others permissions for symbolic display
                local user_perms=$(echo $symbolic_perms | cut -c 2-4)
                local group_perms=$(echo $symbolic_perms | cut -c 5-7)
                local others_perms=$(echo $symbolic_perms | cut -c 8-10)
                echo "Symbolic: $symbolic_perms, Numeric: $numeric_perms"
                echo "Detailed: u=${user_perms},g=${group_perms},o=${others_perms}"
                operation_set=true
                shift
                ;;
            ownership)
                echo "Changing ownership of $target to $2..."
                chown $recursive $2 "$target"
                echo "Ownership change completed."
                operation_set=true
                shift 2
                ;;
            permissions)
                shift
                local perms="$1"
                # Check if permissions are in the nine-character string format
                if [[ $perms =~ ^[r-][w-][x-][r-][w-][x-][r-][w-][x-]$ ]]; then
                    # Translate to numeric format for simplicity
                    local numeric_perms=0
                    local perm_str=('---' '--x' '-w-' '-wx' 'r--' 'r-x' 'rw-' 'rwx')
                    for (( i=0; i<3; i++ )); do
                        local segment="${perms:i*3:3}"
                        for idx in "${!perm_str[@]}"; do
                            if [[ "${perm_str[$idx]}" == "$segment" ]]; then
                                numeric_perms="${numeric_perms}${idx}"
                                break
                            fi
                        done
                    done
                    perms=$numeric_perms
                fi
                echo "Setting permissions of $target to $perms..."
                chmod $recursive $perms "$target"
                local numeric_perms=$(stat -c %a "$target")
                local symbolic_perms=$(stat -c %A "$target")
                echo "Permissions of $target are now set to $symbolic_perms ($numeric_perms)."
                operation_set=true # Indicate a valid operation was performed.
                shift
                return 0 # Ensure we exit after handling permissions to prevent further processing.
                ;;
            *)
                echo "Invalid option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    if [[ $operation_set == true ]]; then
        case "$last_operation" in
            currentownership)
                display_current_ownership "$target"
                ;;
            currentpermissions)
                display_current_permissions "$target"
                ;;
        esac
    else
        # Default behavior when no operation is specified
        echo "No specific operation requested. Displaying current ownership and permissions for: $target"
        display_current_ownership "$target"
        display_current_permissions "$target"
    fi
}

display_current_ownership() {
    local target=$1
    echo "Current ownership of $target:"
    local owner=$(stat -c %U "$target")
    local group=$(stat -c %G "$target")
    echo "Owner: $owner, Group: $group"
}

display_current_permissions() {
    local target=$1
    echo "Current permissions of $target:"
    local symbolic_perms=$(stat -c %A "$target")
    local numeric_perms=$(stat -c %a "$target")
    echo "Symbolic: $symbolic_perms, Numeric: $numeric_perms"
    local user_perms=$(echo $symbolic_perms | cut -c 2-4)
    local group_perms=$(echo $symbolic_perms | cut -c 5-7)
    local others_perms=$(echo $symbolic_perms | cut -c 8-10)
    echo "Detailed: u=${user_perms},g=${group_perms},o=${others_perms}"
}





main "$@"


