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
public class DetainersView : Gtk.ScrolledWindow {
    private DetainerSourceList d_source_list;
    private EmptyDetailsView details_view;

    enum Column {
        ICON,
        DETAINER_NAME,
        DETAINER_LOCATION,
        STATUS
    }

    public DetainersView () {
        d_source_list = new DetainerSourceList ();
        details_view = new EmptyDetailsView ();

        var pane = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        pane.set ("wide_handle", false);
        pane.pack1 (d_source_list, false, false);
        pane.pack2 (details_view, true, false);

        d_source_list.detainer_selected.connect ((d) => {
            stdout.printf ("What");
            DetailsView d_view = new DetailsView (d);
            pane.pack2 (d_view, true, false);
        });

        this.show ();
        this.add (pane);
    }
}
}
