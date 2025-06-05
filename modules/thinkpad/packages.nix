{ pkgs }:

with pkgs;
let 
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in shared-packages ++ [

  hyprlock

  (prismlauncher.override {
    additionalLibs = [ xorg.libX11 xorg.libXcursor ];    
  })

  firefox

]
  
