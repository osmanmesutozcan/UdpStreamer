//
//  UDPBuffer.swift
//  UdpStreamer
//
//  Created by Osman Mesut Özcan on 1/9/2017.
//  Copyright © 2017 Osman Mesut Özcan. All rights reserved.
//

import Foundation
import AVFoundation

class UDPBuffer: NSObject {
    func pixelToData (buffer: CVPixelBuffer) -> NSData {
        let bytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
        let height = CVPixelBufferGetHeight(buffer)
        let width = CVPixelBufferGetWidth(buffer)

        var srcBuffer = CVPixelBufferGetBaseAddress(buffer)
        let dataBuffer: NSData = NSData(bytes: &srcBuffer, length: bytesPerRow)

        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        return dataBuffer
    }
}
