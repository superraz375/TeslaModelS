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
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teslaVehicleUpdated:) name:TeslaVehicleNotification object:nil];
    [self teslaVehicleUpdated:nil];
    
    [self updateView];

}

- (void)teslaVehicleUpdated:(NSNotification *)notification
{
    NSString *colorString;
    
    switch ([TeslaClient sharedClient].teslaVehicleModel.optionCodes.teslaColor)
    {
        case TeslaColorBlack:
            colorString = @"black";
            break;
        case TeslaColorMetallicBlue:
            colorString = @"blue";
            break;
        case TeslaColorMetallicBrown:
            colorString = @"brown";
            break;
        case TeslaColorMetallicDolphinGrey:
            colorString = @"gray";
            break;
        case TeslaColorMetallicGreen:
            colorString = @"green";
            break;
        case TeslaColorMetallicSilver:
            colorString = @"silver";
            break;
        case TeslaColorMulticoatRed:
            colorString = @"newred";
            break;
        case TeslaColorPearlWhite:
            colorString = @"pearl";
            break;
        case TeslaColorSignatureRed:
            colorString = @"red";
            break;
        case TeslaColorWhite:
            colorString = @"white";
            break;
        default:
            colorString = @"black";
    }
    
    _body.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_body.png", colorString]];
    _roof.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_roof.png", colorString]];

    _leftFrontDoorOpen.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_left_front_open.png", colorString]];
    _leftFrontDoorClosed.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_left_front_closed.png", colorString]];
    
    _leftRearDoorOpen.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_left_rear_open.png", colorString]];
    _leftRearDoorClosed.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_left_rear_closed.png", colorString]];
    
    _rightFrontDoorOpen.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_right_front_open.png", colorString]];
    
    _rightRearDoorOpen.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_right_rear_open.png", colorString]];
    
    _rearTrunkOpen.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_trunk_open.png", colorString]];
    _rearTrunkClosed.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_trunk_closed.png", colorString]];
    
    _frontTrunkOpen.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_frunk_open.png", colorString]];
    _frontTrunkClosed.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_frunk_closed.png", colorString]];
    
    
    
    
    /*
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
*/
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
 
    VehicleStateModel * model = [[TeslaClient sharedClient] vehicleStateModel ];

    
    // Update Roof
    
    // Update Color
    
    [_darkRimsFront setHidden:!model.isGreyRims];
    [_darkRimsRear setHidden:!model.isGreyRims];
    
    [_leftFrontDoorClosed setHidden:model.isLeftFrontDoorOpen];
    [_leftFrontDoorOpen setHidden: !model.isLeftFrontDoorOpen];
    
    [_leftRearDoorClosed setHidden:model.isLeftRearDoorOpen];
    [_leftRearDoorOpen setHidden: !model.isLeftRearDoorOpen];
    
    [_rightFrontDoorClosed setHidden:model.isRightFrontDoorOpen];
    [_rightFrontDoorOpen setHidden: !model.isRightFrontDoorOpen];
    
    [_rightRearDoorClosed setHidden:model.isRightRearDoorOpen];
    [_rightRearDoorOpen setHidden: !model.isRightRearDoorOpen];
    
    [_frontTrunkClosed setHidden:model.isFrontTrunkOpen];
    [_frontTrunkOpen setHidden:!model.isFrontTrunkOpen];
    
    [_rearTrunkClosed setHidden:model.isRearTrunkOpen];
    [_rearTrunkOpen setHidden:!model.isRearTrunkOpen];

    [_spoilerClosed setHidden: !(model.hasSpoiler && !model.isRearTrunkOpen)];
    [_spoilerOpen setHidden: !(model.hasSpoiler && model.isRearTrunkOpen)];

    [_chargePortClosed setHidden:model.isChargePortOpen];
    [_chargePortOpen setHidden:!model.isChargePortOpen];
    
    [_chargePortOn setHidden:!model.isCharging];
    [_chargeCableLong setHidden:!model.isCharging];
}

@end
