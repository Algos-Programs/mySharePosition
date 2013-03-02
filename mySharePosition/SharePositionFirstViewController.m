//
//  SharePositionFirstViewController.m
//  mySharePosition
//
//  Created by Marco Velluto on 01/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import "SharePositionFirstViewController.h"

@interface SharePositionFirstViewController ()

@end

@implementation SharePositionFirstViewController
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.mapType = MKMapTypeHybrid;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    //Mostro all'utente la sua posizione sulla mappa.
    self.mapView.showsUserLocation = YES;
    
    [SharePositionFirstViewController zoomMap:self.mapView];
    
    //-- Annotation
   MKAnnotationView *annotationView;// = [[MKAnnotationView alloc] initWithFrame:CGRectMake(50.0, 50.0, 300.0, 25.0)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//************************************
#pragma mark - Localization Methods
//************************************

/**
    Fa uno zoom sulla mappa nel punto in cui ti trovi.
 */
+ (void)zoomMap:(MKMapView *)mapView {
    
    CLLocation *location = [SharePositionFirstViewController findCurrentLocation];
    CLLocationCoordinate2D coordinate2D = [location coordinate];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate2D, 2000, 2000);
    MKCoordinateRegion adjustingRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustingRegion animated:YES];
}

/**
 Restituisce la localizzazione attuale.
 */
+ (CLLocation*)findCurrentLocation
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]) {
        //Questo metodo chiede all'utente se l'app può essere localizzata.
        [locationManager startUpdatingLocation];
        locationManager.delegate = locationManager.delegate;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    CLLocation *location = [locationManager location];    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
    return location;
}

- (void)test:(CLLocationCoordinate2D )location {
    
    CLLocationDegrees leftDegrees = self.mapView.region.center.longitude - (self.mapView.region.span.longitudeDelta / 2.0);
    CLLocationDegrees rightDegrees = self.mapView.region.center.longitude + (self.mapView.region.span.longitudeDelta  / 2.0);
    CLLocationDegrees bottomDegrees = self.mapView.region.center.latitude - (self.mapView.region.span.latitudeDelta / 2.0);
    CLLocationDegrees topDegrees = self.mapView.region.center.latitude + (self.mapView.region.span.latitudeDelta / 2.0);
    
    if (leftDegrees > rightDegrees) {
        leftDegrees = -180.0 - leftDegrees;
        if (location.longitude > 0) {
            location.longitude = -180.0 - location.longitude;
        }
    }
}

//************************************
#pragma mark - Alert Methods
//************************************

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Error loading map"
                                                   delegate:nil
                                          cancelButtonTitle:@"OKay"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}

//************************************
#pragma mark - MapView Methods
//************************************

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    static NSString *placemarkIdentifier = @"Map Location Identifier";
    if ([annotation isKindOfClass:[MapLocation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:placemarkIdentifier];
        if (nil == annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:placemarkIdentifier];
            annotationView.image = [UIImage imageNamed:@"prova.jpg"];
        }
        else
            annotationView.annotation = annotation;
        
        annotationView.enabled = YES;
        annotationView.animatesDrop = YES;
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.canShowCallout = YES;
        
        [self performSelector:@selector(openCallout:) withObject:annotation afterDelay:0.5];
        
        /*
        self.progressBar.progress = 0.75;
        self.progressLabel.text = NSLocalizedString(@"Creating Annotation", @"Creating Annotation");
        */
        return annotationView;
    }
    return nil;

}

//************************************
#pragma mark - Acion Methods
//************************************

- (IBAction)pressButtonSharePosition:(id)sender {
    static NSString *str = @"Text to try";

    //[self sendMessageWithNumbers:nil withText:str withLocation:[SharePositionFirstViewController findCurrentLocation]];
    [self sendEMailWithNumbers:nil withText:str withLocation:[SharePositionFirstViewController findCurrentLocation]];
}

//************************************
#pragma mark - Message Methods
//************************************

/**
 Decido cosa fare a seconda dell'esito del messaggio.
 (Send o Cancel)
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			break;
		case MessageComposeResultSent:
			NSLog(@"sent Message");
            [self.navigationController popToRootViewControllerAnimated:YES];
			break;
		default:
			break;
	}
    
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 Invia un messaggio
 Destinatari: Array
 Testo: text
 Location: se NON è nil le inserisce nel testo nel messaggio.
 */
- (void)sendMessageWithNumbers:(NSArray *)numbers withText:(NSString *)text withLocation:(CLLocation *)location {
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
        NSString *coordinateStr = [NSString alloc];
        if (location != nil) {
            CLLocationCoordinate2D coordinate=[location coordinate];
            coordinateStr = [coordinateStr initWithFormat:@"\nMi trovo qui: \nLatitudine: %f \nLongitudine: %f\n",coordinate.latitude, coordinate.longitude];
            
            NSString *googleUrl = [[NSString alloc] initWithString:[SharePositionFirstViewController googleMapsURL:location]];
            
            //https://maps.google.it/maps?saddr=45.422408,9.125234
            coordinateStr = [coordinateStr stringByAppendingString:googleUrl];
        }
        else {
            coordinateStr = [coordinateStr initWithString:@""];
        }
        
        text = [text stringByAppendingString:coordinateStr];
        controller.body = text;
        controller.recipients = numbers;
		//[self presentModalViewController:controller animated:YES];
        [self presentViewController:controller animated:YES completion:nil];
        controller.messageComposeDelegate = self;
	}
}

//************************************
#pragma mark - E-Mail Methods
//************************************

- (void)sendEMailWithNumbers:(NSArray *)numbers withText:(NSString *)text withLocation:(CLLocation *)location {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        NSString *coordinateStr = [NSString alloc];
        if (location != nil) {
            CLLocationCoordinate2D coordinate = [location coordinate];
            coordinateStr = [coordinateStr initWithFormat:@"\nMi trovo qui: \nLatitudine: %f \nLongitudine: %f\n",coordinate.latitude, coordinate.longitude];
            NSString *googleURL = [[NSString alloc] initWithString:[SharePositionFirstViewController googleMapsURL:location]];
            coordinateStr = [coordinateStr stringByAppendingString:googleURL];
        }
        else {
            coordinateStr = [coordinateStr initWithString:@""];
        }
        text = [text stringByAppendingString:coordinateStr];
        [mailController setSubject:@"I'm Here!"]; // OGGETTO
        [mailController setWantsFullScreenLayout:YES];
        [mailController setMessageBody:text isHTML:NO];
        [self presentViewController:mailController animated:YES completion:nil];
        mailController.mailComposeDelegate = self;
    }

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			break;
		case MessageComposeResultSent:
			NSLog(@"sent Message");
            [self.navigationController popToRootViewControllerAnimated:YES];
			break;
		default:
			break;
	}
    
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}


/**
 Genera un url di google maps passata la location
 */
+ (NSString *)googleMapsURL:(CLLocation *)location {
    NSString *googleUrl = [NSString stringWithFormat:@"\nhttps://maps.google.it/maps?saddr=%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    return googleUrl;
}


@end
