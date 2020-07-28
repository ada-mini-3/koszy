//
//  FeedsVC.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import CoreLocation
import UIKit
import MapKit

class FeedsVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var btnLocation: UIButton!
    
    @IBOutlet weak var segmentedCategory: UISegmentedControl!
    
    @IBOutlet weak var feedsCollectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var actityIndicator: UIActivityIndicatorView!
    
    var location : Location?
    
    var feedsInfo = Feeds.initData()
    var feedsFood = Feeds.initFeedCatData()
    var feedsExp = Feeds.initFeedExpData()
    var feedsHangouts = Feeds.initFeedHangoutsData()
    
    lazy var feedsToDisplay = feedsInfo
    var locationManager : CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItem()
        setupSegmentedControl()
        setupButtonToLocation()
        setupRefreshControl()
        setupIndicator()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    func openMapForPlace () {
        //Defining destination
        let latitude: CLLocationDegrees = -6.200696
        let longitude: CLLocationDegrees = 106.784262

        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)

        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Syahdan"
        mapItem.openInMaps(launchOptions: options)
    }
    
    private func setupIndicator() {
        actityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.actityIndicator.stopAnimating()
            self.actityIndicator.isHidden = true
            self.feedsCollectionView.dataSource = self
            self.feedsCollectionView.delegate = self
            self.feedsCollectionView.reloadData()
        }
    }
    
    private func setupRefreshControl() {
        if #available(iOS 10.0, *) {
            feedsCollectionView.refreshControl = refreshControl
        } else {
            feedsCollectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching New Post ...", attributes: nil)

    }
    
    @objc func refresh(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func setupNavigationBarItem() {
        let icon = UIImage(systemName: "plus.circle.fill")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        let barButton = UIBarButtonItem(customView: iconButton)
        iconButton.addTarget(self, action: #selector(segueToCreateFeeds), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func segueToCreateFeeds() {
        performSegue(withIdentifier: "createFeedSegue", sender: self)
    }
    
    private func setupSegmentedControl() {
        segmentedCategory.selectedSegmentTintColor = UIColor(red: 255.0/255, green: 184.0/255, blue: 0.0/255, alpha: 1)
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
        segmentedCategory.setTitleTextAttributes(attrs, for: .selected)
        segmentedCategory.backgroundColor = UIColor.white
        fixBackgroundSegmentControl(segmentedCategory)
    }
    
    func fixBackgroundSegmentControl( _ segmentControl: UISegmentedControl){
        if #available(iOS 13.0, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(segmentControl.numberOfSegments-1)  {
                    let backgroundSegmentView = segmentControl.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
    
    private func setupButtonToLocation() {
        btnLocation.contentHorizontalAlignment = .left
        if location != nil {
             btnLocation.setTitle(location?.name, for: .normal)
        }
    }
    
    @IBAction func unwindToFeeds(_ sender: UIStoryboardSegue) {
        setupButtonToLocation()
        segmentedCategory.selectedSegmentIndex = 0
        changeSegmentedImage()
        feedsToDisplay = feedsInfo
        feedsCollectionView.reloadData()
    }
    
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        changeSegmentedImage()
        filterFeedBasedOnCategory()
        feedsCollectionView.reloadData()
    }
    
    private func filterFeedBasedOnCategory() {
        switch segmentedCategory.selectedSegmentIndex {
            case 0:
                feedsToDisplay = feedsInfo
            case 1:
                feedsToDisplay = feedsFood
            case 2:
                feedsToDisplay = feedsExp
            default:
                feedsToDisplay = feedsHangouts
        }
    }
    
    private func changeSegmentedImage() {
        switch segmentedCategory.selectedSegmentIndex {
            case 0:
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "info-selected"), forSegmentAt: 0)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-culinary"), forSegmentAt: 1)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-experience"), forSegmentAt: 2)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-hangouts"), forSegmentAt: 3)
            case 1:
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-information"), forSegmentAt: 0)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "food-selected"), forSegmentAt: 1)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-experience"), forSegmentAt: 2)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-hangouts"), forSegmentAt: 3)
            case 2:
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-information"), forSegmentAt: 0)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-culinary"), forSegmentAt: 1)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "exp-selected"), forSegmentAt: 2)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-hangouts"), forSegmentAt: 3)
            default:
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-information"), forSegmentAt: 0)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-culinary"), forSegmentAt: 1)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "sc-experience"), forSegmentAt: 2)
                segmentedCategory.setImage(UIImage(imageLiteralResourceName: "hangout-selected"), forSegmentAt: 3)
        }
    }
    
}

extension FeedsVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeacon.self) {
                if CLLocationManager.isRangingAvailable() {
                    
                }
            }
        }
    }
    
}

extension FeedsVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailFeedSegue" {
         if let dest = segue.destination as? FeedsDetailVC {
             dest.feeds = sender as? Feeds
         }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         performSegue(withIdentifier: "detailFeedSegue", sender: feedsToDisplay[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        feedsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedCell
        var feed = feedsToDisplay[indexPath.row]
        cell.userName.text = feed.user.name
        cell.userImage.image = feed.user.image
        if feed.location == nil {
            cell.feedLocation.isHidden = true
        } else {
            cell.feedLocation.setTitle(feed.location, for: .normal)
        }
        cell.feed.text = feed.feed
        cell.tags = feed.tags
        cell.likeCount.text = "\(feed.likeCount) Likes"
        cell.commentCount.text = "\(feed.commentCount) Comments"
        cell.commentTapAction = {() in
            self.performSegue(withIdentifier: "detailFeedSegue", sender: self.feedsInfo[indexPath.row])
        }
        cell.locationTapAction = {() in
            print("Location Clicked!!")
            self.openMapForPlace()
            
        }
        cell.likeTapAction = {() in
            feed.likeStatus = true
            cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            cell.likeButton.tintColor = UIColor.red
        }
        
        if feed.likeStatus == true {
            cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            cell.likeButton.tintColor = UIColor.red
        } else {
            cell.likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            cell.likeButton.tintColor = UIColor.darkGray
        }
        
        cell.configure()
        return cell
    }
    
 
}
