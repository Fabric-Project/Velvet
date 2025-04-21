
# Velvet

A (very experimental) live code environment for macOS using Swift and Satin

## Development Setup

Right now Velvet is in an extremely fragile state.

Compilation for the live coding is broken into various phases and hasnt been integrated into a nice setup just yet.
                    
Compiling Velvet requires a few manual and annoying steps.

Requires:
* XCode / swiftc
* Satin Repo from Fabric checked out to in the folder above this project, linked locally https://github.com/Fabric-Project/Satin/tree/features/live-code-support                                                    
                                                    
1. Update the XCode project to build and embed the Satin Dynamic Swift package and build the app.
2. This produces a few files ive not yet figured out how to create proceduraly, namely:
    - Satin.abi.json
    - Satin.private.swiftinterface
    - Satin.swiftdoc
    - Satin.swiftinterface
    - Satin.swiftmodule
    - Satin.swiftsourceinfo
3. Copy those files out of the Build Products directory and keep them for later
4. Remove Satin Dynamic Swift PM Project (do not build or embed)
5. Build `libSatinCore.dylib`:
    - From the Satin folder run:
    ```
    clang++ \
    -std=c++17 \
    -dynamiclib \
    -install_name @rpath/libSatinCore.dylib \
    -o build/libSatinCore.dylib \
    $(find Sources/SatinCore -name "*.mm") \
    -I Sources/SatinCore/include
    ```
6. Build `libSatin.dylib`:
    - From the Satin folder run:
    ```
    swiftc -v \
   -emit-library \
   -target arm64-apple-macos14.0 \
   -module-name Satin \
   $(find Sources/Satin -name "*.swift") \
   -I ./build \
   -L ./build \
   -lSatinCore \
   -o ./build/libSatin.dylib \
   -emit-module-path ./build/Satin.swiftmodule \
   -emit-module-interface-path ./build/Satin.swiftinterface \
   -Xlinker -rpath -Xlinker @loader_path \
   -Xlinker -install_name -Xlinker @rpath/libSatin.dylib \
   -Xcc -I./Sources/SatinCore/include \
   -Xcc -fmodule-map-file=./Sources/SatinCore/include/SatinCore.modulemap \
   -DSWIFT_PACKAGE -j8 \
   -framework Metal -framework MetalKit
    ```
7. You can now run build and run Velvet.app, which should link against the top level build folder which now has the dylibs, but dynamic compilation wont work (yet)
8. Copy to `Velvet.app` `Shared Frameworks` folder:
    - Satin.abi.json
    - Satin.private.swiftinterface
    - Satin.swiftdoc
    - Satin.swiftinterface
    - Satin.swiftmodule
    - Satin.swiftsourceinfo
    - the Satin Includes (headers) folder
9. Copy Satin/Source/Pipelines to `Velvet.app` `Resources` folder

You should now be able to run (without building) and live compile
