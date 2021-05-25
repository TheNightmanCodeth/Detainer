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
    private DetailsView details_view;

    enum Column {
        ICON,
        DETAINER_NAME,
        DETAINER_LOCATION,
        STATUS
    }

    public DetainersView () {
        d_source_list = DetainerSourceList.get_instance ();
        details_view = new DetailsView ();

        var details_stack = new Gtk.Stack ();
        details_stack.set_transition_type (Gtk.StackTransitionType.CROSSFADE);

        details_stack.add_named (new EmptyDetailsView (), "no-detainer-selected");
        details_stack.add_named (details_view, "detainer-details");

        var pane = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        pane.set ("wide_handle", false);
        pane.pack1 (d_source_list, false, false);
        pane.pack2 (details_stack, true, false);

        d_source_list.detainer_selected.connect ((d) => {
            if (details_stack.visible_child_name != "detainer-details") {
                details_stack.set_visible_child_name ("detainer-details");
            }
            details_view.load_detainer.begin (d);
        });

        this.show ();
        this.add (pane);
    }
}
}
