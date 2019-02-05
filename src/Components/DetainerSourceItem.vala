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
public class DetainerSourceItem : Granite.Widgets.SourceList.Item {
    public Detainer detainer;

    public DetainerSourceItem (Detainer detainer) {
        update_info (detainer);
    }

    public void update_info (Detainer d) {
        name = d.name;
        detainer = d;

        if (d.mounted) {
            icon = new ThemedIcon ("process-completed")
        } else {
            icon = new ThemedIcon ("system-lock-screen");
        }        
    }
}
}
