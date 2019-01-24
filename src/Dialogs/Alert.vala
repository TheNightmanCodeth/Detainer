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
public class Alert : Object {
    private StackManager stack_manager = StackManager.get_instance ();

    public Alert (string title, string description) {
        var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (title, description, "dialog-warning");
        message_dialog.transient_for = stack_manager.main_window;
        message_dialog.window_position = Gtk.WindowPosition.CENTER;
        message_dialog.show_all ();

        if (message_dialog.run () == Gtk.ResponseType.CLOSE) {
            message_dialog.destroy ();
        }
    }
}
}
