# Hosts

1. `matebook-gt14`: My main laptop, Huawei Matebook GT14 2024, for daily use.
1. `n100`: N100 NUC in home, as homelab.
1. `tencent-vm-jp`: Virtual machine on Tencent Cloud, located in japan.
1. `iso`: For install/live image generation.

## How to add a new host

1. Under `hosts/`
   1. Create a new folder under `hosts/` with the name of the new host.
   1. Create & add the new host's `hardware-configuration.nix` to the new folder, and add the new
      host's `configuration.nix` to `hosts/<name>/modules/core.nix`.
   1. More system config in `hosts/<name>/modules`, home config in `hosts/<name>/home`
1. Under `outputs/`
   1. Add a new nix file named `outputs/<system-architecture>/src/<name>.nix`.
   1. Copy the content from one of the existing similar host, and modify it to fit the new host.
      1. Usually, you only need to modify the `name` and `tags` fields.
   1. Modify `myconfigs` variable to toggle specefic common feature.
1. Under secrets repo
   1. Add easytier config for the new hosts if needed.
1. Under `vars/networking.nix`
   1. Add the new host's physical IP address if the new host is in local network.
   1. Add the new host's easytier IP address if available.
   1. Skip this step if the new host is not in the local network or is a mobile device.