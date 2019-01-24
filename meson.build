project('me.jdiggity.detainer', 'vala', 'c')

gnome = import ('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@".format (meson.project_name()), language:'c')

asresources = gnome.compile_resources(
    'as-resources', 'data/icons/icons.gresource.xml',
    source_dir: 'data/icons',
    c_name: 'as'
)

executable(
    meson.project_name(),
    'src/Application.vala',
    'src/Constants.vala',
    'src/MainWindow.vala',
    'src/Components/HeaderBar.vala',
    'src/StackManager.vala',
    'src/Views/DetailsView.vala',
    'src/Views/DetainersView.vala',
    'src/SettingsView.vala',
    'src/Dialogs/Authenticate.vala',
    asresources,
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite'),
    ],
    install: true
)

subdir('data')
subdir('po')

install_data(
    join_paths('data', meson.project_name() +'.desktop'),
    install_dir: join_paths(get_option('datadir'), 'applications')
)

install_data(
    join_paths('data', meson.project_name() + '.appdata.xml'),
    install_dir: join_paths(get_option('datadir', 'metainfo')
)

