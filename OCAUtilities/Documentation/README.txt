/*
 OCAUtilities
 
 This folder contains useful utilities and Categories used in O'Mara Consulting Associates iOS projects.
 
 
 
 BUILD INSTRUCTIONS
 
 Building the library is a bit complex. Summary below, details here - http://www.nearinfinity.com/blogs/tyler_vernon/2012/07/17/creating-and-using-static-libraries-for-iphone-using-xcode-4.3.html
 
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
 
 To use this library:
 1. Add the libOCAUtilities.a file to your target(s).
 2. Add the .h file using the new file. Be sure to Check the "Copy items into destination groups's folder" checkbox.
 
 
 BUILD DOCUMENTATION
 
 1. I use AppleDoc from GentleBtyes to create Apple-style API documentation from comments.
 2. Refer to the AppleDoc page for details: http://gentlebytes.com/appledoc/
 3. To simplify useage as a library, all the header information is embedded in OCAUtilities.h rather than distributed to .h files corresponding to their .m counterparts.
 4. To build the documentation just choose the GenDocumentation build option.
 
 
 PUBLISH DOCUMENTATION
 1. TBD
 
 */