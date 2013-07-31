//
//  TMCarWithDoorsVC.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/16/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "TMCarWithDoorsVC.h"
#import "VehicleStateModel.h"
#import "TeslaClient.h"

@interface TMCarWithDoorsVC ()

@property (readonly, nonatomic) VehicleStateModel* model;

@property (weak, nonatomic) IBOutlet UIImageView *spotlightCar;
@property (weak, nonatomic) IBOutlet UIImageView *carShadow;

@property (weak, nonatomic) IBOutlet UIImageView *body;

@property (weak, nonatomic) IBOutlet UIImageView *sunroofVent;
@property (weak, nonatomic) IBOutlet UIImageView *sunroofOpen;
@property (weak, nonatomic) IBOutlet UIImageView *sunroofClosed;
@property (weak, nonatomic) IBOutlet UIImageView *roof;

@property (weak, nonatomic) IBOutlet UIImageView *leftFrontDoorOpen;
@property (weak, nonatomic) IBOutlet UIImageView *leftFrontDoorClosed;

@property (weak, nonatomic) IBOutlet UIImageView *leftRearDoorOpen;
@property (weak, nonatomic) IBOutlet UIImageView *leftRearDoorClosed;

@property (weak, nonatomic) IBOutlet UIImageView *rightFrontDoorOpen;
@property (weak, nonatomic) IBOutlet UIImageView *rightFrontDoorClosed;

@property (weak, nonatomic) IBOutlet UIImageView *rightRearDoorOpen;
@property (weak, nonatomic) IBOutlet UIImageView *rightRearDoorClosed;

@property (weak, nonatomic) IBOutlet UIImageView *rearTrunkOpen;
@property (weak, nonatomic) IBOutlet UIImageView *rearTrunkClosed;

@property (weak, nonatomic) IBOutlet UIImageView *frontTrunkOpen;
@property (weak, nonatomic) IBOutlet UIImageView *frontTrunkClosed;

@property (weak, nonatomic) IBOutlet UIImageView *darkRimsFront;
@property (weak, nonatomic) IBOutlet UIImageView *darkRimsRear;

@property (weak, nonatomic) IBOutlet UIImageView *spoilerOpen;
@property (weak, nonatomic) IBOutlet UIImageView *spoilerClosed;

@property (weak, nonatomic) IBOutlet UIImageView *chargePortOn;
@property (weak, nonatomic) IBOutlet UIImageView *chargePortClosed;
@property (weak, nonatomic) IBOutlet UIImageView *chargePortOpen;
@property (weak, nonatomic) IBOutlet UIImageView *chargeCableLong;




@end

@implementation TMCarWithDoorsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vehicleStateUpdated:) name:VehicleStateNotification object:nil];

    _model = [[TeslaClient sharedClient] vehicleStateModel ];
    
    [self updateView];

}

- (void)vehicleStateUpdated:(NSNotification *)notification
{
    //VehicleStateModel *model = [TeslaClient sharedClient].vehicleStateModel;
    
    [self updateView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateView
{
 
    // Update Roof
    
    // Update Color
    
    [_darkRimsFront setHidden:!_model.isGreyRims];
    [_darkRimsRear setHidden:!_model.isGreyRims];
    
    [_leftFrontDoorClosed setHidden:_model.isLeftFrontDoorOpen];
    [_leftFrontDoorOpen setHidden: !_model.isLeftFrontDoorOpen];
    
    [_leftRearDoorClosed setHidden:_model.isLeftRearDoorOpen];
    [_leftRearDoorOpen setHidden: !_model.isLeftRearDoorOpen];
    
    [_rightFrontDoorClosed setHidden:_model.isRightFrontDoorOpen];
    [_rightFrontDoorOpen setHidden: !_model.isRightFrontDoorOpen];
    
    [_rightRearDoorClosed setHidden:_model.isRightRearDoorOpen];
    [_rightRearDoorOpen setHidden: !_model.isRightRearDoorOpen];
    
    [_frontTrunkClosed setHidden:_model.isFrontTrunkOpen];
    [_frontTrunkOpen setHidden:!_model.isFrontTrunkOpen];
    
    [_rearTrunkClosed setHidden:_model.isRearTrunkOpen];
    [_rearTrunkOpen setHidden:!_model.isRearTrunkOpen];

    [_spoilerClosed setHidden: !(_model.hasSpoiler && !_model.isRearTrunkOpen)];
    [_spoilerOpen setHidden: !(_model.hasSpoiler && _model.isRearTrunkOpen)];

    [_chargePortClosed setHidden:_model.isChargePortOpen];
    [_chargePortOpen setHidden:!_model.isChargePortOpen];
    
    [_chargePortOn setHidden:!_model.isCharging];
    [_chargeCableLong setHidden:!_model.isCharging];
}

@end
