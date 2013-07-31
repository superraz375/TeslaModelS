//
//  ChargeVC.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/16/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "ChargeVC.h"
#import "TeslaClient.h"

@interface ChargeVC ()

@property (weak, nonatomic) IBOutlet UILabel *chargeUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeVoltageLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeAmperageLabel;
@property (weak, nonatomic) IBOutlet UISlider *chargeLimitSlider;

@end

@implementation ChargeVC

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeStatusUpdated:) name:ChargeStateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeStatusUpdated:) name:GuiSettingsNotification object:nil];
    
    [[TeslaClient sharedClient] updateModels:nil];

}

- (void) chargeStatusUpdated:(NSNotification *) notification
{
    ChargeStateModel *chargeModel = [TeslaClient sharedClient].chargeStateModel;
    GuiSettingsModel *guiModel = [TeslaClient sharedClient].guiSettingsModel;
    
    if (YES || [chargeModel.chargingState isEqualToString:@"Charging"])
    {
        
        NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"Helvetica Neue" size:17.0], NSFontAttributeName,
                                     [UIColor darkGrayColor], NSForegroundColorAttributeName, nil];

        NSDictionary *attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"Helvetica Neue" size:14.0], NSFontAttributeName,
                                     [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
        
        NSDictionary *attributes3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"Helvetica Neue" size:17.0], NSFontAttributeName,
                                     [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
        
        
        NSMutableAttributedString *unitsString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", chargeModel.chargeRate] attributes:attributes1];
        
        NSMutableAttributedString *unitsString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", guiModel.chargeRateUnits] attributes:attributes2];
        
        [unitsString1 appendAttributedString:unitsString2];
        _chargeUnitsLabel.attributedText = unitsString1;
        
        
        
        NSMutableAttributedString *voltageString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", chargeModel.chargerVoltage] attributes:attributes1];
        
        NSMutableAttributedString *voltageString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" V"] attributes:attributes2];
        
        [voltageString1 appendAttributedString:voltageString2];
        _chargeVoltageLabel.attributedText = voltageString1;
        
        
        
        
        NSMutableAttributedString *amperageString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", chargeModel.chargerActualCurrent] attributes:attributes1];
        
        NSMutableAttributedString *amperageString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%d", chargeModel.chargerPilotCurrent] attributes:attributes3];

        NSMutableAttributedString *amperageString3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" A"] attributes:attributes2];

        [amperageString1 appendAttributedString:amperageString2];
        [amperageString1 appendAttributedString:amperageString3];
        
        _chargeAmperageLabel.attributedText = amperageString1;
        
    }
    
    
}

- (IBAction)chargeLimitChanged:(id)sender {
    
    TeslaClient *client = [TeslaClient sharedClient];
    [client setChargeLimit:client.teslaVehicleModel.idNumber withPercent:_chargeLimitSlider.value];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
