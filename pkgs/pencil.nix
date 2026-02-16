{ callPackage, inputs }:
let
  sources = callPackage "${inputs.pencil}/_sources/generated.nix" { };
in
callPackage "${inputs.pencil}/package.nix" { inherit sources; }
