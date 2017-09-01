//
//  ViewController.swift
//  UdpStreamer
//
//  Created by Osman Mesut Özcan on 1/9/2017.
//  Copyright © 2017 Osman Mesut Özcan. All rights reserved.
//

import UIKit
import CocoaAsyncSocket


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UDPSocket.manager.prepare()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendPacket(_ sender: Any) {
        let data = "Hello from UDPStreamer!\n".data(using: .utf8)
        UDPSocket.manager.send(data!, toHost: Config.Server.addr, port: Config.Server.port)
    }
}
