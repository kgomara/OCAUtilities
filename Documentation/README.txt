/*
 SSUtilities
 
 This folder contains useful utilities and Categories used in Somnio iOS projects.
 
 
 
 BUILD INSTRUCTIONS
 
 Building the library is a bit complex. Summary below, details here - http://www.nearinfinity.com/blogs/tyler_vernon/2012/07/17/creating-and-using-static-libraries-for-iphone-using-xcode-4.3.html
 
 1. Build for device.
 2. Right-click the .a Product and Show In Finder.
 3. Rename to indicate its the device build - e.g., libSSUtilities_device.a
 4. Repeat 1-3 building for simulator and rename the product libSSUtilities_simulator.a
 5. Put the two .a files into the same folder
 5. In terminal, navigate to the folder containing the libraries and run the following command:
    lipo -create libSSUtilities_device.a libSSUtilities_simulator.a -output libSSUtilities.a
 6. Copy SSUtilities.h into the same folder.
 7. This folder now contains the static library and the associated .h file
 8. Copy the folder to the Somnio Shared Library container.
 
 To use this library:
 1. Add the libSSUtilities.a file to your target(s).
 2. Add the .h file using the new file. Be sure to Check the "Copy items into destination groups's folder" checkbox.
 
 
 BUILD DOCUMENTATION
 
 1. We use AppleDoc from GentleBtyes to create Apple-style API documentation from comments.
 2. Refer to the AppleDoc page for details: http://gentlebytes.com/appledoc/
 3. To simplify useage as a library, all the header information is embedded in SSUtilities.h rather than distributed to .h files corresponding to their .m counterparts.
 4. To build the documentation just choose the GenDocumentation build option.
 
 
 PUBLISH DOCUMENTATION
 1. There is a known bug in amazon's s3 web server that converts '+' to a space. This conflicts with Apple's convention for naming categories - e.g. NSDate+SSUtilities. 
 2. The work-around is to manually fix the Category references in somnio_cdn_web/ssutilities/Documentation/html/index.html, substituting '%2b' for the '+' character in the hrefs.
 3. When you are ready to publish go to Somnio's Amazon control panel and upload Documentation/html contents to somnio_cdn_web/ssutilities/Documentation.
 
 */