//
//  HomeScreenVC.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/16/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "HomeScreenVC.h"
#import "TeslaClient.h"
#import <MapKit/MapKit.h>

@interface HomeScreenVC ()

@property (weak, nonatomic) IBOutlet UIView *container;

@property (weak, nonatomic) IBOutlet UILabel *lockedLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *carStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *carStateSubLabel;

@end

@implementation HomeScreenVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vehicleStateUpdated:) name:VehicleStateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(driveStateUpdated:) name:DriveStateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeStateUpdated:) name:ChargeStateNotification object:nil];
    
    
}

- (void)chargeStateUpdated:(NSNotification *)notification
{
    ChargeStateModel* model = [TeslaClient sharedClient].chargeStateModel;
    
    if (model.chargingState && [model.chargingState isEqualToString:@"Charging"])
    {
        _carStateLabel.text = @"Charging";
        
        int hours = 0;
        int minutes = 0;
        
        if (hours > 0)
        {
            _carStateLabel.text = [NSString stringWithFormat:@"%d hr %d min remaining", hours, minutes];
        } else if (hours == 0)
        {
            _carStateLabel.text = [NSString stringWithFormat:@"%d min remaining", minutes];
        }
        
        _carStateSubLabel.text = @"2 hr 50 min remaining";
    }
    else if (model.chargingState && [model.chargingState isEqualToString:@"Complete"])
    {
        _carStateLabel.text = @"Charging Complete";
        _carStateSubLabel.text = @"Time Taken: 6 hr 48 min";
    }

}

- (void)driveStateUpdated:(NSNotification *)notification
{
    
    DriveStateModel* model = [TeslaClient sharedClient].driveStateModel;
    
    if (model.shiftState && ![model.shiftState isEqualToString:@""])
    {
        _carStateLabel.text = @"Activated";
        _carStateSubLabel.text = model.shiftState;
    }
    
    
    // Update Location
    CLLocation *location = [[CLLocation alloc] initWithLatitude:model.latitude longitude:model.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       
                       if(placemarks && placemarks.count > 0)
                       {
                           CLPlacemark *topResult = [placemarks objectAtIndex:0];
                           
                           _addressLabel.text = [NSString stringWithFormat:@"%@ %@",
                                                 [topResult subThoroughfare], [topResult thoroughfare]];
                           
                           _cityLabel.text = [NSString stringWithFormat:@"%@, %@",
                                              [topResult locality], [topResult administrativeArea]];
                           
                           
                       }
                   }];
   
}

- (void)vehicleStateUpdated:(NSNotification *)notification
{
    VehicleStateModel* model = [TeslaClient sharedClient].vehicleStateModel;
    
    if (model.isLocked)
    {
        _lockedLabel.text = @"Locked";
    }
    else
    {
        _lockedLabel.text = @"Unlocked";
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshView:(UIRefreshControl*) sender
{
    // Pull-To-Refresh

    
    VehicleStateModel* model =  [[TeslaClient sharedClient] vehicleStateModel];
    
    model.isRearTrunkOpen = !model.isRearTrunkOpen;
    model.isFrontTrunkOpen = !model.isFrontTrunkOpen;
    model.isLeftFrontDoorOpen = !model.isLeftFrontDoorOpen;
    model.isLeftRearDoorOpen = !model.isLeftRearDoorOpen;
    model.isGreyRims = !model.isGreyRims;
    model.isLocked = !model.isLocked;
    
    [model notifyUpdated];
    
    [sender endRefreshing];

}


@end
