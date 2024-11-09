# stillTerminal

A tabbed terminal emulator build for stillOS.
Right now it supports custom themes and profiles, in the future it will support integrating with ssh and distrobox containers.

![image](https://github.com/user-attachments/assets/ea528cb0-2905-4e87-9b29-37c992a18c19)

A terminal emulator for stillOS that integrates with containers.

## Build instructions:

```bash
$ meson build
$ ninja -C build
$ build/stillTerminal
```

## Dependencies:
```
  dependency('glib-2.0'),
  dependency('gee-0.8'),
  dependency('gobject-2.0'),
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('json-glib-1.0'),
  dependency('vte-2.91-gtk4', version: '>= 0.69.0'),
```
