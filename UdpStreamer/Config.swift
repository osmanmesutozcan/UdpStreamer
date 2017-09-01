//
//  Config.swift
//  UdpStreamer
//
//  Created by Osman Mesut Özcan on 1/9/2017.
//  Copyright © 2017 Osman Mesut Özcan. All rights reserved.
//

import Foundation

struct Config {
    struct Server {
        static let addr = "192.168.1.33"
        static let port = UInt16(10010)
    }

    struct Client {
        static let port = UInt16(10011)
    }
}
