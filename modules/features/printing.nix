{
  category = "System software";
  name = "printing";
  software = ["hplip" "gutenprint" "foo2zjs" "epson-escpr2"];

  nixos = {pkgs, ...}: {
    services.avahi = {
      enable = false;
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        hplip
        gutenprint
        foo2zjs
        epson-escpr2
      ];
      openFirewall = false;
    };
  };
}
