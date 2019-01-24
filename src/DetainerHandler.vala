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
public class DetainerHandler : Object {
    private string result;
    private string error;
    private string crypt_dir = Environment.get_home_dir () + "/.detainer/crypt";
    private int status;

    /*-
     * Creates an empty detainer in the ~/.detainer/detainers directory. The crypt
     * folder is stored in ~/.detainer/detainers/crypt/ and stores the encrypted data.
     * When the crypt folder is mounted it is located (by default) in the 
     * ~/.detainers/ directory. For more info on `gocryptfs` go to the 
     * [[https://nuetzlich.net/gocryptfs/|gocryptfs homepage.]]
     *
     * @param password - The password to use when creating the detainer
     * @param name     - The name to give the detainer.
     * @param path     - Optional, default is ~/Detainers. Can be any directory
     *                   that the current user owns.
     *
     * @returns        - true/false based on success of operation.
     */
    public bool create_detainer (string password, string name, owned string? path = null) {
        if (path == null || path == "") {
            path = Environment.get_home_dir () + "/Detainers/" + name;
        }

        try {
            /* Make the crypt directory */
            if (!File.new_for_path (path).make_directory_with_parents ()) {
                new Alert ("An Error Occured", error);
                return false;
            }
        } catch (Error e) {
            new Alert ("An Error Occured", e.message);
            return false;
        }

        try {
            /* Make the detainer directory if it doesn't exist */
            if (!FileUtils.test (path, FileTest.IS_DIR)) {
                if (!File.new_for_path (path).make_directory_with_parents ()) {
                    new Alert ("An Error Occured", error);
                    return false;
                }
            } else if (File.new_for_path (path).enumerate_children ("standard::*",FileQueryInfoFlags.NOFOLLOW_SYMLINKS).next_file () == null) {

            }
        } catch (Error e) {
            new Alert ("An Error Occured", e.message);
            return false;
        }

        /* Make the gocryptfs folder */
        try {
            Process.spawn_command_line_sync ("echo \"" + password + "\" | " +
                                        "gocryptfs -init -q -- " + crypt_dir + "/" + name,
                                        out result, out error, out status);
            if (error != null && error != "") {
                new Alert ("An error occured", error);
                error = null;
            }
        } catch (SpawnError e) {
            new Alert ("An error occured", e.message);
        }
        return true;
    }
}
}
