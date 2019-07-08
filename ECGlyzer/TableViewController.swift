//
//  ViewController.swift
//  BLETerminal
//
//  Created by Yury Mikhalkevich on 2/20/19.
//  Copyright © 2019 Yury Mikhalkevich. All rights reserved.
//

import UIKit

class ScanTableViewController: UITableViewController {
    
    var sharedBLE = ZHBlePeripheral.sharedUartManager()!
    var barButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .refresh,
                            target: self,
                            action: #selector(addTapped))
        
        sharedBLE.delegate = self as! ZHBlePeripheralDelegate
       // sharedBLE.
        BLEScanUUIDList.addUUIDForScan(uuid: CBUUID(string: "0001"))
        BLEScanUUIDList.addUUIDForScan(uuid: CBUUID(string: "FEE7"))
        BLEPeripheralNames.nameToConnect = ["HW1_FD8E" : 1, "HB2PLUS_4B59": 2, "H9_95E2" : 3]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return BLEPeripheralList.peripheralList.count  //TableDataSource.recString.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel!.text = BLEPeripheralList.peripheralList[indexPath.row].name
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BLEPeripheralList.currentPeripheral = indexPath.row
        sharedBLE.mPeripheral = BLEPeripheralList.peripheralList[indexPath.row]
        sharedBLE.didConnect()
     //   let detailViewController = DetailViewController()
   //     self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    @objc func addTapped() {
        print("ble scan")
        if sharedBLE.centralManager.state == .poweredOn {
            print("ble powered on")
            if (sharedBLE.mConnected == true) {
                sharedBLE.centralManager.cancelPeripheralConnection(sharedBLE.mPeripheral)
            }
           // sharedBLE.scanDevice()
            sharedBLE.centralManager.scanForPeripherals(withServices: BLEScanUUIDList.scanUUIDList, options: nil)
        }
    }
}
