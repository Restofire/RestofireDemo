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
        
        MoviesReviewGETService(path: "all.json", parameters: ["api-key":"sample-key"])
            .executeTask()
        
        notificationToken = results.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let _self = self else { return }
            switch changes {
            case .Initial, .Update(_, deletions: _, insertions: _, modifications: _):
                _self.results = _self.realm.objects(MovieReview)
                _self.tableView.reloadData()
            default:
                break
            }
        }
        
    }

    // MARK: - Table view data source

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
 
    deinit {
        notificationToken = nil
    }

}
