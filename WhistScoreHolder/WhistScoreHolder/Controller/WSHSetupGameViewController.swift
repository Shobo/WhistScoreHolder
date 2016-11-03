//
//  WSHSetupGameViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 29/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

class WSHSetupGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WSHPlayerViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var playBarButtonItem: UIBarButtonItem!
    
    var players: [WSHPlayer] = []
    var currentPlayer: WSHPlayer?
    
    var rowHeight : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playBarButtonItem.isEnabled = false
        tableView.isEditing = true
        tableView.tableFooterView = UIView()
        currentPlayer = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rowHeight = min(tableView.frame.height / 6.0, kMinRowHeight)
        tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        rowHeight = min(size.height / 6.0, kMinRowHeight)
        tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
        tableView.separatorStyle = .none
    }
    
    
    // MARK: - Private functions
    
    
    fileprivate func refreshButtons() {
        if players.count < kMIN_NUMBER_OF_PLAYERS {
            playBarButtonItem.isEnabled = false
        } else {
            playBarButtonItem.isEnabled = true
        }
        if players.count >= kMAX_NUMBER_OF_PLAYERS {
            addBarButtonItem.isEnabled = false
        } else {
            addBarButtonItem.isEnabled = true
        }
    }
    
    fileprivate func reloadTableView() {
        refreshButtons()
        
        tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
    }
    
    fileprivate func setupPlayerViewController(from navigationController: UINavigationController) {
        let playerViewController: WSHPlayerViewController = navigationController.viewControllers.first as! WSHPlayerViewController
        
        playerViewController.delegate = self
        playerViewController.editPlayer = currentPlayer
    }
    
    
    // MARK: - UITableView DataSource & Delegate
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell")! as UITableViewCell
            
        let player = players[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = player.name
        cell.imageView?.image = player.presentableImage().scale(toSize: CGSize(width: rowHeight - kMargin, height: rowHeight - kMargin))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            players.remove(at: (indexPath as NSIndexPath).row)
            refreshButtons()
            tableView.deleteRows(at: [indexPath], with: .left)
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath == destinationIndexPath {
            return
        }
        let itemToMove = self.players[(sourceIndexPath as NSIndexPath).row]
        players.remove(at: (sourceIndexPath as NSIndexPath).row)
        players.insert(itemToMove , at: (destinationIndexPath as NSIndexPath).row)
    }
    
    
    // MARK: - WSHPlayerViewControllerDelegate functions
    
    
    func didAddPlayer(_ sender: WSHPlayerViewController, player: WSHPlayer) -> Int {
        players.append(player)
        reloadTableView()
        
        return players.count ?? 0
    }
    
    func didEditPlayer(_ sender: WSHPlayerViewController, player: WSHPlayer) {
        currentPlayer?.name = player.name
        currentPlayer?.image = player.image
        currentPlayer?.colour = player.colour
        
        reloadTableView()
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func playButtonTapped(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Get ready", message:
            "Game will start", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            // TODO: (foc) Dismiss alert after time has passed
            self.performSegue(withIdentifier: "presentGame", sender: sender)
            WSHGameManager.sharedInstance.startGameWithPlayers(self.players)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        
        switch identifier {
        case "addPlayer":
            currentPlayer = nil
            setupPlayerViewController(from: (segue.destination as! UINavigationController))
            break
            
        case "cellTapped":
            currentPlayer = players[((tableView.indexPath(for: sender as! UITableViewCell) as NSIndexPath?)?.row)!]
            setupPlayerViewController(from: (segue.destination as! UINavigationController))
            break
            
        case "presentGame":
            let gameVC = segue.destination as! WSHGameViewController
            WSHGameManager.sharedInstance.delegate = gameVC
            break
            
        default:
            break
        }
    }
}
