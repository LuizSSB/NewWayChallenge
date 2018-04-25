//
//  PopularProjectsTableViewController.swift
//  NewWayChallenge
//
//  Created by Luiz SSB on 4/24/18.
//  Copyright © 2018 luizssb. All rights reserved.
//

import UIKit

class PopularProjectsTableViewController:
    UITableViewController, ProjectsControllerDelegate {
    
    private let _controller = ProjectsController(language: "Swift");

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!
            .addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        _controller.delegate = self        
        refresh(nil)
    }
    
    @objc func refresh(_ sender: Any?) {
        _controller.reset()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
        ) -> Int {
        return _controller.count + (_controller.hasMore ? 1 : 0)
    }
    
    override func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        
        if indexPath.row == _controller.count {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "MoreTableViewCell"
            ) as! MoreTableViewCell
            cell.activityIndicator.startAnimating()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ProjectTableViewCell", for: indexPath
            ) as! ProjectTableViewCell
        
        cell.set(repository: _controller[indexPath.row])
        
        return cell
    }
    
    // MARK: - Project Controller Delegate
    
    func projectControllerGotEntries(_ controller: ProjectsController) {
        finish()
    }
    
    func projectControllerDidFailToGetEntries(
        _ controller: ProjectsController, error: ResponseError
        ) {
        finish()        
        showError(message: "placeholder", from: self)
    }
    
    private func finish() {
        refreshControl?.endRefreshing()
        tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
    }
}
