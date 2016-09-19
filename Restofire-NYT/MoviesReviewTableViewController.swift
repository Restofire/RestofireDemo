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
        
        results = realm.objects(MovieReview.self)
        
        notificationToken = results.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let _self = self else { return }
            switch changes {
            case .initial, .update(_, deletions: _, insertions: _, modifications: _):
                _self.results = _self.realm.objects(MovieReview.self)
                _self.tableView.reloadData()
            default:
                break
            }
        }
    }
    
    deinit {
        notificationToken = nil
    }

}

// MARK: - TableView Delegate and Datasoruce
extension MoviesReviewTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieReviewCell", for: indexPath) as! MovieReviewTableViewCell

        // Configure the cell...
        let movieReview = results[indexPath.row]
        cell.displayTitleLabel?.text = movieReview.displayTitle
        cell.summaryLabel?.text = movieReview.summary

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
