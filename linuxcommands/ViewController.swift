//
//  ViewController.swift
//  linuxcommands
//
//  Created by Prajwal on 10/11/15.
//  Copyright © 2015 Above Solutions India Pvt Ltd. All rights reserved.
//

import UIKit

class ViewController: UITableViewController
{
    var linuxCommandDict:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let path = NSBundle.mainBundle().pathForResource("linuxcommands", ofType: "plist") {
            if let plistData: NSDictionary? = NSDictionary(contentsOfFile: path) {
                self.linuxCommandDict = plistData
            }
        }
        
        
        // Self-sizing table view cells in iOS 8 require that the rowHeight property of the table view be set to the constant UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Self-sizing table view cells in iOS 8 are enabled when the estimatedRowHeight property of the table view is set to a non-zero value.
        // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
        // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
        tableView.estimatedRowHeight = 44.0 // set this to whatever your "average" cell height is; it doesn't need to be very accurate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* type to represent table items
    `section` stores a `UITableView` section */
    class Command: NSObject {
        let name: String
        let desc: String
        var section: Int?
        
        init(name: String, desc: String) {
            self.name = name
            self.desc = desc
        }
    }
    
    // custom type to represent table sections
    class Section {
        var commands: [Command] = []
        
        func addCommand(command: Command) {
            self.commands.append(command)
        }
    }
    
    // `UIKit` convenience class for sectioning a table
    let collation = UILocalizedIndexedCollation.currentCollation()
        as UILocalizedIndexedCollation
    
    // table sections
    var sections: [Section] {
        // return if already initialized
        if self._sections != nil {
            return self._sections!
        }
        
        // create commands from the linuxCommandDict
        let commands: [Command] = linuxCommandDict.allKeys.map { name in
            let command = Command(name: (name as! String), desc: (linuxCommandDict.objectForKey(name) as! String))
            command.section = self.collation.sectionForObject(command, collationStringSelector: "name")
            return command
        }
        
        // create empty sections
        var sections = [Section]()
        for _ in 0..<self.collation.sectionIndexTitles.count {
            sections.append(Section())
        }
        
        // put each command in a section
        for command in commands {
            sections[command.section!].addCommand(command)
        }
        
        // sort each section
        for section in sections {
            section.commands = self.collation.sortedArrayFromArray(section.commands, collationStringSelector: "name") as! [Command]
        }
        
        self._sections = sections
        
        return self._sections!
    }
    
    var _sections: [Section]?
    
    // MARK: table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return self.sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return self.sections[section].commands.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let command = self.sections[indexPath.section].commands[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = command.name
        cell.detailTextLabel!.text = command.desc
        
        return cell
    }
    
    /* section headers
    appear above each `UITableView` section */
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int)
        -> String {
        // do not display empty `Section`s
        if !self.sections[section].commands.isEmpty {
            return self.collation.sectionTitles[section] as String
        }
        return ""
    }
    
    /* section index titles
    displayed to the right of the `UITableView` */
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
         return self.collation.sectionIndexTitles 
    }
    
    override func tableView(tableView: UITableView,
        sectionForSectionIndexTitle title: String,
        atIndex index: Int)
        -> Int {
            return self.collation.sectionForSectionIndexTitleAtIndex(index)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let command = self.sections[indexPath.section].commands[indexPath.row]
        let detailVC:DetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailVC") as! DetailViewController
        detailVC.searchKey = command.name
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}