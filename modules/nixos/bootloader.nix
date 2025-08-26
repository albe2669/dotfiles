{...}: {
  boot = {
    loader = {
      grub = {
        enable = true;
        useOSProber = true;
      };
    };
  };
}
