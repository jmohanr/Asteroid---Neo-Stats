//
//  ViewController.swift
//  AsteroidNeo Stats
//
//  Created by Jagan on 05/02/23.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    @IBOutlet var inputFields: [UITextField]!
    @IBOutlet var outputDisplyFields: [UILabel]!
    @IBOutlet weak var fetchButton: UIButton!
    @IBOutlet weak var outputStackView: UIStackView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var barChartView: BarChartView!
    
    var startDateField: Bool = false
    var viewModel: ViewModel?
    var stats: [String] = []
    var neoItemData = [NeoItemData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel.init()
        showDatePicker()
        
        inputFields.forEach({
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        })
        
                displayStats()
        
    }
    
    @IBAction func onTapFetchButton(_ sender: UIButton) {
        Task { @MainActor in
            if let startDate = inputFields[0].text,
               let endDate = inputFields[1].text {
               
                if let days = viewModel?.daysDiffer(startDate, endDate), days <= Constants.DAYS_LIMIT {
                    DispatchQueue.main.async { [weak self] in
                        self?.activity.startAnimating()
                        self?.activity.isHidden = false
                    }
                    await viewModel?.fetchData(startDate,endDate)
                } else {
                    self.presentAlert()
                }
               
            }
        }
    }
}



