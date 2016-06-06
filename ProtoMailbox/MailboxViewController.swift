//
//  MailboxViewController.swift
//  ProtoMailbox
//
//  Created by Jonathan Chen on 6/5/16.
//  Copyright © 2016 Chenlo Park. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var mailboxScrollView: UIScrollView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var messageParentView: UIView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    
    var messageOriginalCenter: CGPoint!
    var messageDefault: CGPoint!
    var laterIconOriginalCenter: CGPoint!
    var deleteIconOriginalCenter: CGPoint!
    var archiveIconOriginalCenter: CGPoint!
    var listIconOriginalCenter: CGPoint!
    var feedOffset: CGFloat = 86
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up scroll view
        mailboxScrollView.contentSize = CGSize(width: 320, height: 1380)
        
        // record default message position
        messageDefault = CGPoint(x: messageView.center.x, y: messageView.center.y)
        
        print(messageDefault)
        
        // disable secondary icons on load
        listIcon.hidden = true
        deleteIcon.hidden = true
        archiveIcon.hidden = true
        laterIcon.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMessagePan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            // do something
            messageOriginalCenter = messageView.center
            laterIconOriginalCenter = laterIcon.center
            listIconOriginalCenter = listIcon.center
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            // set up view
            messageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            listIcon.hidden = true
            deleteIcon.hidden = true
            archiveIcon.hidden = true
            laterIcon.hidden = true
            
            // CHANGE COLORS AND ICONS BASED ON MESSAGE POSITION
            
            // default color - gray
            if messageView.frame.origin.x > -60 &&
                messageView.frame.origin.x < 60 {
                view.backgroundColor =
                    UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
                laterIcon.hidden = false
                laterIcon.alpha = convertValue(abs(messageView.frame.origin.x), r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
                archiveIcon.hidden = false
                archiveIcon.alpha = convertValue(abs(messageView.frame.origin.x), r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
            }
            
            // later - yellow
            if messageView.frame.origin.x < -60 &&
               messageView.frame.origin.x > -230 {
                view.backgroundColor = UIColor(red:0.98, green:0.82, blue:0.15, alpha:1.0)
                laterIcon.hidden = false
                laterIcon.alpha = 1.0
                laterIcon.center = CGPoint(x: messageView.frame.origin.x + 352, y: laterIconOriginalCenter.y)
            }
            
            // list - brown
            if messageView.frame.origin.x < -230 {
                view.backgroundColor = UIColor(red:0.82, green:0.65, blue:0.47, alpha:1.0)
                listIcon.hidden = false
                listIcon.center = CGPoint(x: messageView.frame.origin.x + 352, y: listIconOriginalCenter.y)
            }

            // archive - green
            if messageView.frame.origin.x > 60 &&
               messageView.frame.origin.x < 230 {
                view.backgroundColor = UIColor(red:0.53, green:0.82, blue:0.36, alpha:1.0)
                archiveIcon.hidden = false
                archiveIcon.alpha = 1.0
                archiveIcon.center = CGPoint(x: messageView.frame.origin.x - 32, y: archiveIcon.center.y)
            }
            
            // delete - red
            if messageView.frame.origin.x > 230 {
                view.backgroundColor = UIColor(red:0.87, green:0.38, blue:0.15, alpha:1.0)
                deleteIcon.hidden = false
                deleteIcon.center = CGPoint(x: messageView.frame.origin.x - 32, y: deleteIcon.center.y)
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            // no action zone - gray
            if messageView.frame.origin.x > -60 &&
                messageView.frame.origin.x < 60 {

                
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
                    
                    self.messageView.center = self.messageDefault
                    
                    }, completion: { (Bool) -> Void in
                })
                
                // reset color
                view.backgroundColor =
                    UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
            }
            
            // later - yellow
            if messageView.frame.origin.x < -60 &&
                messageView.frame.origin.x > -230 {
                
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
                    
                    //self.messageView.frame.origin.x = -320
                    self.messageParentView.frame.origin.x = -self.view.frame.size.width
                    
                    }, completion: { (Bool) -> Void in
                    
                        UIView.animateWithDuration(0.4, animations: {
                            self.rescheduleView.alpha = 1.0
                        })
                        
         
                })
            }
            
            // list - brown
            if messageView.frame.origin.x < -230 {
             
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
                    
                    //self.messageView.frame.origin.x = -320
                    self.messageParentView.frame.origin.x = -self.view.frame.size.width
                    
                    }, completion: { (Bool) -> Void in
                        
                        UIView.animateWithDuration(0.4, animations: {
                            self.listView.alpha = 1.0
                        })
                        
                })
            }
            
            
            // archive - green
            if messageView.frame.origin.x > 60 &&
                messageView.frame.origin.x < 230 {
                
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
                    
                    //self.messageView.frame.origin.x = -320
                    self.messageParentView.frame.origin.x = self.view.frame.size.width
                    
                    }, completion: { (Bool) -> Void in
                        self.hideMessageAndResetColor()
                })
                showAndResetMessage()
            }
            
            // delete - red
            if messageView.frame.origin.x > 230 {
                
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
                    
                    //self.messageView.frame.origin.x = -320
                    self.messageParentView.frame.origin.x = self.view.frame.size.width
                    
                    }, completion: { (Bool) -> Void in
                        
                        self.hideMessageAndResetColor()
                        
                })
                showAndResetMessage()
            }
            
        }
        
    }

    @IBAction func onOverlayTap(sender: UITapGestureRecognizer) {
        let overlayView = sender.view as! UIImageView
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            overlayView.alpha = 0.0
            
            }, completion: { (Bool) -> Void in
                self.hideMessageAndResetColor()
        })
        showAndResetMessage()
    }
    
    func hideMessageAndResetColor() {
        UIView.animateWithDuration(0.2, animations: {
            //self.messageParentView.hidden = true
            self.feedView.frame.origin.y -= self.feedOffset
            // reset color
            self.view.backgroundColor =
                UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
        })
    }
    
    func showAndResetMessage() {
        UIView.animateWithDuration(0.2, delay: 1.5, options: [], animations: { () -> Void in
                self.messageParentView.hidden = false
                self.messageParentView.frame.origin.x = 0
                self.messageView.center = self.messageDefault
                self.feedView.frame.origin.y += self.feedOffset
            }, completion: nil)
    }
    
    
}
