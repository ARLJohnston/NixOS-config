{ pkgs }:

let
  imgLink = "";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-chili";
    rev = "6516d50176c3b34df29003726ef9708813d06271";
    sha256 = "1k3il9xaqbq6sfid86ijvhm9zn7wxk81xhbsbm431m2y53hv9ll8";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm Background.jpg
    cp -r ${image} $out/Background.jpg
   '';
}
