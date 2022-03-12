package random.util;

import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import sys.FileSystem;
import sys.io.File;
import FlxUIDropDownMenuCustom;

using StringTools;

/**A (hopefully) simple file browser that allows you to browse for a file in game.

At the moment it just lists the files in a directory. You can filter them by specific extension if needed.

@author devin503
@since 10/3/2022*/
class FlxUIFileBrowser extends FlxUITabMenu {
    var CurrentDirectory:String; // this is set up on creation, you can set the path yourself!
    var ExtensionFilters:Array<String>;
    var FileList:Array<String>;
    var DirectoryDropDown:FlxUIDropDownMenuCustom;
    var _OPENUI:FlxUI;
    var _SAVEUI:FlxUI;
    var BrowserType:Int; // 0 IS SAVE, 1 IS OPEN!
    var tabs = [
        { name: 'File List', label: 'File List' }
    ];
    var FileNameBox:FlxUIInputText;
    var _OpenButton:FlxButton;
    var _CancelButton:FlxButton;
    var _SaveButton:FlxButton;
    var _PreviewButton:FlxButton;
    public function new(StartPath:String, ?Extensions:Array<String>, ?BrowseType:Int) {
        super(null, tabs);
        resize(FlxG.width, FlxG.height);
        if (Extensions != null) {
            ExtensionFilters = Extensions;
        }

        CurrentDirectory = StartPath;
        if (ExtensionFilters != null) {
            FileList = _InitReadDir(CurrentDirectory, ExtensionFilters);
        } else {
            FileList = _InitReadDir(CurrentDirectory);
        }

        if ((BrowseType != null && BrowseType == 0) || BrowseType == null) {
            BrowserType = 0;
        } else {
            BrowserType = 1;
        }

        _CreateUI(BrowserType);
    }

    inline function _InitReadDir(Path:String, ?Filters:Array<String>):Array<String> {
        var DirResults:Array<String> = [];
        var DirectoryFiles = FileSystem.readDirectory(Path);
        if (Filters != null) {
            for (i in 0...DirectoryFiles.length) {
                var ExtensionSplit = DirectoryFiles[i].split('.');
                if (Filters.contains(ExtensionSplit[1])) {
                    DirResults.push(DirectoryFiles[i]);
                } else {
                    trace('Nope, this is a different file. Extension: ' + ExtensionSplit[1]);
                }
            }
        } else DirResults = DirectoryFiles;
        return DirResults;
    }
    inline function _CreateUI(VER:Int) {
        if (VER == 1) {
            setupBrowserUI_OPEN();
        } else { setupBrowserUI_SAVE(); }
    }
    inline function setupBrowserUI_OPEN() {
        _OPENUI = new FlxUI(null, this);
        _OPENUI.name = 'File List';

        DirectoryDropDown = new FlxUIDropDownMenuCustom(10, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(Dir:String) {
            reloadTheFileList(Dir);
            ReloadDirDropdown();
        });
        reloadTheFileList(CurrentDirectory);

        _OPENUI.add(new FlxText(DirectoryDropDown.x, DirectoryDropDown.y - 18, 'Current directory:', 8));
        _OPENUI.add(DirectoryDropDown);
        addGroup(_OPENUI);
    }

    inline function setupBrowserUI_SAVE() {
        _SAVEUI = new FlxUI(null, this);
        _SAVEUI.name = 'File List';

        DirectoryDropDown = new FlxUIDropDownMenuCustom(10, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(Dir:String) {
            reloadTheFileList(Dir);
            ReloadDirDropdown();
        });
        reloadTheFileList(CurrentDirectory);

        _SAVEUI.add(new FlxText(DirectoryDropDown.x, DirectoryDropDown.y - 18, 'Current directory:', 8));
        _SAVEUI.add(DirectoryDropDown);
        addGroup(_SAVEUI);
    }

    function reloadTheFileList(Directory:String) {
        if (ExtensionFilters == null) {
            FileList = _ReadDirectory(Directory);
        } else {
            FileList = _ReadDirectory(Directory, ExtensionFilters);
        }
        CurrentDirectory = Directory;
    }

    inline function _ReadDirectory(Dir:String, ?Filt:Array<String>):Array<String> {
        var ResultingFiles:Array<String> = [];
        var BaseList = FileSystem.readDirectory(Dir);
        if (Filt != null) {
            for (i in 0...BaseList.length) {
                var Splitter = BaseList[i].split('.');
                if (Filt.contains(Splitter[1])) {
                    ResultingFiles.push(BaseList[i]);
                } else {
                    trace('Nope, we don\'t need this. Extension: ' + Splitter[1]);
                }
            }
        } else {
            ResultingFiles = BaseList;
        }
        return ResultingFiles;
    }

    inline function ReloadDirDropdown() {
        if (FileList != null && FileList.length >= 1) {
            DirectoryDropDown.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(FileList, true));
            DirectoryDropDown.selectedLabel = CurrentDirectory;
        } else {
            DirectoryDropDown.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(['WHAT THE FUCK?', 'IF YOU SEE THIS, CLOSE THE BROWSER AND TRY AGAIN. ALSO MAKE AN ISSUE!'], true));
            DirectoryDropDown.selectedLabel = "WHAT THE FUCK?";
        }
    }

}