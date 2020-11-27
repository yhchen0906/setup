from gi import require_version
require_version('Gtk', '3.0')
require_version('Nautilus', '3.0')
from gi.repository import Nautilus, GObject

import subprocess

class CodeMenuProvider(GObject.GObject, Nautilus.MenuProvider):
    def open_with_code(self, menu, files):
        args = ['code']
        for file_info in files:
            args.append(file_info.get_location().get_path())
        subprocess.Popen(args)

    def get_file_items(self, window, files):
        item = Nautilus.MenuItem(
            name='Code::OpenSelected',
            label='Open with Code',
            tip='Open the selected files with Visual Studio Code'
        )
        item.connect('activate', self.open_with_code, files)
        return [item]

    def get_background_items(self, window, current_folder):
        item = Nautilus.MenuItem(
            name='Code::OpenCurrentFolder',
            label='Open with Code',
            tip='Open current folder with Visual Studio Code'
        )
        item.connect('activate', self.open_with_code, [current_folder])
        return [item]
