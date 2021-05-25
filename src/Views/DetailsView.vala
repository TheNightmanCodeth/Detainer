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
using Granite.Widgets;

namespace Application {
public class DetailsView : Gtk.ScrolledWindow {
    private DetainerHandler detainer_handler;
    private Detainer detainer;
    private Gtk.Image icon;
    private Gtk.Label detainer_name;
    private Gtk.Label detainer_comment;
    private Gtk.Switch auto_mount;

    construct {
        icon = new Gtk.Image.from_icon_name ("security-high", Gtk.IconSize.DIALOG);
        icon.valign = Gtk.Align.FILL;
        icon.pixel_size = 128;

        var name_grid = new Gtk.Grid ();
        name_grid.hexpand = true;

        detainer_name = new Gtk.Label (null);
        detainer_name.label = "TITLE";
        detainer_name.hexpand = false;
        detainer_name.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);
        detainer_name.valign = Gtk.Align.START;
        detainer_name.margin_end = 60;
        detainer_name.margin_bottom = 5;

        detainer_comment = new Gtk.Label (null);
        detainer_comment.hexpand = false;
        detainer_comment.label = "Location";
        detainer_comment.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        detainer_comment.valign = Gtk.Align.START;
        detainer_comment.margin_end = 60;
        detainer_comment.margin_start = 12;

        name_grid.attach (detainer_name, 0, 0, 1, 1);
        name_grid.attach (detainer_comment, 0, 1, 5, 1);
        name_grid.margin_top = 20;

        auto_mount = new Gtk.Switch ();
        auto_mount.notify["active"].connect (set_auto_mount);

        var mount_box = new SettingsItem (_("Mount on Boot"), auto_mount, true);

        var settings_grid = new SettingsGrid (_("Settings"));
        settings_grid.add_widget (mount_box);
        settings_grid.margin_top = 10;
        settings_grid.margin_start = 24;
        settings_grid.margin_end = 24;
        
        var mount_button = new Gtk.Button.with_label (_("Mount"));
        mount_button.clicked.connect(() => {
            if (detainer.mounted) {
                detainer.unmount ();
            } else {
                new Authenticate ("Mount Detainer",
                                  "Enter the password for this detainer",
                                  Authenticate.AuthType.MOUNT,
                                  detainer);
            }
            mount_button.label = detainer.mounted ? "Unmount" : "Mount";
        });

        var button_grid = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        button_grid.hexpand = true;
        button_grid.margin_start = 24;
        button_grid.margin_end = 24;
        button_grid.margin_bottom = 14;
        button_grid.pack_end (mount_button, false, false, 0);

        Gtk.Grid info_grid = new Gtk.Grid ();
        info_grid.hexpand = true;
        info_grid.margin_top = 10;

        info_grid.attach (icon, 0, 0, 1, 2);
        info_grid.attach (name_grid, 1, 0, 4, 1);
        info_grid.attach (settings_grid, 0, 2, 5, 1);

        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        main_box.pack_start (info_grid, false, false, 0);
        main_box.pack_end (button_grid, false, false, 0);

        this.add (main_box);
    }

    private void set_auto_mount () {
        /* TODO: Mount detainer on startup */
    }

    public async void load_detainer (Detainer d) {
        this.detainer = d;
        detainer_name.label = d.name;
        detainer_comment.label = d.comment;

        if (d.mounted) {
            icon.icon_name = "security-high";
            icon.pixel_size = 128;
        } else {
            icon.icon_name = "security-medium";
            icon.pixel_size = 128;
        }
    }
}
}
