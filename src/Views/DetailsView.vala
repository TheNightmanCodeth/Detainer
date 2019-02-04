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

    public DetailsView (Detainer? d = new Detainer ("NULL", "NULL", false)) {
        this.detainer = d;
        Gtk.Image icon = new Gtk.Image.from_icon_name ("system-lock-screen", Gtk.IconSize.DIALOG);
        Gtk.Label name = new Gtk.Label (d.name);
        name.get_style_context ().add_class ("h3");
        Gtk.Label location = new Gtk.Label (d.location);
        location.get_style_context ().add_class ("h4");

        Gtk.Grid info_grid = new Gtk.Grid ();
        info_grid.attach (icon, 0, 0, 2, 2);
        info_grid.attach (name, 2, 0, 4, 1);
        info_grid.attach (location, 2, 1, 4, 1);

        this.show ();
        this.add (info_grid);
    }
}
}