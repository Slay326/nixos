{
  # this is only used for VMs with build-vm
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 4;
    };
    virtualisation.qemu.options = [
      "-virtfs"
      "local,path=/home/reyess/dev/,mount_tag=hostdev,security_model=passthrough,id=hostdev"
    ];
  };
}
