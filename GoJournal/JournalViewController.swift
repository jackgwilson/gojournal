//
//  JournalViewController.swift
//  GoJournal
//
//  Created by Jack Wilson on 11/25/18.
//  Copyright © 2018 Jack Wilson. All rights reserved.
//

import UIKit
import AVFoundation

class JournalViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var defaultsData = UserDefaults.standard
    var entryTitlesArray = ["Spring Break", "Service Trip", "Frineds Weekend", "Graduation Trip", "RV Vacation"]
    var entryLocationsArray = ["Florida", "Peru", "New York", "Europe", "Utah"]
    var entriesArray = ["Sunny weather!", "Learned a lot!", "Too much fun!", "Great bonding with friends", "Amazing outdoor experience"]
//    var imageArray = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.sortSegmentedControl.isHidden = false
//        for _ in 0..<entriesArray.count {
//            imageArray.append(UIImage())
//        }
        tableView.dataSource = self
        tableView.delegate = self
        // if entryTitlesArray
        // entryArray = defaultsData.stringArray(forKey: "entryArray") ?? [Entry]()
        entryTitlesArray = defaultsData.stringArray(forKey: "entryTitlesArray") ?? [String]()
        entryLocationsArray = defaultsData.stringArray(forKey: "entryLocationsArray") ?? [String]()
        entriesArray = defaultsData.stringArray(forKey: "entriesArray") ?? [String]()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: false)
        // self.sortSegmentedControl.isHidden = false
//        spots.loadData {
//            self.sortBasedOnSegmentPressed()
//            self.tableView.reloadData()
//        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEntry" {
            let destination = segue.destination as! JournalDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.entryTitle = entryTitlesArray[selectedIndexPath.row]
            destination.entryLocation = entryLocationsArray[selectedIndexPath.row]
            destination.entry = entriesArray[selectedIndexPath.row]
//            destination.entryImage = imageArray[selectedIndexPath.row]
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
    
    func saveDefaultsData() {
        defaultsData.set(entryTitlesArray, forKey: "entryTitlesArray")
        defaultsData.set(entryLocationsArray, forKey: "entryLocationsArray")
        defaultsData.set(entriesArray, forKey: "entriesArray")
    }
    
    @IBAction func unwindFromDetailViewController(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! JournalDetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            entryTitlesArray[indexPath.row] = sourceViewController.entryTitle!
            entryLocationsArray[indexPath.row] = sourceViewController.entryLocation!
            entriesArray[indexPath.row] = sourceViewController.entry!
//            imageArray[indexPath.row] = sourceViewController.entryImage!
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: entryTitlesArray.count, section: 0)
            entryTitlesArray.append(sourceViewController.entryTitle!)
            entryLocationsArray.append(sourceViewController.entryLocation!)
            entriesArray.append(sourceViewController.entry!)
//            imageArray.append(sourceViewController.entryImage!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        saveDefaultsData()
    }
    

    
    
//    func sortBasedOnSegmentPressed() {
//        switch sortSegmentedControl.selectedSegmentIndex {
//        case 0: // A-Z
//            print("TODO")
//            entryTitlesArray.sort{ $0 < $1 }
//        case 1: // Location
//            entryLocationsArray.sort{ $0 < $1 }
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
//            imageArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveDefaultsData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let titleToMove = entryTitlesArray[sourceIndexPath.row]
        let locationToMove = entryLocationsArray[sourceIndexPath.row]
        let entryToMove = entriesArray[sourceIndexPath.row]
//        let imageToMove = imageArray[sourceIndexPath.row]
        entryTitlesArray.remove(at: sourceIndexPath.row)
        entryLocationsArray.remove(at: sourceIndexPath.row)
        entriesArray.remove(at: sourceIndexPath.row)
//        imageArray.remove(at: sourceIndexPath.row)
        entryTitlesArray.insert(titleToMove, at: destinationIndexPath.row)
        entryLocationsArray.insert(locationToMove, at: destinationIndexPath.row)
        entriesArray.insert(entryToMove, at: destinationIndexPath.row)
//        imageArray.insert(imageToMove, at: destinationIndexPath.row)
        saveDefaultsData()
    }
    
    
}
