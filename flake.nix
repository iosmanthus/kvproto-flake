{
  description = "Protocol buffer files for TiKV";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (
        system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            repo = "kvproto";
            fork = "git@github.com:iosmanthus/${repo}.git";
            upstream = "git@github.com:pingcap/${repo}.git";
          in
            {
              devShell = pkgs.mkShell {
                hardeningDisable = [ "all" ];
                nativeBuildInputs = with pkgs;[ cmake ];
                buildInputs = with pkgs;[ gcc git gnumake rustup protobuf3_8 grpc go ];
                PROTOC = "${pkgs.protobuf3_8}/bin/protoc";
                shellHook = ''
                  if [ ! -d "${repo}" ]; then
                    git clone ${fork}
                    git remote add upstream ${upstream}
                  fi
                '';
              };
            }
      );
}
