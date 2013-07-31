//
//  ClimateStateModel.h
//  TeslaModelS
//
//  Created by Raz Friman on 7/21/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClimateStateModel : NSObject

@property (nonatomic) double insideTemperature;
@property (nonatomic) double outsideTemperature;
@property (nonatomic) double driverTemperature;
@property (nonatomic) double passengerTemperature;
@property (nonatomic) BOOL isAirConditioningOn;
@property (nonatomic, strong) NSNumber* frontDefroster;
@property (nonatomic, strong) NSNumber* rearDefroster;
@property (nonatomic, strong) NSNumber* fanSpeed;

- (void) notifyUpdated;

@end

/*
 {
 "inside_temp": 17.0,          // degC inside car
 "outside_temp": 9.5,          // degC outside car or null
 "driver_temp_setting": 22.6,  // degC of driver temperature setpoint
 "passenger_temp_setting": 22.6, // degC of passenger temperature setpoint
 "is_auto_conditioning_on": false, // apparently even if on
 "is_front_defroster_on": null, // null or boolean as integer?
 "is_rear_defroster_on": false,
 "fan_status": 0               // fan speed 0-6 or null
 }
*/