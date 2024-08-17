set path_prepend \
      $HOME/.local/bin/custom_scripts \
      $HOME/.cargo/bin \
      $HOME/go/bin

set path_append \
      /opt/intelFPGA/20.1/modelsim_ase/bin

if test (count $path_prepend) -gt 0
    fish_add_path -Pp $path_prepend
end

if test (count $path_append) -gt 0
    fish_add_path -Pa $path_append
end
