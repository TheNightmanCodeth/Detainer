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
public class MainWindow : Gtk.Window {
    private StackManager stack_manager = StackManager.get_instance ();
    private DetainerHandler detainer_handler = new DetainerHandler ();
    private HeaderBar header_bar = HeaderBar.get_instance ();
    private uint configure_id;

    public MainWindow (Gtk.Application application) {
        Object (application: application,
                icon_name: Constants.APPLICATION_NAME,
                height_request: Constants.APPLICATION_HEIGHT,
                width_request: Constants.APPLICATION_WIDTH);
    }

    construct {
        var style_context = get_style_context ();
        style_context.add_class (Gtk.STYLE_CLASS_VIEW);
        style_context.add_class ("rounded");

        set_titlebar (header_bar);

        stack_manager.load_views (this);

        if (!(detainer_handler.get_detainers ().length () < 1)) {
            stack_manager.get_stack ().set_visible_child_name ("detainers-view");
        }
    }
}
}
