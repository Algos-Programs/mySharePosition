//
//  InfoLocationsViewController.h
//  mySharePosition
//
//  Created by Marco Velluto on 08/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoLocationsViewController : UITableViewController {
    
    NSMutableArray *array; //Conterrà le info della localizzione (es. Via marzabotto, 10, 20090).
    NSArray *arrayNames; //Conterrà i nomi delle info localizzazione (es. Via, N°, CAP).
}
@property (weak, nonatomic) IBOutlet UILabel *developedLabel;

@end
