//
//  ViewController.swift
//  UdpStreamer
//
//  Created by Osman Mesut Özcan on 1/9/2017.
//  Copyright © 2017 Osman Mesut Özcan. All rights reserved.
//

import UIKit
import CocoaAsyncSocket


class ViewController: UIViewController, GCDAsyncUdpSocketDelegate {
    //FIXME: Extract these to a config class
    let _serverAddr = "192.168.1.33"
    let _serverPort = UInt16(10010)
    let _clientPort = UInt16(10010)

    var _socket: GCDAsyncUdpSocket?
    var socket: GCDAsyncUdpSocket? {
        get {
            if self._socket == nil {
                let port = self._clientPort
                let sock = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
                do {
                    try sock.bind(toPort: port)
                    NSLog("socket bound to port: \(port)")
                    try sock.beginReceiving()
                } catch {
                    NSLog(">>> Error while initing socket: \(error.localizedDescription)")
                    sock.close()
                    return nil
                }
                // ??
                self._socket = sock
            }
            return self._socket
        }
        set {
            self._socket?.close()
            self._socket = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    deinit {
        self.socket = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendPacket(_ sender: Any) {
        let str = "Hello from UDPStreamer!\n"

        guard socket != nil else {
            return
        }

        self.socket?.send(str.data(using: String.Encoding.utf8)!, toHost: self._serverAddr, port: self._serverPort, withTimeout: 2, tag: 0)

        NSLog("Data sent: \(str)")
        self.view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        guard let dataStr = String(data: data, encoding: String.Encoding.utf8) else {
            NSLog(">>> Data recieved, but cannot be converted to String.")
            return
        }
        NSLog("Data recieved: \(dataStr)")
    }
}
