!/bin/bash

# You can change the following: (TODO: Make cmdline options)
# FWDIR (/lib/firmware): The directory to search for firmware in.
# NVCODENAME (gp104)   : See: https://nouveau.freedesktop.org/wiki/CodeNames
# FWBLACKLIST (<none>) : List of firmware to skip. You must use the full path as nvidia/${NVCODENAME}/...
FWDIR="/lib/firmware"
NVCODENAME="gp104"
FWBLACKLIST=""

# Recursively list all files in ${FWDIR}/nvidia/${NVCODENAME}.
# We filter out all lines that aren't paths by making sure
# they start with './'. `tree` prints out some metrics at the
# end that we don't want.
files=($(
  cd "${FWDIR}"
  tree -if "nvidia/${NVCODENAME}" | awk '$1 ~ /.\// {print $1}'
))

FW_LIST=()

for file in ${files[@]}; do
  # Skip any directories. We only want files and symlinks.
  # TODO: Better check, but really there shouldn't be any-
  # thing else in this directory.
  if [[ ! -d "${FWDIR}/${file}" ]]; then

    # We can also skip this file if it's blacklisted. This
    # is useful if you have other non-firmware files in the
    # tree that you want to skip, or if you want to
    # selectively disable firmware modules (for testing,
    # or maybe they aren't used by the driver).
    if [[ " ${FWBLACKLIST} " =~ " ${file} " ]]; then
      continue
    fi

    # Add this firmware blob to our list.
    FW_LIST+=("${file}")
  fi
done

# Print updated kernel config options.
echo "CONFIG_EXTRA_FIRMWARE_DIR=\"${FWDIR}\"
echo "CONFIG_EXTRA_FIRMWARE=\"${FW_LIST[@]}\"
