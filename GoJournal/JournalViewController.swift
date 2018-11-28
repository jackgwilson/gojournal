//
//  JournalViewController.swift
//  GoJournal
//
//  Created by Jack Wilson on 11/25/18.
//  Copyright © 2018 Jack Wilson. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var defaultsData = UserDefaults.standard
    var entryTitlesArray = ["Spring Break", "Service Trip", "Frineds Weekend", "Graduation Trip", "RV Vacation"]
    var entryLocationsArray = ["Florida", "Peru", "New York", "Europe", "Utah"]
    var entriesArray = ["Sunny weather!", "Learned a lot!", "Too much fun!", "Great bonding with friends", "Amazing outdoor experience"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sortSegmentedControl.isHidden = false
        tableView.dataSource = self
        tableView.delegate = self
        // if entryTitlesArray 
        entryTitlesArray = defaultsData.stringArray(forKey: "entryTitlesArray") ?? [String]()
        entryLocationsArray = defaultsData.stringArray(forKey: "entryLocationsArray") ?? [String]()
        entriesArray = defaultsData.stringArray(forKey: "entriesArray") ?? [String]()
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//         navigationController?.setToolbarHidden(false, animated: false)
//        spots.loadData {
//            self.sortBasedOnSegmentPressed()
//            self.tableView.reloadData()
//        }
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEntry" {
            let destination = segue.destination as! JournalDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            destination.entryTitle = entryTitlesArray[index]
            destination.entryLocation = entryLocationsArray[index]
            destination.entry = entriesArray[index]
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
    
    @IBAction func unwindFromDetailViewController(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! JournalDetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            entryTitlesArray[indexPath.row] = sourceViewController.entryTitle!
            entryLocationsArray[indexPath.row] = sourceViewController.entryLocation!
            entriesArray[indexPath.row] = sourceViewController.entry!
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: entryTitlesArray.count, section: 0)
            entryTitlesArray.append(sourceViewController.entryTitle!)
            entryLocationsArray.append(sourceViewController.entryLocation!)
            entriesArray.append(sourceViewController.entry!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        saveDefaultsData()
    }
    
    func saveDefaultsData() {
        defaultsData.set(entryTitlesArray, forKey: "entryTitlesArray")
        defaultsData.set(entryLocationsArray, forKey: "entryLocationsArray")
        defaultsData.set(entriesArray, forKey: "entriesArray")
    }
    
    
    
//    func sortBasedOnSegmentPressed() {
//        switch sortSegmentedControl.selectedSegmentIndex {
//        case 0: // Recent
//            print("TODO")
//            // entryTitlesArray.sort(by: {$0.name < $1.name})
//        case 1: // Location
//            entryLocationsArray.sort(by: {$0.name < $1.name})
//            print("TODO")
//        default:
//            print("***ERROR: This should not have occurred. The segmented control should just have two segments.")
//        }
//        tableView.reloadData()
//    }
    
    
    
    @IBAction func sortSegmentPressed(_ sender: UISegmentedControl) {
        // sortBasedOnSegmentPressed()
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            addBarButton.isEnabled = true
            editBarButton.title = "Edit"
        } else {
            tableView.setEditing(true, animated: true)
            addBarButton.isEnabled = false
            editBarButton.title = "Done"
        }
    }
    
    
    


}




extension JournalViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryTitlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = entryTitlesArray[indexPath.row]
        cell.detailTextLabel?.text = entryLocationsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            entryTitlesArray.remove(at: indexPath.row)
            entryLocationsArray.remove(at: indexPath.row)
            entriesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveDefaultsData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let titleToMove = entryTitlesArray[sourceIndexPath.row]
        let locationToMove = entryLocationsArray[sourceIndexPath.row]
        let entryToMove = entriesArray[sourceIndexPath.row]
        entryTitlesArray.remove(at: sourceIndexPath.row)
        entryLocationsArray.remove(at: sourceIndexPath.row)
        entriesArray.remove(at: sourceIndexPath.row)
        entryTitlesArray.insert(titleToMove, at: destinationIndexPath.row)
        entryLocationsArray.insert(locationToMove, at: destinationIndexPath.row)
        entriesArray.insert(entryToMove, at: destinationIndexPath.row)
        saveDefaultsData()
    }
    
    
}
