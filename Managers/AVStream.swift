//
//  AVStream.swift
//  UdpStreamer
//
//  Created by Osman Mesut Özcan on 1/9/2017.
//  Copyright © 2017 Osman Mesut Özcan. All rights reserved.
//

import Foundation
import AVFoundation

protocol AVStreamDelegate: NSObjectProtocol {

}

class AVStream: NSObject {
    static let manager = AVStream()
    var _sessionQueue: DispatchQueue?
    var _session: AVCaptureSession?
    var _videoDeviceInput: AVCaptureDeviceInput?
    var _device: AVCaptureDevice!
    weak var delegate: AVStreamDelegate?

    func prepare() {
        if let session = self._session {
            session.stopRunning()
            self._session = nil
        }

        self._session = AVCaptureSession()
        self.prepareCamera()

        self._sessionQueue = DispatchQueue(label: "me.UdpStreamer")
        self._sessionQueue!.async() {
            var videoDeviceInput: AVCaptureDeviceInput!
            do {
                videoDeviceInput = try AVCaptureDeviceInput(device: self._device)
            } catch {
                NSLog("setCaptureDevice error: \(error.localizedDescription)")
            }

            if (self._session?.canAddInput(videoDeviceInput))! {
                self._session?.addInput(videoDeviceInput)
            }
        }
    }

    func start() {
        if self._session == nil {
            NSLog("AVStream start error: no session running!")
        }

        self._sessionQueue!.async {
            self._session?.startRunning()
        }
    }

    func stop() {
        if self._session == nil {
            NSLog("AVStream start error: no session running!")
        }

        self._sessionQueue!.async {
            self._session?.stopRunning()
        }
    }

    private func prepareCamera() {
        self._session?.sessionPreset = AVCaptureSession.Preset.hd1920x1080

        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        self._device = session.devices.first
    }
}

extension AVStream: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        NSLog(">>> Got Buffer.")
    }
}
