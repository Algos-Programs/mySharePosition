//
//  SharePositionFirstViewController.h
//  mySharePosition
//
//  Created by Marco Velluto on 01/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapLocation.h"
#import <MessageUI/MessageUI.h>
#import "MFile.h"

@interface SharePositionFirstViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate, MKAnnotation, MFMessageComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate> {
    
    BOOL withMessage;
    BOOL withEmail;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)pressButtonSharePosition:(id)sender;

@end
