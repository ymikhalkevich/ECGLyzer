//
//  DeviceTableViewController.swift
//  BleTerminal1
//
//  Created by Yury Mikhalkevich on 2/28/19.
//  Copyright © 2019 Yury Mikhalkevich. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController, ZHBlePeripheralDelegate {
    
    var chart: LineChartView!
    var dataEntryes = [ChartDataEntry]()
    var ppgDataEntryes = [ChartDataEntry]()
    var leedOff = false
    var timerLable: UILabel!
    var timeCounter = 3.0
    
    var timer: Timer!
    
    var sharedBLE1 = ZHBlePeripheral.sharedUartManager()!
    var command = ZHSendCmdTool.shareIntance()!
    var isStartedECG = false
    
    var ecgData = [Double]()
    var ppgData = [Double]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(playTapped))
        
        self.navigationItem.title = sharedBLE1.mPeripheral.name
        
        self.view.backgroundColor = .white
        sharedBLE1.delegate = self
        sharedBLE1.healthDataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        chart = ChartView.setUp(forView: view)
        chart.isHidden = true
        timerLable = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        timerLable.translatesAutoresizingMaskIntoConstraints = false
        timerLable.textAlignment = .center
        timerLable.textColor = UIColor.gray
        timerLable.font = timerLable.font.withSize(70)
        timerLable.text = "\(Int(timeCounter))"
        view.addSubview(timerLable)
        
        timerLable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timerLable.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setDataValue(_ count: Int) {
        DispatchQueue.main.async {
            var index = 0
            let devider = Int(self.ecgData.count / self.ppgData.count)
            print(devider, self.ecgData.count, self.ppgData.count, self.ppgData.count * devider )
            for (i, ecg) in self.ecgData.enumerated() {
                self.dataEntryes.append(ChartDataEntry(x: Double(i), y: Double(ecg)))
                
                if (i % 5 == 0) && (index < self.ppgData.count) {
                    self.ppgDataEntryes.append(ChartDataEntry(x: Double(i),
                                                              y: Double(self.ppgData[index] * 50)))
                    index += 1
                }
            }
            
            let set = LineChartDataSet(entries: self.dataEntryes)
            let ppgSet = LineChartDataSet(entries: self.ppgDataEntryes)
            
            set.axisDependency = .left
            set.drawCirclesEnabled = false
            ppgSet.drawCirclesEnabled = false
            set.setColor(.red)
            ppgSet.setColor(.blue)
            
            let data = LineChartData(dataSets: [set, ppgSet])
            self.chart.data = data
        }
    }
    
    @objc func playTapped () {
        
        isStartedECG.toggle()
        
        if isStartedECG {
            self.timeCounter = 3.0
            self.timerLable.text = "\(Int(timeCounter))"
            self.chart.isHidden = true
            self.timerLable.isHidden = false
            self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(startECG),
                                              userInfo: nil,
                                              repeats: true)
            self.navigationItem.rightBarButtonItem?.title = "Stop"
        } else {
            self.timeCounter = 3.0
            self.timerLable.text = "\(Int(timeCounter))"
            self.timer.invalidate()
            sharedBLE1.ecgBool = false
            command.sendEcgDataCmd(0x00)
            self.navigationItem.rightBarButtonItem?.title = "Start"
            self.timerLable.isHidden = false
            self.chart.isHidden = true
        }
    }
    
    @objc func startECG()
    {
        timeCounter -= 1
        if timeCounter >= 0 {
            timerLable.text = "\(Int(timeCounter))"
        }
        if timeCounter == 0 {
            sharedBLE1.ecgBool = true
            command.sendEcgDataCmd(0x01)
            self.ecgData.removeAll()
            self.navigationItem.rightBarButtonItem?.title = "Stop"
        }
        
        if timeCounter < 0 && timeCounter > -31 {
            timerLable.text = "\(30 + Int(timeCounter)) sec"
        }
    }
}

extension ChartViewController: ZHBleHealthDataSource {
    
    //ZHBleHealthDataSource functions
    func getPpgData(_ arrPpgData: [Any]!) {
        for ppg in arrPpgData {
            print(self.ppgData.count)
            self.ppgData.append(ppg as! Double)
        }
    }
    
    func getFilterEcgData(_ arrFilterEcgData: [Any]!, andHeartRate HR: Int32, systolic: Int32, diastolic: Int32, healthIndex: Int32, fatigueIndex: Int32, load loadIndex: Int32, qualityIndex: Int32, heartIndex: Int32) {
     
        if self.leedOff {
            
            print("\(systolic)/\(diastolic)")
            
            for ecg in arrFilterEcgData {
               // if (abs(ecg as! Float) < 10.0) {
                    self.ecgData.append(ecg as! Double)
             //   }
                
                if self.ecgData.count == 15000 {
                    self.sharedBLE1.ecgBool = false
                    self.command.sendEcgDataCmd(0x00)
                    self.timer.invalidate()
                    self.navigationItem.rightBarButtonItem?.title = "Start"
                    self.isStartedECG = false
                    self.timerLable.isHidden = true
                    self.chart.isHidden = false
                    self.setDataValue(self.ecgData.count)
                    
                }
            }
        }
        else {
            self.sharedBLE1.ecgBool = false
            self.command.sendEcgDataCmd(0x00)
            self.timer.invalidate()
            self.navigationItem.rightBarButtonItem?.title = "Start"
            self.isStartedECG = false
            self.timerLable.isHidden = false
            self.chart.isHidden = true
        }
    }
    
    func setWearWay() -> Bool {
        return false
    }
    
    func setCalibrationHR() -> Int32 {
        return 95
    }
    
    func setCalibrationSystolic() -> Int32 {
        
        return 131
    }
    
    func setCalibrationDiastolic() -> Int32 {
        
        return 84
    }
    
    func connectPeripheralError(_ error: String!) {
        print("ERROR \(error!)")
    }
    
    func getLeedOff(_ leedOff: Bool) {
        self.leedOff = leedOff
    }
}
