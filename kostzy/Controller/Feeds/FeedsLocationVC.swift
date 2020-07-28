//
//  FeedsLocationVX.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class FeedsLocationVC: UIViewController {
    
    @IBOutlet weak var locationTableView: UITableView!
    
    @IBOutlet weak var segmentedLocation: UISegmentedControl!
    
    var selectedLocation : Location?
    
    fileprivate let locations : [Location] = Location.initData()
    
    fileprivate var filteredLocation = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButtonAttrs()
        filteredLocation = locations.filter { $0.type == .university }
        setupSegmentedControl()
        setupTableView()
    }
    
    private func setupTableView() {
        locationTableView.dataSource = self
        locationTableView.delegate = self
        self.locationTableView.tableFooterView = UIView()
    }
    
    private func setupCancelButtonAttrs() {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain , target: self, action: #selector(dismissViewController))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func setupSegmentedControl() {
         let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        segmentedLocation.selectedSegmentTintColor = UIColor(red: 255.0/255, green: 184.0/255, blue: 0.0/255, alpha: 1)
        segmentedLocation.setTitleTextAttributes(attrs, for: .selected)
    }
    
    @objc private func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func changeLocationType(_ sender: UISegmentedControl) {
        setSegmentedData()
        locationTableView.reloadData()
    }
    
    @IBAction func currentLocationClicked(_ sender: Any) {
        selectedLocation = Location(name: "Bekasi", type: .area, lat: 11, long: 20)
        shouldPerformSegue(withIdentifier: "unwindFeeds", sender: self)
    }
    
    
    private func setSegmentedData() {
        switch segmentedLocation.selectedSegmentIndex {
        case 0:
            filteredLocation = locations.filter {
                $0.type == .university
            }
        default:
            filteredLocation = locations.filter {
                $0.type == .area
            }
        }
    }
    
    
    @IBAction func searchLocation(_ sender: UITextField) {
        setSegmentedData()
        if let text = sender.text {
            if sender.text == "" {
                setSegmentedData()
            } else {
                let temp = filteredLocation.filter {
                $0.name.lowercased().contains(text.lowercased())
                }
                filteredLocation = temp
            }
        }
        locationTableView.reloadData()
    }

    
}

extension FeedsLocationVC : UITableViewDataSource, UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFeeds" {
            if let dest = segue.destination as? FeedsVC {
                dest.location = selectedLocation
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLocation = filteredLocation[indexPath.row]
        performSegue(withIdentifier: "unwindFeeds", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        cell.textLabel?.text = filteredLocation[indexPath.row].name
        return cell
    }
}
