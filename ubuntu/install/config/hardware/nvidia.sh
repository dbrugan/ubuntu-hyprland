# Install the NVIDIA driver matching the detected GPU.
# Ubuntu ships the driver as a prebuilt DKMS package, so kernel headers are
# pulled in by name rather than resolved against the running kernel the way
# Arch's linux-headers packages are.
if lspci | grep -qi 'nvidia'; then
  # Build tools needed to compile the DKMS module
  PACKAGES=(dkms build-essential linux-headers-generic)

  if ub-hw-nvidia-gsp; then
    PACKAGES+=(nvidia-driver-580-open nvidia-utils-580)
    GPU_ARCH="turing_plus"
  elif ub-hw-nvidia-without-gsp; then
    PACKAGES+=(nvidia-driver-580 nvidia-utils-580)
    GPU_ARCH="maxwell_pascal_volta"
  fi

  # Bail if no supported GPU
  if [[ -z ${GPU_ARCH+x} ]]; then
    echo "No compatible driver for your NVIDIA GPU."
    exit 0
  fi

  ub-pkg-add "${PACKAGES[@]}"

  # Configure modprobe for early KMS
  sudo tee /etc/modprobe.d/nvidia.conf <<EOF >/dev/null
options nvidia_drm modeset=1
EOF

  # Add NVIDIA environment variables based on GPU architecture
  if [[ $GPU_ARCH = "turing_plus" ]]; then
    # Turing+ (RTX 20xx, GTX 16xx, and newer) with GSP firmware support
    cat >>"$HOME/.config/hypr/envs.conf" <<'EOF'

# NVIDIA (Turing+ with GSP firmware)
env = NVD_BACKEND,direct
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
EOF
  elif [[ $GPU_ARCH = "maxwell_pascal_volta" ]]; then
    # Maxwell/Pascal/Volta (GTX 9xx/10xx, GT 10xx, Quadro P/M/GV, MX series, Titan X/Xp/V) lack GSP firmware
    cat >>"$HOME/.config/hypr/envs.conf" <<'EOF'

# NVIDIA (Maxwell/Pascal/Volta without GSP firmware)
env = NVD_BACKEND,egl
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
EOF
  fi
fi