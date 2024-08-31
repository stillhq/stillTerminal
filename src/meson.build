sources = files(
  'Main.vala',
  'MainWindow.vala',
)

subdir('data')
subdir('StTerminal')
subdir('StWidgets')
subdir('StPreferences')

dependencies = [
  dependency('glib-2.0'),
  dependency('gee-0.8'),
  dependency('gobject-2.0'),
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('json-glib-1.0'),
  dependency('vte-2.91-gtk4', version: '>= 0.69.0'),

  # This is a hack to get the math library linked in
  meson.get_compiler('c').find_library('m', required : false)
]

executable(
  'stillTerminal',
  sources,
  dependencies: dependencies,
  install: true
)
