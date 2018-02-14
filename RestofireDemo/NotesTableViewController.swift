//
//  NotesTableViewController.swift
//  RestofireDemo
//
//  Created by Rahul Katariya on 13/02/18.
//  Copyright © 2018 Rahul Katariya. All rights reserved.
//

import UIKit
import CoreData
import BNRCoreDataStack

class NotesTableViewController: UITableViewController {
    
    var persistentContainer: NSPersistentContainer!
    private lazy var fetchedResultsController: FetchedResultsController<Note> = {
        let fetchRequest = NSFetchRequest<Note>()
        fetchRequest.entity = Note.entity()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let frc = FetchedResultsController<Note>(fetchRequest: fetchRequest,
                                                 managedObjectContext: self.persistentContainer.viewContext,
                                                 sectionNameKeyPath: "title")
        frc.setDelegate(self.frcDelegate)
        return frc
    }()
    
    private lazy var frcDelegate: NotesFetchedResultsControllerDelegate = {
        return NotesFetchedResultsControllerDelegate(tableView: self.tableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch objects: \(error)")
        }
        
    }
    
    @IBAction func didTapAddButton(_ sender: UIBarButtonItem) {
        // Create an alert
        let alert = UIAlertController(
            title: "New Note",
            message: "Insert the title of the new note item:",
            preferredStyle: .alert)
        
        // Add a text field to the alert for the new item's title
        alert.addTextField(configurationHandler: nil)
        
        // Add a "cancel" button to the alert. This one doesn't need a handler
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add a "OK" button to the alert. The handler calls addNewToDoItem()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let title = alert.textFields?[0].text {
                let noteRequestModel = NoteRequestModel(title: title)
                NotePOSTService(parameters: noteRequestModel, context: self.persistentContainer.viewContext).execute()
            }
        }))
        
        // Present the alert to the user
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].objects.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        guard let sections = fetchedResultsController.sections else {
            fatalError("FetchedResultsController \(fetchedResultsController) should have sections, but found nil")
        }
        
        let section = sections[indexPath.section]
        let note = section.objects[indexPath.row]
        cell.textLabel?.text = note.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].indexTitle
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController.sections?.map() { $0.indexTitle ?? "" }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let sections = fetchedResultsController.sections else {
                fatalError("FetchedResultsController \(fetchedResultsController) should have sections, but found nil")
            }
            
            let section = sections[indexPath.section]
            let note = section.objects[indexPath.row]
            NoteDeleteService(
                id: note.id,
                context: persistentContainer.viewContext
            ).execute()
        }
    }

}

class NotesFetchedResultsControllerDelegate: NSObject, FetchedResultsControllerDelegate {
    
    private weak var tableView: UITableView?
    
    // MARK: - Lifecycle
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func fetchedResultsControllerDidPerformFetch(_ controller: FetchedResultsController<Note>) {
        tableView?.reloadData()
    }
    
    func fetchedResultsControllerWillChangeContent(_ controller: FetchedResultsController<Note>) {
        tableView?.beginUpdates()
    }
    
    func fetchedResultsControllerDidChangeContent(_ controller: FetchedResultsController<Note>) {
        tableView?.endUpdates()
    }
    
    func fetchedResultsController(_ controller: FetchedResultsController<Note>, didChangeObject change: FetchedResultsObjectChange<Note>) {
        guard let tableView = tableView else { return }
        switch change {
        case let .insert(_, indexPath):
            tableView.insertRows(at: [indexPath], with: .automatic)
            
        case let .delete(_, indexPath):
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case let .move(_, fromIndexPath, toIndexPath):
            tableView.moveRow(at: fromIndexPath, to: toIndexPath)
            
        case let .update(_, indexPath):
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func fetchedResultsController(_ controller: FetchedResultsController<Note>, didChangeSection change: FetchedResultsSectionChange<Note>) {
        guard let tableView = tableView else { return }
        switch change {
        case let .insert(_, index):
            tableView.insertSections(IndexSet(integer: index), with: .automatic)
            
        case let .delete(_, index):
            tableView.deleteSections(IndexSet(integer: index), with: .automatic)
        }
    }
    
}
