//
//  TeslaVehicleModel.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/22/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "TeslaVehicleModel.h"
#import "TeslaClient.h"
#import "Utilities.h"
#import "OptionCodesModel.h"

@implementation TeslaVehicleModel

- (void) notifyUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TeslaVehicleNotification object:self];
}

- (void) load:(NSDictionary*) attributes
{
    _color =[attributes objectForKeyNotNull:@"color"];
    _displayName =[attributes objectForKeyNotNull:@"display_name"];
    _idNumber =[[attributes objectForKeyNotNull:@"id"] intValue];
    _optionCodes = [[OptionCodesModel alloc] initWithString:[attributes objectForKeyNotNull:@"option_codes"]];
    _userId =[[attributes objectForKeyNotNull:@"user_id"] intValue];
    _vehicleId =[[attributes objectForKeyNotNull:@"vehicle_id"] intValue];
    _vin =[attributes objectForKeyNotNull:@"vin"];
    
    _tokens = (NSArray*) [attributes objectForKeyNotNull:@"tokens"];
    
    _state =[attributes objectForKeyNotNull:@"state"];
    
    [self notifyUpdated];

}

@end
