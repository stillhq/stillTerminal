sources = files(
  'Main.vala',
  'MainWindow.vala',
)

subdir('StTerminal')
subdir('StWidgets')

dependencies = [
  dependency('glib-2.0'),
  dependency('gee-0.8'),
  dependency('gobject-2.0'),
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('json-glib-1.0'),
  dependency('vte-2.91-gtk4', version: '>= 0.69.0'),
]

executable(
  'stillTerminal',
  sources,
  dependencies: dependencies,
  install: true
)
