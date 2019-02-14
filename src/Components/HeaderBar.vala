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
public class HeaderBar : Gtk.HeaderBar {

    private StackManager stackManager = StackManager.get_instance ();
    private Gtk.Button new_detainer_button = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
    private Gtk.Button settings_button = new Gtk.Button.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
    private Gtk.ToggleToolButton mount_button = new Gtk.ToggleToolButton ();
    private Detainer this_detainer;

    public HeaderBar() {
        Granite.Widgets.Utils.set_color_primary (this, Constants.BRAND_COLOR);


        new_detainer_button.clicked.connect (() => {
            new Authenticate("Create Detainer", "Give your detainer a name and password", Authenticate.AuthType.CREATE);
        });

        mount_button.visible = false;
        var unlock_icon = new Gtk.Image.from_icon_name ("changes_allow", Gtk.IconSize.LARGE_TOOLBAR);
        var lock_icon = new Gtk.Image.from_icon_name ("locked", Gtk.IconSize.LARGE_TOOLBAR);
        mount_button.toggled.connect (() => {
            if (this.mount_button.active) {
                mount_button.tooltip_text = _("Lock " + this_detainer.name);
                mount_button.set_icon_widget (lock_icon);
            } else {
                mount_button.tooltip_text = _("Unlock " + this_detainer.name);
                mount_button.set_icon_widget (unlock_icon);
            }
            mount_button.show_all ();
        });
        DetainerSourceList.get_instance ().detainer_selected.connect ((d) => {
            this_detainer = d;
            if (d.mounted) {
                mount_button.set_icon_widget (unlock_icon);
            } else {
                mount_button.set_icon_widget (lock_icon);
            }
            mount_button.visible = true;
            mount_button.show_all ();
        });
        mount_button.show_all ();

        

        this.show_close_button = true;
        this.pack_start (mount_button);
        this.pack_start (new_detainer_button);
        this.pack_end (settings_button);
    }
}
}
