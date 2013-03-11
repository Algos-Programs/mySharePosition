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
#import <Social/Social.h>

@interface SharePositionFirstViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate, MKAnnotation, MFMessageComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate> {
    
    //-- Localizzazione
    CLGeocoder *gecoder;
    CLPlacemark *placemark;
    
    //-- Info Localizzione
    NSString *streetAdress;
    NSString *streetAdressSecondLine;
    NSString *city;
    NSString *subLocality;
    NSString *state;
    NSString *ZIPCode;
    NSString *country;
    
    //-- Testo dei messaggi
    NSString *textMessage;
    NSString *textEmail;
    
    BOOL withAnnotation;
    BOOL withAlertView;
    BOOL withActivityView;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//-- Info Localizzione
@property (nonatomic, strong)NSString *streetAdress;
@property (nonatomic, strong)NSString *streetAdressSecondLine;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *state;
@property (nonatomic, strong)NSString *ZIPCode;
@property (nonatomic, strong)NSString *country;

@property (weak, nonatomic) IBOutlet UILabel *labelSharePosition;

- (IBAction)pressButtonSharePosition:(id)sender;

@end
