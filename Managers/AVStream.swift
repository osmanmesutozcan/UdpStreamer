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
    func didReceiveVideoBuffer(didReceive sampleBuffer: CMSampleBuffer) -> Void
}

class AVStream: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    static let manager = AVStream()
    var _sessionQueue: DispatchQueue?
    var _session: AVCaptureSession?
    var _device: AVCaptureDevice!
    private weak var delegate: AVStreamDelegate?

    func prepare() {
        if let session = self._session {
            session.stopRunning()
            self._session = nil
        }

        self._session = AVCaptureSession()
        self.prepareCamera()

        self._sessionQueue = DispatchQueue(label: "me.AVStream.AVSession")
        self._sessionQueue!.async() {
            var videoDeviceInput: AVCaptureDeviceInput!
            var videoCaptureOutput: AVCaptureVideoDataOutput!

            do {
                videoDeviceInput = try AVCaptureDeviceInput(device: self._device)
            } catch {
                NSLog("setCaptureDevice error: \(error.localizedDescription)")
            }

            if (self._session?.canAddInput(videoDeviceInput))! {
                self._session?.addInput(videoDeviceInput)
            }

            videoCaptureOutput = AVCaptureVideoDataOutput()
            if (self._session?.canAddOutput(videoCaptureOutput))! {
                self._session?.addOutput(videoCaptureOutput)
                videoCaptureOutput.setSampleBufferDelegate(self, queue: self._sessionQueue)
            }
        }
    }

    func setDelegate(delegate: AVStreamDelegate?) {
        if (self.delegate) != nil {
            self.delegate = nil
        }
        self.delegate = delegate
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

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.delegate?.didReceiveVideoBuffer(didReceive: sampleBuffer)
    }

    private func prepareCamera() {
        self._session?.sessionPreset = AVCaptureSession.Preset.vga640x480

        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        self._device = session.devices.first
    }
}
