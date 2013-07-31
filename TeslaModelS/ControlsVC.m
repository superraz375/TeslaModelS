//
//  ControlsVC.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/18/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "ControlsVC.h"
#import "TeslaClient.h"

@interface ControlsVC ()
@property (weak, nonatomic) IBOutlet UIImageView *lockImage;

@end

@implementation ControlsVC

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vehicleStateUpdated:) name:VehicleStateNotification object:nil];
    
    // Update the VehicleStateModel
    [[TeslaClient sharedClient] getVehicleStateModel:[TeslaClient sharedClient].teslaVehicleModel.idNumber];

}


- (void)vehicleStateUpdated:(NSNotification *)notification
{
    VehicleStateModel* model = [TeslaClient sharedClient].vehicleStateModel;
    
    [_lockImage setHighlighted:!model.isLocked];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)honkHorn:(id)sender {
    TeslaClient* client = [TeslaClient sharedClient];
    
    [client honkHorn:client.teslaVehicleModel.idNumber];
}

- (IBAction)flashLights:(id)sender {
    TeslaClient* client = [TeslaClient sharedClient];
    
    [client flashLights:client.teslaVehicleModel.idNumber];
}

- (IBAction)lockCar:(id)sender {
    TeslaClient* client = [TeslaClient sharedClient];
    
    [client doorLock:client.teslaVehicleModel.idNumber];
    [client getVehicleStateModel:client.teslaVehicleModel.idNumber];
}

- (IBAction)unlockCar:(id)sender {
    TeslaClient* client = [TeslaClient sharedClient];
    
    [client doorUnlock:client.teslaVehicleModel.idNumber];
    [client getVehicleStateModel:client.teslaVehicleModel.idNumber];
}

@end
