{
  self,
  config,
  ...
}: {
  imports = [
    self.darwinModules.core
    self.darwinModules.shell
    self.darwinModules.mac-app-util
    self.darwinModules.docker
    self.darwinModules.aerospace
  ];

  networking.hostName = config.opts.info.name;

  system.keyboard = {
    enableKeyMapping = true;
    userKeyMapping = [
      {
        # ` -> §
        HIDKeyboardModifierMappingSrc = 30064771172;
        HIDKeyboardModifierMappingDst = 30064771125;
      }
      {
        # § -> `
        HIDKeyboardModifierMappingSrc = 30064771125;
        HIDKeyboardModifierMappingDst = 30064771172;
      }
    ];
  };
}
