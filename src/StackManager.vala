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
public class StackManager : Object {
    static StackManager? instance;

    private Gtk.Stack stack;
    public Gtk.Window main_window;

    private static string WELCOME_VIEW_ID = "welcome-view";
    private static string DETAILS_VIEW_ID = "details-view";
    private static string DETAINERS_VIEW_ID = "detainers-view";
    private static string SETTINGS_VIEW_ID = "settings-view";

    StackManager () {
        stack = new Gtk.Stack ();
        stack.margin_bottom = 4;
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
    }

    public static StackManager get_instance () {
        if (instance == null) {
            instance = new StackManager ();
        }
        return instance;
    }

    public Gtk.Stack get_stack () {
        return this.stack;
    }

    public void load_views (Gtk.Window window) {
        main_window = window;

        // Add all view to the stack via add_named
        stack.add_named(new WelcomeView (), WELCOME_VIEW_ID);
        stack.add_named(new EmptyDetailsView (), DETAILS_VIEW_ID);
        stack.add_named(new DetainersView (), DETAINERS_VIEW_ID);
        stack.add_named(new SettingsView (), SETTINGS_VIEW_ID);

        // Listen for visible screen change
        stack.notify["visible-child"].connect (() => {
            // TODO: Use stack.get_visible_child_name() to change the HeaderBar on child change
        });

        window.add(stack);
    }
}
}
