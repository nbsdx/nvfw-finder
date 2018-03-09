# nvfw-finder
I have this fucked up adversion to kernel modules, so here's a helper script for building the builtin firmware strings for NVidia graphics cards. This is required for building nouveau into the kernel instead of as a module.

## Nvidia Firmware Loading
If you're using nouveau that's been built into the kernel, you'll need to build the nvidia firmware into the kernel as well. It looks for firmware that has the following name structure: `nvidia/${CODENAME}/<firmware-path>` where `<firmware-path>` is something like "acr/bl.bin". So the full name would be `nvidia/gp104/acr/bl.bin` for a GTX 1080 acr/bl.bin firmware blob. These are the names the nouveau driver will look for when loading the firmware, so we need to use the same names for the firmware blobs in the kernel. This is accomplished by setting the Firmware Blobs Root Directory, and then setting a list of "Extra Firmware" that can be found in that directory and it's subdirectories. 

## Usage
1. Make sure `linux-firmware` is installed. Consult your disto's package manager for more info.
2. Go into your kernel sources and run `make menuconfig`
3. Set the following configs:
```
Device Drivers --->
  Generic Driver Options --->
    ## It doesn't matter what, just put something here so menuconfig enables the config option
    (placeholder) External firmware blobs to build into the knernel binary
    ## Set this to where ever your nvidia firmware tree lives (this is the default)
    (/lib/firmware) Firmware blobs root directory
```
4. Save the config to `.config` and exit menuconfig.
5. Run this script
6. Edit `.config` and repace the placeholder value with the output from the script.
7. Build your kernel.

## Example
```bash
$ ./get-kernel-config.sh
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
CONFIG_EXTRA_FIRMWARE="nvidia/gp104/acr/bl.bin nvidia/gp104/acr/ucode_load.bin nvidia/gp104/acr/ucode_unload.bin nvidia/gp104/acr/unload_bl.bin nvidia/gp104/gr/fecs_bl.bin nvidia/gp104/gr/fecs_data.bin nvidia/gp104/gr/fecs_inst.bin nvidia/gp104/gr/fecs_sig.bin nvidia/gp104/gr/gpccs_bl.bin nvidia/gp104/gr/gpccs_data.bin nvidia/gp104/gr/gpccs_inst.bin nvidia/gp104/gr/gpccs_sig.bin nvidia/gp104/gr/sw_bundle_init.bin nvidia/gp104/gr/sw_ctx.bin nvidia/gp104/gr/sw_method_init.bin nvidia/gp104/gr/sw_nonctx.bin nvidia/gp104/nvdec/scrubber.bin nvidia/gp104/sec2/desc.bin nvidia/gp104/sec2/image.bin nvidia/gp104/sec2/sig.bin"
```
