//
//  searchEngine.swift
//  unier
//
//  Created by Nathanael Sheehan on 03/02/2018.
//  Copyright © 2018 Nathanael Sheehan. All rights reserved.
//

import Foundation
import CSV

typealias UKRN = Int
typealias PUBUKRN = Int
//schema
struct Course {
    let id: String
    let pub: PUBUKRN
    let universityName: String?
    let courseName: String?
}

//extension Course: Hashable {
  //  var hashValue: Int {
    //    get {
            
      //  }
    //}
//}

struct Institution {

    let id: UKRN
    let pub: PUBUKRN
    let title: String?
}
//to check against repeated instution names
extension Institution: Hashable, Equatable {
    var hashValue: Int {
        get {
            return self.pub
        }
    }
    
    public static func ==(lhs: Institution, rhs: Institution) -> Bool {
        if lhs.pub == rhs.pub {
            return true
        }
        return false
    }
}

class searchEngine {
    var institutions : Set <Institution> = []
    var courses: [Course] = []
    static let shared: searchEngine = searchEngine()
    
    
    func load() {
       
        let AccreditationByHep = Bundle.main.path(forResource: "AccreditationByHep", ofType: "csv")
        let stream = InputStream(fileAtPath: AccreditationByHep!)
       
        let csv = try!  CSVReader.init(stream: stream!, hasHeaderRow: true)
        let headerRow = csv.headerRow!
        
        
        while csv.next() != nil  {
            
            //find the HEP file in the csv
            guard let hep = csv["HEP"] else {
                continue
            }
            //seperates the id and the university name
            let elements = hep.components(separatedBy: ")")
            guard let id = Int((elements.first?.replacingOccurrences(of: "(", with: ""))!) else {
                continue
            }
            //sets last split to the univeristy name
            let institutionName = elements.last
            
            let institution = Institution.init(id: -1, pub: id, title: institutionName)
           
            //finds the course title and ID from the row in the csv
            
            let courseTitle = csv["KisCourseTitle"]!
            let kisCourseID = csv["KiscourseID"]!
            
            let course = Course.init(id: kisCourseID, pub: id, universityName: institutionName, courseName: courseTitle)
            self.institutions.insert(institution)
            self.courses.append(course)
            
        }
        print(institutions.count)
        print(courses.count)
    }
    
    func search(for courseName: String )-> [Course]? {
        
        return self.courses.filter({ (course) -> Bool in
            guard let userCourseSearch = course.courseName?.lowercased() else {
                return false
            }
            return userCourseSearch.contains(courseName.lowercased())
        })
    }}
