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

  # Add NVIDIA environment variables based on GPU architecture.
  # These go in the uwsm session env (sourced at login), not
  # ~/.config/hypr/envs.conf, which hyprland.conf does not source.
  UWSM_ENV="$HOME/.config/uwsm/env"
  if [[ ! -f $UWSM_ENV ]]; then
    mkdir -p "$(dirname "$UWSM_ENV")"
    cp "$UBUNTU_PATH/config/uwsm/env" "$UWSM_ENV"
  fi
  if ! grep -q "NVIDIA (" "$UWSM_ENV" 2>/dev/null; then
    if [[ $GPU_ARCH = "turing_plus" ]]; then
      # Turing+ (RTX 20xx, GTX 16xx, and newer) with GSP firmware support
      cat >>"$UWSM_ENV" <<'EOF'

# NVIDIA (Turing+ with GSP firmware)
export NVD_BACKEND=direct
export LIBVA_DRIVER_NAME=nvidia
export __GLX_VENDOR_LIBRARY_NAME=nvidia
EOF
    elif [[ $GPU_ARCH = "maxwell_pascal_volta" ]]; then
      # Maxwell/Pascal/Volta (GTX 9xx/10xx, GT 10xx, Quadro P/M/GV, MX series, Titan X/Xp/V) lack GSP firmware
      cat >>"$UWSM_ENV" <<'EOF'

# NVIDIA (Maxwell/Pascal/Volta without GSP firmware)
export NVD_BACKEND=egl
export __GLX_VENDOR_LIBRARY_NAME=nvidia
EOF
    fi
  fi
fi