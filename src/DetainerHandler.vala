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
    private File store = File.new_for_path (Environment.get_home_dir () + "/Detainer/detainers.txt");
    private string detain_dir = Environment.get_home_dir () + "/Detainer/";
    private int status;

    /*-
     * Gets the list of created detainers from the storefile in ~/Detainers.
     *
     * @returns - The list of detainers as `Detainer` objects.
     */
    public List<Detainer> get_detainers () {
        List<Detainer> detainers = new List<Detainer> ();
        if (FileUtils.test (store.get_path (), FileTest.EXISTS)) {
            var dis = new DataInputStream (store.read ());
            string line;
            while ((line = dis.read_line (null)) != null) {
                string[] data = line.split (":");
                detainers.append (new Detainer (data[0], bool.parse (data[2]), data[1]));
            }
        } else {
            File.new_for_path (detain_dir).make_directory ();
            FileOutputStream os = store.create (FileCreateFlags.NONE);
            os.write ("".data);
        }
        return detainers;
    }

    public Detainer get_detainer_by_name (string name) {
        if (FileUtils.test (store.get_path (), FileTest.EXISTS)) {
            var dis = new DataInputStream (store.read ());
            string line;
            while ((line = dis.read_line (null)) != null) {
                if (line.contains ("name")) {
                    string [] data = line.split (":");
                    return new Detainer (data[0], bool.parse (data[2]), data[1]);
                }
            }
        }
        return null;
    }

    public bool has_detainers () {
        return (!(get_detainers ().length () < 1));
    }
}

public class Detainer : Object {
    public string name;
    public string comment;
    public bool mounted;
    public enum ExitCode {
        SUCCESS,
        DETAINER_EXISTS,
        CREATION_ERROR,
        GCFS_ERROR,
        STORE_ERROR
    }

    private string path;
    private string detain_dir = Environment.get_home_dir () + "/Detainer/";
    private string crypt_dir = Environment.get_home_dir () + "/Detainer/crypt/";
    private File store = File.new_for_path (Environment.get_home_dir () + "/Detainer/detainers.txt");

    public Detainer (string name, bool mounted, string comment = "A secure container") {
        this.name = name;
        this.comment = comment;
        this.mounted = mounted;
        this.path = Environment.get_home_dir () + "/Detainer/" + name +"/";
    }

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
    public ExitCode create (string password) {
        var dis = new DataInputStream (store.read ());
        string line;

        while ((line = dis.read_line (null)) != null) {
            if (line.contains (this.name)) {
                return ExitCode.DETAINER_EXISTS;
            }
        }

        try {
            /* Make the crypt directory */
            if (!File.new_for_path (crypt_dir + name).make_directory_with_parents ()) {
                new Alert ("An Error Occured", "Couldn't create file");
                return CREATION_ERROR;
            }
        } catch (Error e) {
            new Alert ("An Error Occured", e.message);
            return CREATION_ERROR;
        }

        try {
            /* Make the detainer directory if it doesn't exist */
            if (!FileUtils.test (path, FileTest.IS_DIR)) {
                if (!File.new_for_path (path).make_directory_with_parents ()) {
                    new Alert ("An Error Occured", "Couldn't create detainer directory");
                    return CREATION_ERROR;
                }
            } else {
                return ExitCode.CREATION_ERROR;
            }
        } catch (Error e) {
            new Alert ("An Error Occured", e.message);
            return ExitCode.CREATION_ERROR;
        }

        /* Make the gocryptfs detainer */
        try {
            string[] spawn_args = {"gocryptfs", "-init", "-q", "--", crypt_dir + name};
            string[] spawn_env = Environ.get ();
            Pid child_pid;

            int stdin;
            int stdout;
            int stderr;

            Process.spawn_async_with_pipes ("/",
                spawn_args, spawn_env,
                SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
                null, out child_pid, out stdin, out stdout, out stderr);

            FileStream input = FileStream.fdopen (stdin, "w");
            input.write (password.data);

            ChildWatch.add (child_pid, (pid, status) => {
                Process.close_pid (pid);
            });
        } catch (SpawnError e) {
            new Alert ("An error occured", e.message);
            return ExitCode.GCFS_ERROR;
        }

        /* Add this detainer to the list in ~/Detainers/detainers.txt */
        try {
            if (!FileUtils.test (store.get_path (), FileTest.EXISTS)) {
                store.create (FileCreateFlags.NONE);
            } 
            FileOutputStream os = store.append_to (FileCreateFlags.NONE);
            os.write ((name + ":" + path + ":" + "false" + "\n").data);
        } catch (Error e) {
            new Alert ("An error occured", "Couldn't write to store file");
            return ExitCode.STORE_ERROR;
        }
        return ExitCode.SUCCESS;
    }

    public ExitCode mount (string password) {
        this.mounted = true;

        /* Copy the file to temporary */
        var destination = File.new_for_path (detain_dir +"/detainers.new");
        var dis = new DataInputStream (store.read ());
        string line;
        FileOutputStream os = destination.append_to (FileCreateFlags.NONE);

        while ((line = dis.read_line (null)) != null) {
            if (!line.contains (name)) {
                os.write ((line + "\n").data);
            } else {
                os.write ((name + ":" + comment + 
                           ":" + mounted.to_string () + "\n").data);
            }
        }

        /* Mount the detainer */
        try {
            string[] spawn_args = {"gocryptfs", "-q", "--", crypt_dir + name, path};
            string[] spawn_env = Environ.get ();
            Pid child_pid;

            int stdin;
            int stdout;
            int stderr;

            Process.spawn_async_with_pipes ("/",
                spawn_args, spawn_env,
                SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
                null, out child_pid, out stdin, out stdout, out stderr);

            FileStream input = FileStream.fdopen (stdin, "w");
            input.write (password.data);

            ChildWatch.add (child_pid, (pid, status) => {
                Process.close_pid (pid);
            });

            return ExitCode.SUCCESS;
        } catch (SpawnError e) {
            new Alert ("An error occured", e.message);
            return ExitCode.GCFS_ERROR;
        }

    }
}
}
