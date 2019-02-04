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
public class EmptyDetailsView : Gtk.ScrolledWindow {
    public signal void change_view (Detainer d);
    private DetainerHandler detainer_handler = new DetainerHandler ();
    private Detainer detainer;
    private Gtk.Stack stack;

    public EmptyDetailsView (Detainer? detainer = null) {
        this.detainer = detainer;
        this.stack = new Gtk.Stack ();

        var header_label = new Granite.HeaderLabel ("Choose a detainer");
        DetailsView details_view = new DetailsView ();

        stack.add_named (header_label, "choose-detainer");
        stack.add_named (new WelcomeView (), "welcome-screen");

        this.show ();
        this.add (stack);
    }
}
}