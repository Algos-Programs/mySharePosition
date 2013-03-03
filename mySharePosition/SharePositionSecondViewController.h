//
//  SharePositionSecondViewController.h
//  mySharePosition
//
//  Created by Marco Velluto on 01/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFile.h"
#import "MFile.m"

@interface SharePositionSecondViewController : UIViewController

- (IBAction)changeSwitchEmail:(id)sender;
- (IBAction)changeSwitchSMS:(id)sender;

- (IBAction)pressButtonSave:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *switchEmail;
@property (weak, nonatomic) IBOutlet UISwitch *switchSMS;

@end
