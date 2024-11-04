{ pkgs, lib, config, ... }: {
  options = {
    test.enable = lib.mkEnableOption "enables test module"; # Hello
  };

  config = lib.mkIf config.test.enable {
    environment.systemPackages = with pkgs; [ vim ];
  };
}
