# Connecting to eduroam

> [!CAUTION]
> This guide only applies to iwd or iwd backed NetworkManager. Default Nix uses wpa_supplicant. I have yet to make wpa_supplicant and eduroam work, i suggest switching to iwd.

This is a step by step guide to connect to eduroam using NetworkManager backed by iwd.

## Download and run the CAT installer
First download and run the CAT installer from [here](https://cat.eduroam.org/)

When downloaded run it using `python3` and insert your credentials, if it says it's not able to connect to NetworkManager don't worry. We technically only need the certificate.

When run check that the file `~/.config/cat_installer/ca.pem` exists.

## Setup IWD
First copy the certificate:
```bash
sudo cp ~/.config/cat_installer/ca.pem /var/lib/iwd/ca.pem
```

Now create the file `/var/lib/iwd/eduroam.8021x` with the following content, replacing everything in `<>` so `<username>` should be replaced to be `albn`. The password is the password for your ITU user.

If you're not an ITU student, see below.
```
[Security]
EAP-Method=PEAP
EAP-Identity=<username>@itu.dk
EAP-PEAP-CACert=/var/lib/iwd/ca.pem
EAP-PEAP-ServerDomainMask=network.itu.dk
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=<username>@itu.dk
EAP-PEAP-Phase2-Password=<password>

[Settings]
Autoconnect=true
```

### Config for non ITU users
All of the values for the config can be extracted from the installer. The `Config.xxxx` values can be found at the bottom of the file.

- EAP-Method: `Config.eap_outer`
- EAP-Identity: Your username
- EAP-PEAP-CACert: Where you moved the certificate to
- EAP-PEAP-ServerDomainMask: `Config.servers[0]`
    - If the server has a prefix, such as `DNS:`, remove that
- EAP-PEAP-Phase2-Method: `Config.eap_inner`
- EAP-PEAP-Phase2-Identity: Your username
- EAP-PEAP-Phase2-Password: Your password
