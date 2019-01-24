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

    public Authenticate (string title, string description, AuthType type) {
        Gtk.Entry pass_entry = new Gtk.Entry ();
        Gtk.Entry confirmation_entry = new Gtk.Entry ();
        Gtk.Entry title_entry = new Gtk.Entry ();
        Granite.MessageDialog message_dialog;
        string confirm_button = "Authenticate";

        message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
            title,
            description,
            "dialog-password",
            Gtk.ButtonsType.NONE
        );

        pass_entry.visibility = false;
        pass_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, "dialog-password-symbolic");
        pass_entry.placeholder_text = "Password...";
        pass_entry.show ();

        if (type == AuthType.CREATE) {
            title_entry.visibility = true;
            title_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, "emblem-default-symbolic");
            title_entry.placeholder_text = "Name";
            title_entry.show ();

            confirmation_entry.visibility = false;
            confirmation_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.PRIMARY, "dialog-password-symbolic");
            confirmation_entry.placeholder_text = "Confirm password";
            confirmation_entry.show ();

            confirm_button = "Create Detainer";
        }

        var cancel = (Gtk.Button) message_dialog.add_button ("Cancel", 6666);
        var create = (Gtk.Button) message_dialog.add_button (confirm_button, 9090);

        var password = pass_entry.get_text ();

        create.get_style_context ().add_class ("suggested-action");
        create.clicked.connect (() => {
            switch (type) {
                case AuthType.CREATE: {
                    var confirm = confirmation_entry.get_text ();
                    if (confirm == password) {
                        detainer_handler.create_detainer (password, title_entry.get_text ());
                    }
                }
                break;
            }
        });

        cancel.clicked.connect (() => {
            message_dialog.destroy ();
        });

        if (type == AuthType.CREATE) message_dialog.custom_bin.add (title_entry);
        message_dialog.custom_bin.add (pass_entry);
        if (type == AuthType.CREATE) message_dialog.custom_bin.add (confirmation_entry);

        message_dialog.run ();
    }
}
}
