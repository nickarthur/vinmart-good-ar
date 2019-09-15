//
//  ViewController.swift
//  vinmart-good-ar
//
//  Created by Admin on 9/15/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/object.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "ar-resources", bundle: Bundle.main) else {
            print("Not found images.")
            return
        }
        configuration.trackingImages = trackedImages

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else {
            return
        }
        
        // Container
        guard let container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false) else {
            print("Not found container.")
            return
        }
        container.removeFromParentNode()
        node.addChildNode(container)
        
        // Video
        let videoURL = Bundle.main.url(forResource: "vinmart-good-video", withExtension: "mp4")!
        let videoPlayer = AVPlayer(url: videoURL)
        let videoScene = SKScene(size: CGSize(width: 1280, height: 676))
        let videoNode = SKVideoNode(avPlayer: videoPlayer)
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        videoNode.yScale = -1.0
        videoNode.play()

        videoScene.addChild(videoNode)

        guard let video = container.childNode(withName: "video", recursively: false) else {
            print("Not found video.")
            return
        }
        video.geometry?.firstMaterial?.diffuse.contents = videoScene
        
    }
}
