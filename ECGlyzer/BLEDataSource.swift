//
//  File.swift
//  BLETerminal
//
//  Created by Yury Mikhalkevich on 2/21/19.
//  Copyright © 2019 Yury Mikhalkevich. All rights reserved.
//

import Foundation

class BLEDataSourceOnUUID  {
    static var advertData = [String:Any]()
    static var rssi = NSNumber()
   // static var peripheral = CBPeripheral()
}

class BLEPeripheralNames{
    static var nameToConnect = [String:Int]()
}

class BLEPeripheralList {
    static var peripheralList = [CBPeripheral]()
    static var currentPeripheral = Int()
}

