//
//  ProfileTableVC.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 22/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit


// MARK: - DataSource
class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - Arrays
    var image = ["My Community Dummy Data 2",
                 "My Community Dummy Data 2 2",
                 "My Community Dummy Data 2",
                 "My Community Dummy Data 2 2",
                 "My Community Dummy Data 2",
                 "My Community Dummy Data 2 2",
                 "My Community Dummy Data 2",
                 "My Community Dummy Data 2 2",
                 "My Community Dummy Data 2",
                 "My Community Dummy Data 2 2"]
    var community = ["Kost Area Anggrek Cakra",
                     "Kost Area Binus Syahdan",
                     "Kost Area Anggrek Cakra",
                     "Kost Area Binus Syahdan",
                     "Kost Area Anggrek Cakra",
                     "Kost Area Binus Syahdan",
                     "Kost Area Anggrek Cakra",
                     "Kost Area Binus Syahdan",
                     "Kost Area Anggrek Cakra",
                     "Kost Area Binus Syahdan"]

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return community.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCommunityCell", for: indexPath) as! MyCommunityCell
        cell.myCommunityImage.image = UIImage(named: image[indexPath.row])
        cell.myCommunityLabel.text = community[indexPath.row]
        
        return cell
    }
}


// MARK: - ProfileTableVC
class ProfileTableVC: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    // MARK: - Variables
    let notificationCenter = NotificationCenter.default
    
    let profileImagePlaceholderImage = "Photo Profile (Dummy Data)"
    let profileNamePlaceholderText = "Desti"
    let profileTitlePlaceholderText = "Experienced Boarder"
    let userLikePlaceholderNumber = 100
    let profileAboutMePlaceholderText = "There's no description."
    
    var dataSource = DataSource()
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var badgeCollectionView: UICollectionView!
    @IBOutlet weak var myCommunityTableView: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileTitleLabel: UILabel!
    @IBOutlet weak var profileAboutMeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        myCommunityTableView.delegate = dataSource
        myCommunityTableView.dataSource = dataSource
        
        myCommunityTableView.rowHeight = 80
        myCommunityTableView.estimatedRowHeight = 848
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadProfileData()
        
        tableView.reloadData()
        badgeCollectionView.reloadData()
        myCommunityTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        profileAboutMeLabel.sizeToFit()
    }
    
    
    // MARK: - Function
    func loadProfileData() {
        if userImage == nil && userFullName == nil && userTitle == nil && userLike == nil && userAboutMe == nil {
            profileImage.image = UIImage(named: profileImagePlaceholderImage)
            profileNameLabel.text = profileNamePlaceholderText
            profileTitleLabel.text = profileTitlePlaceholderText
            userLike = userLikePlaceholderNumber
            profileAboutMeLabel.text = profileAboutMePlaceholderText
        }
        else {
            profileNameLabel.text = userFullName
        }
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 3 {
            let height: CGFloat = myCommunityTableView.estimatedRowHeight
            
            return height
        }

        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    */

    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCollectionCell", for: indexPath) as! BadgeCollectionCell
        let floatXP = Float(userLike ?? 0)
    
        // Configure the cell
        cell.likeProgressView.setProgress(floatXP / 500, animated: true)
        print(floatXP / 500)
        
        if userLike ?? 0 >= 100 {
            cell.like100DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        if userLike ?? 0 >= 200 {
            cell.like200DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        if userLike ?? 0 >= 300 {
            cell.like300DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        if userLike ?? 0 >= 400 {
            cell.like400DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        if userLike ?? 0 >= 500 {
            cell.like500DotView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3098039216, blue: 0.7882352941, alpha: 1)
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 600, height: 128)
    }
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
