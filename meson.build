project('me.jdiggity.detainer', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

executable(
    meson.project_name(),
    'src/Components/DetainerSourceItem.vala',
    'src/Components/DetainerSourceList.vala',
    'src/Components/FieldEntry.vala',
    'src/Components/HeaderBar.vala',
    'src/Components/PersistentPlaceholderEntry.vala',
    'src/Dialogs/Alert.vala',
    'src/Dialogs/Authenticate.vala',
    'src/Views/DetailsView.vala',
    'src/Views/DetainersView.vala',
    'src/Views/EmptyDetailsView.vala',
    'src/Views/SettingsView.vala',
    'src/Views/WelcomeView.vala',
    'src/Application.vala',
    'src/Constants.vala',
    'src/DetainerHandler.vala',
    'src/MainWindow.vala',
    'src/StackManager.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite')
    ],
    install: true
)

#subdir('data')
#subdir('po')

#
#install_data(
#    join_paths('data', meson.project_name() +'.desktop'),
#    install_dir: join_paths(get_option('datadir'), 'applications')
#)

#install_data(
#    join_paths('data', meson.project_name() + '.appdata.xml'),
#    install_dir: join_paths(get_option('datadir', 'metainfo')
#)

