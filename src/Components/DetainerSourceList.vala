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
    private List<Detainer> detainers;
    private Granite.Widgets.SourceList source_list;
    private Granite.Widgets.SourceList.ExpandableItem title_item;

    construct {
        width_request = 180;
        source_list = new Granite.Widgets.SourceList ();
        add (source_list);

        var detainer_handler = new DetainerHandler ();

        title_item = new Granite.Widgets.SourceList.ExpandableItem ("Detainers");
        source_list.root.add (title_item);
        title_item.collapsible = false;
        title_item.expand_all ();

        detainer_handler.get_detainers ().foreach ((d) => {
           add_detainer (d);
        });

        source_list.item_selected.connect ((item) => {
            if (item == null || !(item is DetainerSourceItem)) {
                return;
            }

            var detainer_item = item as DetainerSourceItem;
            detainer_selected (detainer_item.detainer);
        });
    }

    public DetainerSourceList () {
    }

    private void add_detainer (Detainer d) {
        var detainer_item = new DetainerSourceItem (d);
        title_item.add (detainer_item);
    }
}
}
