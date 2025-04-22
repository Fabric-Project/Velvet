
# Velvet

A (very experimental) live code environment for macOS using Swift and Satin

<img width="1898" alt="image" src="https://github.com/user-attachments/assets/189aae96-b848-489e-b635-1e8764c9c81b" />


## Development Setup
                  
Requires:
* XCode / swiftc toolchain installed
* Satin Repository from Fabric checked out to in the folder above this project, linked locally.
* Please use this branch https://github.com/Fabric-Project/Satin/tree/features/live-code-support.

Your code paths should look like

Parent/
- Satin/
- Velvet/

We''ll make this nicer.

## Expectations

Right now Velvet is in very early development. 

It has no document model, and the code you edit and Velvet compiles is hard coded for now on line 39 of `ContentView`. Feel free to use the included `Renderer3D`
file as a template. 

## Next Steps

1 - Set up a template starting file that has the protocol requirements
2 - Set up a document model to load diff files
3 - Maybe think about a swift document package format to let projects be portable and contain assets like shaders etc.



