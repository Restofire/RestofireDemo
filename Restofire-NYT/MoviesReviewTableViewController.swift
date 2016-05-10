//
//  MoviesReviewTableViewController.swift
//  Restofire-NYT
//
//  Created by Rahul Katariya on 02/05/16.
//  Copyright © 2016 Rahul Katariya. All rights reserved.
//

import UIKit
import RealmSwift

class MoviesReviewTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var results: Results<MovieReview>!
    var notificationToken: NotificationToken? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    deinit {
        notificationToken = nil
    }

}

// MARK: - TableView Delegate and Datasoruce
extension MoviesReviewTableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieReviewCell", forIndexPath: indexPath) as! MovieReviewTableViewCell

        // Configure the cell...
        let movieReview = results[indexPath.row]
        cell.displayTitleLabel?.text = movieReview.displayTitle
        cell.summaryLabel?.text = movieReview.summary

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
