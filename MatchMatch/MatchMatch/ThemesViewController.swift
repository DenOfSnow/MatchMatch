//
//  ThemesViewController.swift
//  MatchMatch
//
//  Created by Benjamin Kim on 4/11/18.
//  Copyright © 2018 Benjamin Kim. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    // emojis will be used in the cards to represent the different themes.
    let themes = [
        "Sports": "⚽️🏀🏅⛷🏏🏓⛳️🏆🥋🏂🏑🏒🏉🎾⚾️",
        "Animals": "🐶🦊🦁🐸🐯🐣🐳🐠🦉🐹🐭🐱🙈🐧🐔",
        "Food": "🍎🥐🌶🍆🥑🍒🍑🍅🍇🍉🍌🍋🍏🍊🥕"
    ]
    
    override func awakeFromNib() { // function is required since the user making changes to match users preference.
        splitViewController?.delegate = self as? UISplitViewControllerDelegate
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        //  used splitViewController because we want changes in the theme view controller to affect changes in the concentration view controller.
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true // Screen stays the same since a theme has not been selected!
            }
        }
        return false // collapses since theme has been selected.
    }
    
    private var concentrationLiveViewController: ConcentrationViewController? {
        // It'll return if it's able to find a concentrationLiveVC game inside the splitVC
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        
        if let cvc = concentrationLiveViewController {
            // If I'm in my splitVC and I can find my LiveVC --> set the theme
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            // Sets the theme after a game is played
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            // push w/o segue so it doesn't create new ConcentrationVC game obj, rather it pushes the old one
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            // @IB: Added generic segue from ThemeVC to ConcentraitonVC instead of directly from button since want to perform segue via code
            performSegue(withIdentifier: "ChangeTheme", sender: sender)
            
        }
        
    }
    
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeTheme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                    // anytime segue successfully, hold a strong ref to it when it going 'back' usually throws out of heap, so we can push to SAME game obj and continue game where we left off
                }
            }
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
        }
    }
    
    
}
