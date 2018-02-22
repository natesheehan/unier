//
//  resultsViewController.swift
//  unier
//
//  Created by Nathanael Sheehan on 03/02/2018.
//  Copyright © 2018 Nathanael Sheehan. All rights reserved.
//

import Foundation
import UIKit

class ResultsPage: UIViewController {
    var courses: [Course] = []
    var savedCourses: [Course] = []
    var index: Int = 0{
        didSet {
            self.cardView.course = courses[index]
        }
    }
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var cardView: UIViewX!
    
    @IBOutlet weak var amountOfInstitutions: UILabel!
    @IBOutlet weak var amountOfResultsLabel: UILabel!
    
    @IBOutlet weak var noMatchesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "UNIER.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        let PanGesture = UIPanGestureRecognizer.init(target: self, action: #selector (self.panCard(_:)))
        self.cardView.addGestureRecognizer(PanGesture)

        self.cardView.course = courses.first
        let savedInstitutions = searchEngine.shared.institutions

        let instiutionsResults =
            courses.flatMap { (course) -> Institution? in
                
                for institution in savedInstitutions {
                    guard let universityName = course.universityName, let instiutionName = institution.title
                        else {
                            return nil
                    }
                    if instiutionName == universityName{
                        return institution
                    }
                }
                return nil
        }
        self.amountOfResultsLabel.text = "We have found \(courses.count) courses for you!"
        self.amountOfInstitutions.text = "From \(Set(instiutionsResults).count) universities!"
        
        if (index >= courses.count){
            self.noMatchesLabel.text = "No more matches"
            PanGesture.isEnabled = false
        }
    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let xFromCenter = card.center.x - view.center.x
        
        /*
         Degrees   Radians
         15          .26
         25          .43
         35          .61
         */
        let rotationAngle = xFromCenter/view.frame.width * 0.61
        let rotation = CGAffineTransform(rotationAngle: rotationAngle)
        
        // Maybe make this optional
        let scale = min(100/abs(xFromCenter) , 1)
        let stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        card.transform = stretchAndRotation
        card.center = sender.location(in: view)
        
        // Set Thumb Image
        if xFromCenter > 0 {
            thumbImageView.image = #imageLiteral(resourceName: "ThumpUp")
            thumbImageView.tintColor = UIColor.green
        } else {
            thumbImageView.image = #imageLiteral(resourceName: "ThumpDown")
            thumbImageView.tintColor = UIColor.red
        }
        
        // Show Thumb Image
        let alphaValue = abs(xFromCenter/view.center.x)
        thumbImageView.alpha = alphaValue
        
        if sender.state == UIGestureRecognizerState.ended {
            
            if card.center.x < 100 {
                // Thumbs Down
                // Move off to the left
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 100)
                    card.alpha = 0
                })
            } else if card.center.x > view.frame.width - 100 {
                // Thumbs Up
                savedCourses.append(self.cardView.course!)
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 100)
                    card.alpha = 0
                })
            }
            resetCard()
        }
    }
    func next() {
        index += 1
    }
    
    @IBAction func reset(_ sender: Any) {
        index = 0
    }
    @IBAction func reshuffle(_ sender: Any) {
        index = Int(arc4random_uniform(UInt32(6) + 1))
    }
    
    func resetCard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.cardView.alpha = 1
            self.cardView.transform = .identity
            self.cardView.center = self.view.center
            self.thumbImageView.alpha = 0
        })
        self.next()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myLiked" {
            if let destination  = segue.destination as? LikedTableView {
                destination.courses = self.savedCourses
            }
        }
    }
}
