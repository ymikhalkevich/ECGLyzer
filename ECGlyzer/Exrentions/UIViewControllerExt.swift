//
//  UIViewControllerExt.swift
//  BleTerminal1
//
//  Created by Yury Mikhalkevich on 2/25/19.
//  Copyright © 2019 Yury Mikhalkevich. All rights reserved.
//

import UIKit

extension  ScanTableViewController {
    
    
    // ZHBlePeripheralDelegate functions
    func didFailToConnectPeripheral(toConnect peripheral : CBPeripheral) {
        print("fail to connect \(peripheral)")
    }
    
    func didDisconnectPeripheral(_ peripheral: CBPeripheral!) {
        print("disconnect \(peripheral!)")
        print("mConnected = \(sharedBLE.mConnected)")
        //  sharedBLE.didDisconnect()
      //  sharedBLE.centralManager.cancelPeripheralConnection(peripheral)
      //  sharedBLE.scanDevice()
      //  sharedBLE.centralManager.scanForPeripherals(withServices: BLEScanUUIDList.scanUUIDList, options: nil)
    }
    
   
    func didFind(_ peripheral: CBPeripheral!, advertisementData: [AnyHashable : Any]!, rssi RSSI: NSNumber!) {
   
        if let name = peripheral.name, let _ = BLEPeripheralNames.nameToConnect[name] {
            print("find \(peripheral!)")
            if BLEPeripheralList.peripheralList.contains(peripheral) != true {
                BLEPeripheralList.peripheralList.append(peripheral)
            }
            
            self.tableView.reloadData()
        }
    }
    
    func didConnect(_ peripheral: CBPeripheral!) {
        print("connect \(peripheral!)")

        if BLEPeripheralList.peripheralList.contains(peripheral) != true {
            BLEPeripheralList.peripheralList.append(peripheral)
        }
      
        sharedBLE.mConnected = true
        self.tableView.reloadData()
    }
    
    func didUpdateBlueToothState(_ central: CBCentralManager!) {
   //    sharedBLE.centralManager = central
        switch sharedBLE.centralManager.state {
        case .unknown:
            print("ble unknown")
        case .unsupported:
            print("ble unsupported")
        case .unauthorized:
            print("ble unauthorized")
        case .resetting:
            print("ble resetting")
        case .poweredOn:
            sharedBLE.scanDevice()
            print("ble powered On")
        case .poweredOff:
            print("ble poweredOff")
        default:
            break
        }
    }
    
    
}

