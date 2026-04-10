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

  # Remap § (ISO key 0x64) ↔ ` ~ (0x35)
  launchd.daemons.remap-tilde = {
    serviceConfig = {
      Label = "org.custom.tilde-switch";
      ProgramArguments = [
        "/usr/bin/hidutil"
        "property"
        "--set"
        ''{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035},{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064}]}''
      ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };
}
