{ pkgs, ... }:
{
  boot.kernelParams = [
    "snd-intel-dspcfg.dsp_driver=1"
  ];

  hardware.firmware = with pkgs; [ sof-firmware ];
  # boot.extraModprobeConfig = ''
  #   options snd_sof_intel_hda_common sof_use_tplg_nhlt=1
  #   options snd_sof_pci tplg_filename=sof-hda-generic-ace1-4ch.tplg
  # '';
}
