//
//  ContactsViewController.swift
//  Chatter
//
//  Created by Lewis Jones on 26/05/2016.
//  Copyright © 2016 Rodrigo Pena. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import ContactsUI


class ContactsViewController: UIViewController, ContextViewController, TableViewFetchedResultsDisplayer,ContactSelector {
    
    var context:NSManagedObjectContext?
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let cellIdentifier = "ContactCell"
    private var fetchedResultsController: NSFetchedResultsController?
    private var fetchedResultsDelegate: NSFetchedResultsControllerDelegate?
    private var searchController:UISearchController?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.topItem?.title = "All Contacts"
        
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)

        
        navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .Plain, target: self, action: "newContact")
        
        automaticallyAdjustsScrollViewInsets = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.dataSource = self
        tableView.delegate = self

        
        fillViewWith(tableView)
        
        if let context = context{
            let request = NSFetchRequest(entityName: "Contact")
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true),NSSortDescriptor(key: "firstName", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sortLetter", cacheName: nil)
            fetchedResultsDelegate = TableViewFetchedResultsDelegate(tableView: tableView, displayer: self)
            fetchedResultsController?.delegate = fetchedResultsDelegate
            do{
                try fetchedResultsController?.performFetch()
            }catch{
                print("There was a problem fetching.")
            }
        }
        let resultsVC = ContactsSearchResultsController()
        resultsVC.contactSelector = self
        resultsVC.contacts = fetchedResultsController?.fetchedObjects as! [Contact]
        
        searchController = UISearchController(searchResultsController: resultsVC)
        searchController?.searchResultsUpdater = resultsVC
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController?.searchBar

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newContact(){
        let vc = CNContactViewController(forNewContact: nil)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)

    }
    func configureCell(cell:UITableViewCell, atIndexPath indexPath:NSIndexPath){
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        cell.textLabel?.text = contact.fullName
    }
    
    func selectedContact(contact:Contact){
        guard let id = contact.contactId else {return}
        let store = CNContactStore()
        let cncontact: CNContact
        do{
            cncontact = try store.unifiedContactWithIdentifier(id, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        }catch{
            return
        }
        
        let vc = CNContactViewController(forContact:cncontact)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        searchController?.active = false
    }

}
    
extension ContactsViewController: UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        guard let sections = fetchedResultsController?.sections else {return 0}
        
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController?.sections else {return nil}
        let currentSection = sections[section]
        return currentSection.name
    }

}
extension ContactsViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let contact = fetchedResultsController?.objectAtIndexPath(indexPath) as? Contact else {return}
        selectedContact(contact)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ContactsViewController:CNContactViewControllerDelegate{
    func contactViewController(viewController: CNContactViewController, didCompleteWithContact cnContact: CNContact?) {
        if cnContact == nil {
            navigationController?.popViewControllerAnimated(true)
            return
        }
    }
}
