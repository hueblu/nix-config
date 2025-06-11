{ pkgs, config, user, ... }:
let
  shared-files = import ../../shared/files.nix { inherit pkgs config; };
in shared-files
// {

}
