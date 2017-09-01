//
//  UDPSocket.swift
//  UdpStreamer
//
//  Created by Osman Mesut Özcan on 1/9/2017.
//  Copyright © 2017 Osman Mesut Özcan. All rights reserved.
//

import CocoaAsyncSocket

class UDPSocket: NSObject {
    static let manager = UDPSocket()
    var _socket: GCDAsyncUdpSocket?

    func prepare() {
        if let udpSocket = self._socket {
            udpSocket.close()
            self._socket = nil
        }

        self._socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
            try self._socket!.bind(toPort: Config.Client.port)
            try self._socket!.beginReceiving()
        } catch {
            NSLog("UDPSocket prepare error: \(error.localizedDescription)")
            self._socket?.close()
        }
    }

    func send(_ data: Data) {
        self._socket?.send(data, toHost: Config.Server.addr, port: Config.Server.port, withTimeout: -1, tag: 0)
    }
}

extension UDPSocket: GCDAsyncUdpSocketDelegate {
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        NSLog(">>> Data Recieved.")
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        guard let error = error else {
            return
        }
        NSLog("UDPSocket tag: \(tag) error: \(error.localizedDescription)")
    }
}
