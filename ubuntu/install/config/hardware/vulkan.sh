# Install Vulkan drivers matching detected GPU hardware
# (NVIDIA Vulkan is handled by nvidia.sh via nvidia-utils)
#
# Arch ships one package per vendor; Ubuntu ships every Mesa Vulkan ICD
# in mesa-vulkan-drivers, so a single package covers Intel, AMD, and Apple.

if lspci | grep -iE '(VGA|Display).*(Intel|Advanced Micro Devices|AMD/ATI|Apple)' >/dev/null; then
  ub-pkg-add mesa-vulkan-drivers
fi