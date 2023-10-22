{ pkgs }:

let
  imgLink = "https://github.com/ARLJohnston/NixOS-config/blob/d2532f8d6313e3b1126f9e23ac437913a796556d/background.png";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "0z855nh09sv04qs56rq1j7dpzgwa3alc3nzpbwxv4ix171x0h1zn";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-chili";
    rev = "6516d50176c3b34df29003726ef9708813d06271";
    sha256 = "sha256-wxWsdRGC59YzDcSopDRzxg8TfjjmA3LHrdWjepTuzgw=";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm assets/background.jpg
    cp -r ${image} $out/assets/background.jpg
   '';
}
