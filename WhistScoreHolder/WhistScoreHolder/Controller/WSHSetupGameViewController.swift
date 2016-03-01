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
    
    var state: WSHSetupState = .ViewPlayers {
        willSet(newSetupState) {
            switch newSetupState {
            case .AddPlayer:
                addBarButtonItem.enabled = true
                playBarButtonItem.enabled = true
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
    }
    
    // MARK: - Private functions
    
    func reloadTableView() {
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    // MARK: - UITableView DataSource & Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameSettings?.players.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath)
        
        let player = gameSettings?.players[indexPath.row]
        cell.textLabel?.text = player!.name
        cell.imageView?.image = player!.image
        
        return cell
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
        let alertController: UIAlertController?
        
        if gameSettings?.players.count > 2 {
            alertController = UIAlertController(title: "Get ready", message:
                "Game will start", preferredStyle: UIAlertControllerStyle.Alert)
            alertController!.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                // TODO: (foc) Start the game already
                // TODO: (foc) Dismiss alert after time has passed
            }))
            
        } else {
            alertController = UIAlertController(title: "Not enough players", message:
                "Bring more friends", preferredStyle: UIAlertControllerStyle.Alert)
            alertController!.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                self.state = .AddPlayer
            }))
        }
        alertController!.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil))
        
        self.presentViewController(alertController!, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        switch state {
        case .AddPlayer:
            state = .ViewPlayers
            break
        case .EditPlayer:
            // TODO: (foc) update currently editing player
            break
        default:
            break
        }
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        switch state {
        case .ViewPlayers:
            state = .AddPlayer
            break
        case .AddPlayer:
            if gameSettings?.players.count < 6 {
                gameSettings?.players.append(WSHPlayer(name: playerView.name, image: playerView.image))
                playerView.resetToDefault()
                
            } else {
                // TODO: (foc) show alert
            }
            break
        default:
            break
        }
    }
}
