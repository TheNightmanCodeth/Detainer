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
public class App:Granite.Application {

    public static MainWindow window = null;

    construct {
        flags |= ApplicationFlags.HANDLES_OPEN;
        application_id = Constants.APPLICATION_NAME;
        program_name = Constants.APPLICATION_NAME;
        var app_info = new DesktopAppInfo (Constants.DESKTOP_NAME);
    }

    public static int main (string[] args) {
        var app = new Application.App ();
        return app.run (args);
    }

    protected override void activate () {
        new_window ();
    }

    public void new_window () {
        var stack_manager = StackManager.get_instance ();
        if (window != null) {
            window.present ();
            return;
        }

        //Add custom stylesheet
        //weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
        //default_theme.add_resource_path ("/me/jdiggity/detainer");

        //var provider = new Gtk.CssProvider ();
        //provider.load_from_resource ("/me/jdiggity/detainer/application.css");
        //Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        window = new MainWindow (this);
        window.show_all ();
    }
}
}
