//
//  WSHSetupGameViewController.swift
//  WhistScoreHolder
//
//  Created by OctavF on 29/02/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit

enum WSHSetupState {
    case AddPlayer
    case EditPlayer
    case ViewPlayers
}

class WSHSetupGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var playerView: WSHPlayerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var playBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    var gameSettings: WSHGameSettings?
    var currentPlayer: WSHPlayer?
    
    var rowHeight : CGFloat = 0.0
    
    var state: WSHSetupState = .ViewPlayers {
        willSet(newSetupState) {
            switch newSetupState {
            case .AddPlayer:
                addBarButtonItem.enabled = true
                playBarButtonItem.enabled = false
                doneBarButtonItem.enabled = true
                playerView.hidden = false
                break
                
            case .EditPlayer:
                addBarButtonItem.enabled = false
                playBarButtonItem.enabled = false
                doneBarButtonItem.enabled = true
                playerView.hidden = false
                break
                
            case .ViewPlayers:
                addBarButtonItem.enabled = true
                playBarButtonItem.enabled = true
                doneBarButtonItem.enabled = false
                playerView.hidden = true
                playerView.resignKeyboardIfNeeded()
                reloadTableView()
                
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameSettings = WSHGameSettings(players: [])
        tableView.editing = true
        state = .ViewPlayers
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        rowHeight = max(tableView.frame.height / 6.0, 80.0)
    }
    
    
    // MARK: - Private functions
    
    
    private func reloadTableView() {
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    private func presentAddNameAlertView() {
        let alertController = UIAlertController(title: "Add a name", message:
            "Each player should have a name", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            self.playerView.focusName()
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func presentTooManyPlayersAlertView() {
        let alertController = UIAlertController(title: "Too many players", message:
            "Maximum number of players: 6", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - UITableView DataSource & Delegate
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameSettings?.players.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath)
        
        let player = gameSettings?.players[indexPath.row]
        cell.textLabel?.text = player!.name
        cell.imageView?.image = player!.image?.scale(toSize: CGSizeMake(rowHeight - 8.0, rowHeight - 8.0))
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // edit player
        currentPlayer = gameSettings?.players[indexPath.row]
        
        playerView.name = (currentPlayer?.name)!
        playerView.image = (currentPlayer?.image)!
        
        state = .EditPlayer
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            gameSettings?.players.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            break
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = gameSettings!.players[sourceIndexPath.row]
        gameSettings?.players.removeAtIndex(sourceIndexPath.row)
        gameSettings?.players.insert(itemToMove , atIndex: destinationIndexPath.row)
    }
    
    
    // MARK: - Actions
    
    
    @IBAction func playButtonTapped(sender: AnyObject) {
        let alertController: UIAlertController
        
        if gameSettings?.players.count > 2 {
            alertController = UIAlertController(title: "Get ready", message:
                "Game will start", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                // TODO: (foc) Start the game already
                // TODO: (foc) Dismiss alert after time has passed
            }))
            
        } else {
            alertController = UIAlertController(title: "Not enough players", message:
                "Bring more friends", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                self.state = .AddPlayer
            }))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        if state == .EditPlayer {
            if playerView.name.isEmpty {
                presentAddNameAlertView()
                
            } else {
                currentPlayer?.name = playerView.name
                currentPlayer?.image = playerView.image
                
                state = .ViewPlayers
                
                playerView.resetToDefault()
            }
        } else {
            state = .ViewPlayers
        }
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        switch state {
        case .ViewPlayers:
            if gameSettings?.players.count == 6 {
                presentTooManyPlayersAlertView()
            } else {
                state = .AddPlayer
            }
            break
        case .AddPlayer:
            if gameSettings?.players.count < 6 {
                if playerView.name.isEmpty {
                    presentAddNameAlertView()
                } else {
                    gameSettings?.players.append(WSHPlayer(name: playerView.name, image: playerView.image))
                    playerView.resetToDefault()
                }
            } else {
                playerView.resignKeyboardIfNeeded()
                presentTooManyPlayersAlertView()
                self.state = .ViewPlayers
            }
            break
        default:
            break
        }
    }
}
