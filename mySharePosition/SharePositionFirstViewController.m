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
    
    textMessage = @"I'm Here!";
    textEmail = textMessage;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    //Mostro all'utente la sua posizione sulla mappa.
    self.mapView.showsUserLocation = YES;
    
    [SharePositionFirstViewController zoomMap:self.mapView];
    
    //-- Annotation
    MKAnnotationView *annotationView;// = [[MKAnnotationView alloc] initWithFrame:CGRectMake(50.0, 50.0, 300.0, 25.0)];
    gecoder = [[CLGeocoder alloc] init];
    
    [self reverseGeocode:[SharePositionFirstViewController findCurrentLocation]];
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

- (void)reverseGeocode:(CLLocation *)location
{
    if (!gecoder)
        gecoder = [[CLGeocoder alloc] init];
    
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error){
        if (nil != error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error translating coordinates into location", @"Error translating coordinates into location")
                                                            message:NSLocalizedString(@"Geocoder did not recognize coordinates", @"Geocoder did not recognize coordinates")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        else if ([placemarks count] > 0) {
            placemark = [placemarks objectAtIndex:0];
            MapLocation *annotation = [[MapLocation alloc] init];
            annotation.street = placemark.thoroughfare;
            annotation.city = placemark.locality;
            annotation.state = placemark.administrativeArea;
            annotation.zip = placemark.postalCode;
            annotation.coordinate = location.coordinate;
            
            [self setInfoLocationFrom:nil];
            //[self.mapView addAnnotation:annotation];
        }
    }];
}

- (void)setLocationArgoments:(CLLocation *)location {
    
    if (!gecoder) {
        gecoder = [[CLGeocoder alloc] init];
    }
    
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error){
        if (nil != error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error translating coordinates into location", @"Error translating coordinates into location")
                                                            message:NSLocalizedString(@"Geocoder did not recognize coordinates", @"Geocoder did not recognize coordinates")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        else if ([placemarks count] > 0) {
            placemark = [placemarks objectAtIndex:0];
            
            [self setLocationArgoments:nil];
/*
        //Setto variabili
            streetAdress = [placemark thoroughfare];
            streetAdressSecondLine = [placemark subThoroughfare];
            city = [placemark locality];
            subLocality = [placemark subLocality];
            state = [placemark administrativeArea];
            ZIPCode = [placemark postalCode];
            country = country;
*/
        }
    }];
}

- (void)setInfoLocationFrom:(CLPlacemark *)aPlacemark {
    
    if (aPlacemark == nil) {
        aPlacemark = placemark;
    }
    streetAdress = [aPlacemark thoroughfare];
    streetAdressSecondLine = [aPlacemark subThoroughfare];
    city = [aPlacemark locality];
    subLocality = [aPlacemark subLocality];
    state = [aPlacemark administrativeArea];
    ZIPCode = [aPlacemark postalCode];
    country = [aPlacemark country];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    switch (buttonIndex) {
        case 0: // SMS
            [self sendMessageWithNumbers:nil withText:nil withLocation:[SharePositionFirstViewController findCurrentLocation]];
            break;
            
        case 1: //Email
            [self sendEMailWithNumbers:nil withText:nil withLocation:[SharePositionFirstViewController findCurrentLocation]];
            break;
        default:
            break;
    }
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
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Share Position" message:@"Condividi Posizione" delegate:self cancelButtonTitle:@"SMS" otherButtonTitles:@"Email", nil];
    
    [alertView show];    
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
        NSString *adressString = [NSString alloc];
        if (location != nil) {
            CLLocationCoordinate2D coordinate=[location coordinate];
            coordinateStr = [coordinateStr initWithFormat:@"\nMi trovo qui: \nLatitudine: %f \nLongitudine: %f\n",coordinate.latitude, coordinate.longitude];
            
            adressString = [adressString initWithString:[self setStringFromInfoLocation]];
            
            NSString *googleUrl = [[NSString alloc] initWithString:[SharePositionFirstViewController googleMapsURL:location]];
            
            //https://maps.google.it/maps?saddr=45.422408,9.125234
            coordinateStr = [coordinateStr stringByAppendingString:googleUrl];
        }
        else {
            coordinateStr = [coordinateStr initWithString:@""];
        }
        
        if (text == nil) {
            text = @"";
        }
        text = [text stringByAppendingString:adressString];
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
        NSString *addressStr = [NSString alloc];
        if (location != nil) {
            CLLocationCoordinate2D coordinate = [location coordinate];
            coordinateStr = [coordinateStr initWithFormat:@"\nMi trovo qui: \nLatitudine: %f \nLongitudine: %f\n",coordinate.latitude, coordinate.longitude];
            
            addressStr = [addressStr initWithString:[self setStringFromInfoLocation]];
            
            NSString *googleURL = [[NSString alloc] initWithString:[SharePositionFirstViewController googleMapsURL:location]];
            coordinateStr = [coordinateStr stringByAppendingString:googleURL];
        }
        else {
            coordinateStr = [coordinateStr initWithString:@""];
        }
        if (text == nil) {
            text = @"";
        }

        text = [text stringByAppendingString:addressStr];
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
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

//****************************************
#pragma mark - Set String Methods
//****************************************

/**
 Genera un url di google maps passata la location
 */
+ (NSString *)googleMapsURL:(CLLocation *)location {
    NSString *googleUrl = [NSString stringWithFormat:@"\nhttps://maps.google.it/maps?saddr=%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    return googleUrl;
}

- (NSString *)setStringFromInfoLocation {
    
    NSString *str = [[NSString alloc] initWithFormat:@"%@ %@, %@, %@, %@ %@\n", streetAdress, streetAdressSecondLine, city, ZIPCode, state, country];
    
    return str;
}



@end
