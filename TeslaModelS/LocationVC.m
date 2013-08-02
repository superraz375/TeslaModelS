//
//  LocationVC.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/21/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "LocationVC.h"

@interface LocationVC ()

@property (weak, nonatomic) IBOutlet MKUserTrackingBarButtonItem *locateMeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *locateCarButton;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, strong) MKPointAnnotation *carLocation;

@end

@implementation LocationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_locateCarButton setTintColor:[UIColor lightGrayColor]];
    [_locateMeButton setTintColor:[UIColor lightGrayColor]];
    
    [_locateMeButton setMapView: _map];
    [_map setRotateEnabled:YES];
    
    // Init Car Annotation
    _carLocation = [[MKPointAnnotation alloc] init];
    [_map addAnnotation:_carLocation];
    
    
    // START STREAMING HERE
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *carLocationAnnotationID = @"CarLocationAnnotation";
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //Don't trample the user location annotation (pulsing blue dot).
        return nil;
    } else if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
    
        MKAnnotationView *pinView = (MKAnnotationView *)[_map dequeueReusableAnnotationViewWithIdentifier:carLocationAnnotationID];
        
        if ( pinView == nil )
        {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:carLocationAnnotationID];
            //pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"02_loc_car_pin.png"];
        }
        else
        {
            pinView.annotation = annotation;
        }
        
        return pinView;

    }
    
    return nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    if (mode == MKUserTrackingModeNone)
    {
        [_locateMeButton setTintColor: [UIColor lightGrayColor]];
    }
}

- (IBAction)infoButtonClicked:(id)sender {
    // Change map type (Standard Satellite Hybrid)
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    // unselect the selected tracking mode ?
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    // unselect the selected tracking mode ?
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // Handled by MKUserTrackingModeFollow
    
    // TEMPORARY
    [self mapView:_map didUpdateCarLocation:userLocation];
}

-(void)mapView:(MKMapView *)mapView didUpdateCarLocation:(MKUserLocation *)userLocation
{
    
    // Update Car Location
    //CLLocationCoordinate2D annotationCoord;
    //annotationCoord.latitude = 47.640071;
    //annotationCoord.longitude = -122.129598;
    [_carLocation setCoordinate:_map.userLocation.coordinate];
    
    if (_locateCarButton.tintColor == [UIColor blueColor])
    {
        MKCoordinateRegion mapRegion;
        mapRegion.center = _map.userLocation.coordinate;
        //mapRegion.span = _map.region.span;
        [_map setRegion:mapRegion animated: YES];
    }
}
- (IBAction)locateMe:(id)sender {
    
    if (_locateMeButton.tintColor == [UIColor lightGrayColor])
    {
        
        [_locateMeButton setTintColor:[UIColor blueColor]];
        
        if (_locateCarButton.tintColor == [UIColor blueColor])
        {
            [_locateCarButton setTintColor:[UIColor lightGrayColor]];
        }
     
        [_map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
    else
    {
        [_locateMeButton setTintColor:[UIColor lightGrayColor]];
        [_map setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    }
}

- (IBAction)locateCar:(id)sender {
    
    if (_locateCarButton.tintColor == [UIColor lightGrayColor])
    {
        
        [_locateCarButton setTintColor:[UIColor blueColor]];
        
        if (_locateMeButton.tintColor == [UIColor blueColor])
        {
            [_locateMeButton setTintColor:[UIColor lightGrayColor]];
        }
        
        MKCoordinateRegion mapRegion;
        mapRegion.center = _map.userLocation.coordinate;
        
        if (_map.region.span.latitudeDelta > 0.5)
        {
            mapRegion.span = MKCoordinateSpanMake(0.2, 0.2);
        }
        else
        {
            mapRegion.span = _map.region.span;
        }
        
        
        [_map setRegion:mapRegion animated: YES];
    }
    else
    {
        [_locateCarButton setTintColor:[UIColor lightGrayColor]];

    }
}
@end
