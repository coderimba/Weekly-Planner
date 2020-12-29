//
//  NotesViewController.swift
//  Weekly Planner
//
//  Created by Ervin Ng on 2020-08-17.
//  Copyright © 2020 Ervin Ng. All rights reserved.
//

import RealmSwift
import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var notesArray = [Note]()
    
    let defaults = UserDefaults.standard //UserDefaults.standard is a Singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        let newNote = Note()
        newNote.title = "CPSC 121"
        notesArray.append(newNote)
        
        let newNote2 = Note()
        newNote2.title = "CPSC 210"
        notesArray.append(newNote2)

        let newNote3 = Note()
        newNote3.title = "MATH 200"
        notesArray.append(newNote3)

        let newNote4 = Note()
        newNote4.title = "STAT 200"
        notesArray.append(newNote4)
        
        if let notes = defaults.array(forKey: "NotesArray") as? [Note] {
            notesArray = notes //set notesArray to equal the array inside our UserDefaults to retrieve our saved data
        }
    }

    @IBAction func addNoteButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Note", message: "Enter a name for this note.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Note", style: .default) { (action) in
            //what happens after the user clicks on the "Add Note" button on our UIAlertController
            if textField.text != "" {
                let newNote = Note()
                newNote.title = textField.text!
                self.notesArray.append(newNote)
                self.defaults.set(self.notesArray, forKey: "NotesArray")//save the updated notesArray to our UserDefaults
                self.tableView.reloadData() //this taps into the tableView and triggers the data source methods again (so the added note will show up in our Table View)
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Name" //this will disappear when the user clicks on the TextField
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NotesViewController: UITableViewDataSource { //Data Source is responsible for populating the tableView (how many cells the tableView needs and which cells to put in the tableView)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
        //returns number of rows in Table View
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //indexPath is the position so this method is asking for a UITableViewCell to be displayed in each row of our tableView
        //this method will get called for as many rows as you have in your Table View
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
            //Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table
        cell.textLabel?.text = notesArray[indexPath.row].title //sets the text of the cell
        return cell
    }
    
}

