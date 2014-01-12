#About OCAUtilities
==============

OCAUtilities is a set of classes that perform useful functions.

Most are implemented as category extensions.


##Quick install
=============

Coming - add instructions to use as a Git Subproject

 1. Add the libOCAUtilities.a file to your target(s).
 2. Add the .h file using the new file. Be sure to Check the "Copy items into destination groups's folder" checkbox.

##Using OCAUtilities
==============

Coming - add instructions to integrate

###Installation tips
-----------------

To keep up to date, issue `git pull` either from the terminal or within Xcode. If you've included OCAUtilities as a SubProject and added it as a dependency of your main application, it will rebuild automatically.

###Integrating with Xcode
-----------------

Coming - add instructions to add build dependency.


###Troubleshooting
---------------

Have problems? This is what you can do to troubleshoot:

TBD

###Minimum system requirements
---------------------------

- Xcode 5 or greater for compiling
- iOS 7 or greater

###License
=======

OCAUtilities is licensed under MIT license.

##Build Instructions
 
 Building the library is a bit complex. Summary below, details [here](https://www.altamiracorp.com/blog/employee-posts/creating-and-using-static-libraries-for-iphone-using-xcode-4).
 
 1. Build for device.
 2. Right-click the .a Product and Show In Finder.
 3. Rename to indicate its the device build - e.g., libOCAUtilities_device.a
 4. Repeat 1-3 building for simulator and rename the product libOCAUtilities_simulator.a
 5. Put the two .a files into the same folder
 5. In terminal, navigate to the folder containing the libraries and run the following command:
    lipo -create libOCAUtilities_device.a libOCAUtilities_simulator.a -output libOCAUtilities.a
 6. Copy OCAUtilities.h into the same folder.
 7. This folder now contains the static library and the associated .h file
 8. Copy the folder to the O'Mara Consulting Associates Library container.

##Build Documentation
 
 1. I use AppleDoc from GentleBtyes to create Apple-style API documentation from comments.
 2. Refer to the [AppleDoc](http://gentlebytes.com/appledoc/) page for details.
 3. To simplify useage as a library, all the header information is embedded in OCAUtilities.h rather than distributed to .h files corresponding to their .m counterparts.
 4. To build the documentation just choose the GenDocumentation build option.
 
 
##Publish Documentation

 1. TBD

