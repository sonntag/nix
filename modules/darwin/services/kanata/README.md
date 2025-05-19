### Keyboard daemon for kanata

Download the [Karabiner-DriverKit-VirtualHIDDevice](https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/tree/main/dist) manually and install the package.
Afterwards make sure it is enabled in System Settings, General -> Login Items & Extensions -> Driver Extensions (At the bottom).

Also make sure that `/run/current-system/sw/bin/kanata` is added as an allowed application under Security & Privacy -> Input Monitoring.

Lastly, go to Keyboard -> Keyboard Shortcuts... -> Modifier Keys, and make sure the Karabiner DriverKit VirtualHIDDevice is selected as the keyboard.

The nix configuration should handle the rest, for any problems check out [this discussion](https://github.com/jtroo/kanata/discussions/1537) in the kanata repository.
