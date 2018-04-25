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
    
    @IBOutlet weak var acquiringMoreIndicator: UIActivityIndicatorView!
    
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

    // MARK: - Table view source
    
    override func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
        ) -> Int {
        return _controller.count// + (_controller.hasMore ? 1 : 0)
    }
    
    override func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ProjectTableViewCell", for: indexPath
            ) as! ProjectTableViewCell
        
        cell.set(repository: _controller[indexPath.row])
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
        ) -> CGFloat {
        return ProjectTableViewCell.rowHeight(forTraits: view.traitCollection)
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
        ) {
        tableView.reloadData()
    }
    
    // MARK: - Project Controller Delegate
    
    func projecControllerWillGetEntries(_ controller: ProjectsController) {
        acquiringMoreIndicator.startAnimating()
    }
    
    func projectController(
        _ controller: ProjectsController, didGetEntries entries: [Repository]
        ) {
        finish()
        
        let newIndexPaths =
            ((controller.count - entries.count)..<controller.count).map {
                IndexPath(row: $0, section: 0)
            }
        tableView.insertRows(at: newIndexPaths, with: .automatic)
    }
    
    func projectController(
        _ controller: ProjectsController, didFail error: ResponseError
        ) {
        finish()
        showError(message: "placeholder", from: self)
    }
    
    private func finish() {
        refreshControl?.endRefreshing()
        acquiringMoreIndicator.stopAnimating()
    }
}
