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
public class DetainerSourceList : Gtk.ScrolledWindow {
    public signal void detainer_selected (Detainer detainer);
    private DetainerHandler detainer_handler;
    private List<Detainer> detainers;
    private Granite.Widgets.SourceList source_list;

    construct {
        width_request = 150;
        source_list = new Granite.Widgets.SourceList ();

        add (source_list);

        detainer_handler = new DetainerHandler ();
        detainers = detainer_handler.get_detainer_info ();

        var detainers_root = new CategoryItem ("Detainers");

        foreach (Detainer d in detainers) {
            DetainerSourceItem this_item = new DetainerSourceItem (d);
            detainers_root.add (this_item);
        }

        source_list.item_selected.connect ((item) => {
            stdout.printf ("yo");
            if (item == null || !(item is DetainerSourceItem)) {
                return;
            }
            var detainer_item = item as DetainerSourceItem;
            detainer_selected  (detainer_item.detainer);
        });
    }

    public DetainerSourceList () {
    }
}
}
