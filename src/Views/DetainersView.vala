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
    private StackManager stack_manager = StackManager.get_instance ();
    private DetainerHandler detainer_handler = new DetainerHandler ();
    private Gtk.Label label;

    enum Column {
        ICON,
        DETAINER_NAME,
        DETAINER_LOCATION,
        STATUS
    }

    public DetainersView () {
        var tree_view = new Gtk.TreeView ();
        this.setup_treeview (tree_view);
        tree_view.expand = true;

        label = new Gtk.Label ("");

        var grid = new Gtk.Grid ();

        grid.attach (tree_view, 0, 0, 1, 1);
        grid.attach (label, 0, 1, 1, 1);

        var selection = tree_view.get_selection ();
        selection.changed.connect (this.on_changed);

        this.show ();
        this.add (grid);
    }

    void on_changed (Gtk.TreeSelection selection) {
        Gtk.TreeModel model;
        Gtk.TreeIter iter;
        string name;
        string location;

        if (selection.get_selected (out model, out iter)) {
            model.get (iter,
                            Column.DETAINER_NAME, out name,
                            Column.DETAINER_LOCATION, out location);
            label.set_text ("\n" + name);
        }
    }

    private void setup_treeview (Gtk.TreeView tree) {
        var listmodel = new Gtk.ListStore (4, typeof (Gdk.Pixbuf),
                                           typeof (string),
                                           typeof (string),
                                           typeof (Gdk.Pixbuf));
        tree.set_model (listmodel);

        var text_cell = new Gtk.CellRendererText ();
        var icon_cell = new Gtk.CellRendererPixbuf ();

        text_cell.set ("weight_set", true);
        text_cell.set ("weight", 700);

        var icon_column = new Gtk.TreeViewColumn.with_attributes ("", icon_cell,
                                                                  "pixbuf", Column.ICON);
        var name_column = new Gtk.TreeViewColumn.with_attributes ("Detainer", text_cell,
                                                                  "text", Column.DETAINER_NAME);
        var loca_column = new Gtk.TreeViewColumn.with_attributes ("Location", new Gtk.CellRendererText (),
                                                                  "text", Column.DETAINER_LOCATION);
        var mount_column = new Gtk.TreeViewColumn.with_attributes ("Mounted", icon_cell,
                                                                   "pixbuf", Column.STATUS);

        mount_column.set_fixed_width (20);
        icon_column.set_fixed_width (20);

        tree.insert_column (icon_column, -1);
        tree.insert_column (name_column, -1);
        tree.insert_column (loca_column, -1);
        tree.insert_column (mount_column, -1);
        
        Gtk.TreeIter iter;
        var icon_theme = Gtk.IconTheme.get_default();
        foreach (Detainer d in detainer_handler.get_detainer_info ()) {
            listmodel.append (out iter);
            listmodel.set (iter,
                           Column.ICON, icon_theme.load_icon ("system-lock-screen", 16, 0),
                           Column.DETAINER_NAME, d.name,
                           Column.DETAINER_LOCATION, d.location,
                           Column.STATUS, icon_theme.load_icon ("process-completed", 16, 0));
        }
    }
}
}
