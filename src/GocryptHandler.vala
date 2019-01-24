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
public class GocryptHandler : Object {
    private string result, error;
    private string home_dir = Environment.get_home_dir ();
    private int status;

    /**
     * Creates an empty detainer in the ~/.detainers directory. The crypt
     * folder is stored in ~/.detainers/crypt/ and stores the encrypted data.
     * When the crypt folder is mounted it is located (by default) in the 
     * ~/.detainers/ directory. For more info on `gocryptfs` go to the homepage
     * at https://nuetzlich.net/gocryptfs/
     *
     * @param 
     **/
    public bool create_detainer (string password, string name) {
        // Make the crypt directory
        try {
            Process.spawn_command_line_sync ("mkdir -p " + home_dir + ".detainers/crypt/" + name,
                                        out result,
                                        out error,
                                        out status);

            if (error != null && error != "") {
                new Alert ("An error occured", error);
                error = null;
            }
        } catch (SpawnError e) {
            new Alert ("An error occured", e);
        }

        try {
            Process.spawn_command_line_sync ("mkdir -p " + home_dir + ".detainers/" + name,
                                        out result,
                                        out error,
                                        out status)

            if (error != null && error != "") {
                new Alert ("An error occured", error);
                error = null;
            }
        } catch (SpawnError e) {
            new Alert ("An error occured", e);
        }

        Process.spawn_command_line_sync ("echo \"" + password + "\" | " +
                                    "gocryptfs -init -q -- /usr/local/Detainers/crypt" + name,
                                    out result,
                                    out error,
                                    out status);
    }

    public bool 
}
}
