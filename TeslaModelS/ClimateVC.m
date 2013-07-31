//
//  ClimateVC.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/16/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "ClimateVC.h"
#import "TeslaClient.h"

@interface ClimateVC ()

@property (weak, nonatomic) IBOutlet UIButton *frontHeater;
@property (weak, nonatomic) IBOutlet UIButton *rearHeater;

@property (weak, nonatomic) IBOutlet UIImageView *rearDefrosterImage;
@property (weak, nonatomic) IBOutlet UIImageView *frontDefrosterImage;

@property (weak, nonatomic) IBOutlet UIImageView *frontColdImage;
@property (weak, nonatomic) IBOutlet UIImageView *frontHotImage;

@property (weak, nonatomic) IBOutlet UIImageView *hotAirImage;
@property (weak, nonatomic) IBOutlet UIImageView *coldAirImage;
@property (weak, nonatomic) IBOutlet UIImageView *mediumAirImage;


@end

@implementation ClimateVC

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(climateStateUpdated:) name:ClimateStateNotification object:nil];
    
    [[TeslaClient sharedClient] getClimateStateModel:[TeslaClient sharedClient].teslaVehicleModel.idNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleFrontHeater:(id)sender {
    
    //ClimateStateModel* model = [TeslaClient sharedClient].climateStateModel;
    
    /*
     if (model.frontDefroster && model.frontDefroster.boolValue)
    {
        [_frontHeater setSelected:NO];
    } else {
        [_frontHeater setSelected:YES];
    }
    
    [model notifyUpdated];
     */
    
}

- (IBAction)toggleRearHeater:(id)sender {
    
    //ClimateStateModel* model = [TeslaClient sharedClient].climateStateModel;

}

- (void) climateStateUpdated:(NSNotification*) notification
{
    ClimateStateModel* model = [TeslaClient sharedClient].climateStateModel;
    
    [_frontDefrosterImage setHidden:!(model.frontDefroster && model.frontDefroster.boolValue)];
    [_rearDefrosterImage setHidden:!(model.rearDefroster && model.rearDefroster.boolValue)];
    
    [_frontHeater setSelected:(model.frontDefroster && model.frontDefroster.boolValue)];
    [_rearHeater setSelected:(model.rearDefroster && model.rearDefroster.boolValue)];
    
    // Cold = LOW-72
    // Medium = 73
    // Hot = 74-HIGH
    
    [_coldAirImage setHidden:!(model.isAirConditioningOn)];
    [_mediumAirImage setHidden:!model.isAirConditioningOn];
    [_hotAirImage setHidden:!model.isAirConditioningOn];
}

// Middle = 73 F

@end
