//
//  likedViewController.swift
//  unier
//
//  Created by Nathanael Sheehan on 03/02/2018.
//  Copyright © 2018 Nathanael Sheehan. All rights reserved.
//

import Foundation
import UIKit

class LikedTableView: UIViewController, UITableViewDataSource {
    var courses: [Course] = []

    @IBOutlet weak var tableView: UITableView!
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.courses.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCell(withIdentifier: "myLiked", for: indexPath)
       // self.navigationItem.rightBarButtonItem = self.editButtonItem
        cell.textLabel?.text = courses [indexPath.row].courseName
        cell.detailTextLabel?.text = courses [indexPath.row].universityName
       
        return cell
    }
     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.courses[sourceIndexPath.row]
        courses.remove(at: sourceIndexPath.row)
        courses.insert(movedObject, at: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(courses)")
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isEditing = true
        let logo = UIImage(named: "UNIER.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
}
