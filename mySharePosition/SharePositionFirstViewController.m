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
@end
