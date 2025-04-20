         //
//  Renderer.swift
//  Example
// 
//  Created by Reza Ali on 6/27/20.
//  Copyright © 2020 Hi-Rez. All rights reserved.
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

public func getTime() -> CFAbsoluteTime {
    CFAbsoluteTimeGetCurrent()
}
 
var messages: [String] = []
var startTimes: [CFAbsoluteTime] = []

func start(_ message: String) {
    let count = messages.count
    messages.append(message)
    startTimes.append(getTime())
    let spacing = Array(repeating: "\t", count: count).reduce("") { $0 + $1 }
    print("\(spacing)Starting: \(message)")
}

func end() {
    if let message = messages.popLast(), let startTime = startTimes.popLast() {
        let spacing = Array(repeating: "\t", count: messages.count).reduce("") { $0 + $1 }
        print("\(spacing)Finished: \(message): \(getTime() - startTime)")
    }
}

  

@_objcRuntimeName(Renderer3D)
public final class Renderer3D: MetalViewRenderer {
    let mesh = Mesh(
        label: "Sphere",
        geometry: IcoSphereGeometry(radius: 0.5, resolution: 0),
        material: BasicDiffuseMaterial(hardness: 0.7)
    )

    let intersectionMesh = Mesh(
        label: "Intersection Mesh",
        geometry: IcoSphereGeometry(radius: 0.05, resolution: 2),
        material: BasicColorMaterial(color: [0.0, 1.0, 0.0, 1.0], blending: .disabled),
        visible: false,
        renderPass: 1
    )
    
//    var assetsURL: URL { Bundle.main.resourceURL!.appendingPathComponent("Assets") }
//    var sharedAssetsURL: URL { assetsURL.appendingPathComponent("Shared") }
//    var rendererAssetsURL: URL { assetsURL.appendingPathComponent(String(describing: type(of: self))) }
//    var dataURL: URL { rendererAssetsURL.appendingPathComponent("Data") }
//    var pipelinesURL: URL { rendererAssetsURL.appendingPathComponent("Pipelines") }
//    var texturesURL: URL { rendererAssetsURL.appendingPathComponent("Textures") }
//    var modelsURL: URL { rendererAssetsURL.appendingPathComponent("Models") }

    lazy var startTime = getTime()
    lazy var scene = Object(label: "Scene", [mesh])
    lazy var renderer = Renderer(context: defaultContext)
    lazy var camera = PerspectiveCamera(position: [0, 0, 5], near: 0.1, far: 100.0, fov: 30)
    lazy var cameraController = PerspectiveCameraController(camera: camera, view: metalView)

    public override var sampleCount: Int { 1 }

    public override init() {
        print("Render3D Init")
        super.init()
    }
    
    
    public override func setup() {
        print("Renderer3D Setup...")
        
        mesh.add(intersectionMesh)

        camera.lookAt(target: .zero)

        #if os(visionOS)
        renderer.setClearColor(.zero)
        metalView.backgroundColor = .clear
        #endif
    }

    deinit {
        print("Render3D Deinit")
        cameraController.disable()
    }

    public override func update() {
        cameraController.update()
        mesh.orientation = simd_quatf(angle: Float(getTime() - startTime), axis: simd_normalize(simd_float3.one))
        
        super.update()
    }

    public override func draw(renderPassDescriptor: MTLRenderPassDescriptor, commandBuffer: MTLCommandBuffer) {
        renderer.draw(
            renderPassDescriptor: renderPassDescriptor,
            commandBuffer: commandBuffer,
            scene: scene,
            camera: camera
        )
        
        super.draw(renderPassDescriptor: renderPassDescriptor, commandBuffer: commandBuffer)
    }

    public override func resize(size: (width: Float, height: Float), scaleFactor: Float) {
        camera.aspect = size.width / size.height
        renderer.resize(size)
        
        super.resize(size: size, scaleFactor: scaleFactor)
    }
    

    #if os(macOS)
    public override func mouseDown(with event: NSEvent) {
        intersect(camera: camera, coordinate: normalizePoint(metalView.convert(event.locationInWindow, from: nil), metalView.frame.size))
    }

    #elseif os(iOS)
    public override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        if let first = touches.first {
            intersect(camera: camera, coordinate: normalizePoint(first.location(in: metalView), metalView.frame.size))
        }
    }
    #endif

    func intersect(camera: Camera, coordinate: simd_float2) {
        let results = raycast(camera: camera, coordinate: coordinate, object: scene)
        if let result = results.first {
            intersectionMesh.worldPosition = result.position
            intersectionMesh.visible = true
        }
    }

    func normalizePoint(_ point: CGPoint, _ size: CGSize) -> simd_float2 {
        #if os(macOS)
        return 2.0 * simd_make_float2(Float(point.x / size.width), Float(point.y / size.height)) - 1.0
        #else
        return 2.0 * simd_make_float2(Float(point.x / size.width), 1.0 - Float(point.y / size.height)) - 1.0
        #endif
    }
}


@_cdecl("retainRendererType")
public func retainRendererType() {
    _ = Renderer3D.self
}
