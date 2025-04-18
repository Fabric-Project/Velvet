                                                    
//
//  Render3D.swift
//  Velvet
//
//  Created by Anton Marini on 4/18/25.
// 
      
import Combine
import Metal
import MetalKit
import Satin
    
@_cdecl("createRenderer")
public func createRenderer() -> UnsafeMutableRawPointer {
    print("Creating Renderer3D...")
    return Unmanaged.passRetained(Renderer3D()).toOpaque()
}

//@_objcRuntimeName(Renderer3D)
public final class Renderer3D: MetalViewRenderer {
    public override init() {
        print("🧪 Renderer3D init")
        super.init()
        print("Renderer3D initializer id: \(self.id)")

    }
    private let _uuid = UUID()
    final public override var id: String
    {
        _uuid.uuidString
    }
    

    final public override func draw(renderPassDescriptor: MTLRenderPassDescriptor, commandBuffer: MTLCommandBuffer) {
        print("🧪 Renderer3D draw called")
    }
}

//
//@_cdecl("retainRendererType")
//public func retainRendererType() {
//    _ = Renderer3D.self
//}
