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
    remapCapsLockToControl = false; # set other options here if needed
    userKeyMapping = [
      {
        # Globe (fn) → Command
        HIDKeyboardModifierMappingSrc = 1095216660483; # 0xFF00000003
        HIDKeyboardModifierMappingDst = 1095216660480; # 0xFF00000000 (left command...
      }
    ];
  };
}
