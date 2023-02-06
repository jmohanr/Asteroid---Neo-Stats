//
//  ViewController_Helper.swift
//  AsteroidNeo Stats
//
//  Created by Jagan on 05/02/23.
//

import UIKit
import Charts

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePicker.isHidden = false
        startDateField = textField == inputFields[0] ? true : false
        textField.inputView = UIView(frame: .zero)
    }
    
    @objc func textFieldDidChange(_ value: UITextField) {
        inputFields.forEach({
            fetchButton.isEnabled =  $0.text == "" ?  false : true
        })
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "The Selected date limit is only 5 Days", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

extension ViewController {
    
    func showDatePicker(){
        
        datePicker?.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
    }
    
    @objc func handleDateSelection(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if startDateField {
            inputFields[0].text = formatter.string(from: datePicker.date)
        } else {
            inputFields[1].text = formatter.string(from: datePicker.date)
        }
        datePicker.isHidden = true
        inputFields.forEach({
            fetchButton.isEnabled =  $0.text == "" ?  false : true
        })
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController {
    
    func displayStats() {
        viewModel?.statsData = { [weak self] (fast,close,objects)  in
            
            DispatchQueue.main.async {
                self?.activity.stopAnimating()
                self?.activity.isHidden = true
                if let id = fast.id,
                   let name = fast.name,
                   let speed = fast.close_approach_data?[0].relative_velocity?.kilometers_per_hour {
                    
                    self?.outputStackView.isHidden = false
                    self?.outputDisplyFields[0].text = "Fastest Asteroid: - \(name)  Id: \(id) Speed: \(speed) km/h"
                }
                if let id = close.id,
                   let name = close.name,
                   let speed = fast.close_approach_data?[0].miss_distance?.kilometers {
                    
                    self?.outputStackView.isHidden = false
                    self?.outputDisplyFields[1].text = "Closest Asteroid: - \(name)  Id: \(id) Distance: \(speed) KM"
                }
                if  objects.count > 0 {
                    self?.setUpRawData(objects: objects)
                }
            }
            
        }
    }
}


extension ViewController {
    
    func setupChart() {
        barChartView.backgroundColor = .link
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.granularityEnabled = false
        xAxis.labelRotationAngle = -25
        xAxis.setLabelCount(stats.count, force: false)
        xAxis.valueFormatter = IndexAxisValueFormatter(values: neoItemData.map { $0.date })
        xAxis.axisMaximum = Double(stats.count)
        xAxis.axisLineColor = .chartLineColour
        xAxis.labelTextColor = .chartLineColour
        
    }
    
    func setupData() {
        let dataEntries = neoItemData.map{ $0.transformToBarChartDataEntry() }
        let set1 = BarChartDataSet(entries: dataEntries)
        set1.setColor(.orange)
        set1.highlightColor = .green
        set1.highlightAlpha = 1
        
        let data = BarChartData(dataSet: set1)
        data.setDrawValues(true)
        data.setValueTextColor(.gray)
        let barValueFormatter = BarValueFormatter()
        data.setValueFormatter(barValueFormatter)
        barChartView.data = data
        setupChart()
    }
    
    func setUpRawData(objects: [NeoObjectData]) {
        
        let dates = objects.map({$0.close_approach_data?[0].close_approach_date})
        
        let unique = Array(Set(dates))
        stats.removeAll()
        for obj in unique {
            let item = objects.filter({$0.close_approach_data?[0].close_approach_date == obj})
            if let name = obj {
                stats.append("\(name),\(item.count)")

            }
        }
        
        if stats.count > 0 {
            neoItemData = getFormattedItemValue(stats.sorted())
            setupData()
            
        }
        
    }
}

