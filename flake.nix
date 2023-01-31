{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = inputs: let
    commit = inputs.self.shortRev or "dirty";
    date = inputs.self.lastModifiedDate or inputs.self.lastModified or "19700101";

    nixpkgsForHost = host:
      import inputs.nixpkgs {
        system = host;
      };

    nixpkgs."aarch64-darwin" = nixpkgsForHost "aarch64-darwin";
    nixpkgs."aarch64-linux" = nixpkgsForHost "aarch64-linux";
    nixpkgs."x86_64-darwin" = nixpkgsForHost "x86_64-darwin";
    nixpkgs."x86_64-linux" = nixpkgsForHost "x86_64-linux";

    blowfishTheme = nixpkgs."x86_64-linux".fetchFromGitHub {
      owner = "nunocoracao";
      repo = "blowfish";
      rev = "17557c7d731c3f07fb8cf72ebfc11c0cf21faa9a";
      sha256 = "yuSS9l8qQLHtiO0C4sAm0uZiDWj6naINU89k7PzxxWw=";
    };

  in {

    devShell."x86_64-linux" = with nixpkgs."x86_64-linux";
      mkShell {
        name = "slwst-web";
        packages = [
          caddy
          hugo
        ];
        shellHook = ''
          mkdir -p themes
          ln -snf "${blowfishTheme}" themes/blowfish
        '';
      };
  };
}
