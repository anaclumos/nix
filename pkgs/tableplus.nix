{ callPackage, inputs }:
let
  sources = callPackage "${inputs.tableplus}/_sources/generated.nix" { };
in
callPackage "${inputs.tableplus}/package.nix" { inherit sources; }
