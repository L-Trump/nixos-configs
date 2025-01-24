# Flake Outputs

## Is such a complex and fine-grained structure necessary?

There is no need to do this when you have a small number of machines.

But when you have a large number of machines, it is necessary to manage them in
a fine-grained way, otherwise, it will be difficult to manage and maintain them.

The number of my machines has grown to more than 20, and the increase in scale
has shown signs of getting out of control of complexity, so it is a natural and
reasonable choice to use this fine-grained architecture to manage.

## Folder Structure

- `default.nix` - flake outputs entry, all outputs composed here
- `config-presets/` - presets for my custom modules configs
  - `bare.nix` - the default config that activate no extra function
  - `server.nix` - the default config for servers
  - `daily.nix` - the default config for daily-use machine (with gui enabled)
- `x86_64-linux` - outputs for Linux x86_64
  - `hosts/<hostname>.nix` - normal hosts
  - `microvms/<hostname>.nix` - microvm hosts
