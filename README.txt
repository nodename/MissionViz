This project has a Carthage dependency on nodename/FileBrowser.

My fork of FileBrowser has been modified to provide two customizations which are used in MissinViz's ViewController:

filter: a predicate that filess must satisfy in order to be shown in the FileBrowser, and

previewFile: a function that provides a ViewController to display when a file is selected in the FileBrowser.

Also the thumbnail image for jpg files in the FileBrowser has been changed to an actual thumbnail rather than a generic JPG thumbnail.
