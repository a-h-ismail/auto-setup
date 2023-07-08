#!/bin/bash
if [ $EUID -eq 0 ]; then
    echo "You must run this as root, try with sudo."
    exit 1
fi

function get_section {
    # Escaping the backslash twice (once for bash and once for awk)
    # Reason: awk expects this: \[section\] (escape the [] for the regex)
    awk -v "section=\\\\[$1\\\\]" -f extract_data.awk auto-setup.conf
}

set -x
system_type=$(get_section System)
add_packages=$(get_section 'Add Packages')
remove_packages=$(get_section 'Remove Packages')
req_flatpacks=$(get_section Flatpak)
system_units=$(get_section 'System Units')
all_users_units=$(get_section 'User Units')
files_mapping=$(get_section Files)
pre_script=$(get_section Pre)
post_script=$(get_section Post)

# Execute the pre-install script
# Let the script know the system type
$pre_script "$system_type"

# Install/Remove packages depending on your system type
if [ "$system_type" == "rpm" ]; then
    dnf install $add_packages -y
    dnf remove $remove_packages -y
    dnf upgrade -y
fi

if [ "$system_type" == "deb" ]; then
    apt-get update
    apt-get install $add_packages -y
    apt-get remove --purge $remove_packages -y
    apt-get autoremove -y
    apt-get upgrade -y
fi

# Install Flatpaks
flatpak install $req_flatpacks -y

# Move the files to the given locations
# Extract the source/destination pairs
for i in $(seq 1 $(echo "$files_mapping" | wc -l)); do
    # Read the mapping line by line and
    source=$(echo "$files_mapping" | awk -F ':' "NR == $i { printf \"%s\", \$1 }")
    destination=$(echo "$files_mapping" | awk -F ':' "NR == $i { printf \"%s\", \$2 }")
    mkdir -p "$destination"
    cp -r "$source" "$destination"
    # If an ACL file exists, restore the ACLs to the destination and delete the file
    if [ -e "$source/acls.txt" ]; then
        tmp=PWD
        cd "$destination"
        setfacl --restore=acls.txt
        rm acls.txt
        cd "$tmp"
    fi
    # Restore SELinux labels
    restorecon -R "$destination" 2> /dev/null
done

# Use awk like before to enable user scripts
for i in $(seq $(echo "$all_users_units" | wc -l)); do
    username=$(echo "$all_users_units" | awk -F ':' "NR == $i {print \$1}")
    user_units=$(echo "$all_users_units" | awk -F ':' "NR == $i {print \$2}")
    su - "$username" -c "systemctl --user enable --now $user_units"
done

# Enable system units as requested
# Reload the service manager since units could be newly installed by the package manager
systemctl daemon-reload
systemctl enable --now $system_units

# Finally the post script
$post_script "$system_type"
