// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2019-2021 TheNightmanCodeth (https://jdiggity.me)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
namespace Application {
public class Authenticate : Object {
    public enum AuthType {
        CREATE,
        MOUNT
    }

    private DetainerHandler detainer_handler = new DetainerHandler ();
    private Detainer detainer;
    private StackManager stack_manager = StackManager.get_instance ();

    public Authenticate (string title, string description, AuthType type, Detainer? detainer = null) {
        this.detainer = detainer;

        Gtk.Entry pass_entry = new Gtk.Entry ();
        Gtk.Entry confirmation_entry = new Gtk.Entry ();
        Gtk.Entry title_entry = new Gtk.Entry ();
        Granite.MessageDialog message_dialog;

        message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            title,
            description,
            "dialog-password",
            Gtk.ButtonsType.NONE
        );

        pass_entry.visibility = false;
        pass_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, "dialog-password-symbolic");
        pass_entry.placeholder_text = "Password";
        pass_entry.show ();

        var cancel = (Gtk.Button) message_dialog.add_button ("Cancel", 6666);
        var create = (Gtk.Button) message_dialog.add_button ("Confirm", 9090);

        create.get_style_context ().add_class ("suggested-action");

        if (type == AuthType.CREATE) {
            title_entry.visibility = true;
            title_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, "emblem-default-symbolic");
            title_entry.placeholder_text = "Name";
            title_entry.show ();

            confirmation_entry.visibility = false;
            confirmation_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, "dialog-password-symbolic");
            confirmation_entry.placeholder_text = "Confirm password";
            confirmation_entry.show ();

            create.label = "Create";
            create.clicked.connect (() => {
                var confirm = confirmation_entry.get_text ();
                var password = pass_entry.get_text ();
                if (confirm == password) {
                    var new_detainer = new Detainer (title_entry.get_text (), false);
                    new_detainer.create (password);
                    var list = DetainerSourceList.get_instance ();
                    list.add_detainer (new_detainer);
                    message_dialog.destroy ();
                }
            });
        } else if (type == AuthType.MOUNT) {
            create.label = "Authenticate";
            create.clicked.connect (() => {
                detainer.mount (pass_entry.get_text ());
                message_dialog.destroy ();
            });
        }

        cancel.clicked.connect (() => {
            message_dialog.destroy ();
        });

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        if (type == AuthType.CREATE) box.pack_start (title_entry, false, false, 0);
        box.pack_start (pass_entry, false, false, 0);
        if (type == AuthType.CREATE) box.pack_start (confirmation_entry, false, false, 0);
        box.show ();
        message_dialog.transient_for = stack_manager.main_window;
        message_dialog.custom_bin.add (box);

        message_dialog.run ();
    }
}
}
