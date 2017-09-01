//
//  ViewController.swift
//  UdpStreamer
//
//  Created by Osman Mesut Özcan on 1/9/2017.
//  Copyright © 2017 Osman Mesut Özcan. All rights reserved.
//

import UIKit
import AVFoundation
import CocoaAsyncSocket


class ViewController: UIViewController, AVStreamDelegate {
    var pixelBuffer: CVPixelBuffer?
    let udpBuffer = UDPBuffer()

    override func viewDidLoad() {
        super.viewDidLoad()
        UDPSocket.manager.prepare()
        AVStream.manager.prepare()
        AVStream.manager.setDelegate(delegate: self)
        AVStream.manager.start()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didReceiveVideoBuffer(didReceive sampleBuffer: CMSampleBuffer) {
        pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let data: NSData = udpBuffer.pixelToData(buffer: pixelBuffer!)
        UDPSocket.manager.send(data as Data)
    }

    @IBAction func sendPacket(_ sender: Any) {
        let data = "Hello from UDPStreamer!\n".data(using: .utf8)
        UDPSocket.manager.send(data!)
    }
}
