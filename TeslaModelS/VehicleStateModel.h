//
//  TeslaVehicleModel.h
//  TeslaModelS
//
//  Created by Raz Friman on 7/18/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleStateModel : NSObject

@property (nonatomic) BOOL hasSpoiler;
@property (nonatomic) BOOL isFrontTrunkOpen;
@property (nonatomic) BOOL isRearTrunkOpen;
@property (nonatomic) BOOL isRightFrontDoorOpen;
@property (nonatomic) BOOL isRightRearDoorOpen;
@property (nonatomic) BOOL isLeftFrontDoorOpen;
@property (nonatomic) BOOL isLeftRearDoorOpen;
@property (nonatomic) BOOL isGreyRims;

@property (nonatomic) BOOL isChargePortOpen;
@property (nonatomic) BOOL isCharging;

@property (nonatomic) BOOL isLocked;
@property (nonatomic) BOOL hasSunroof;

@property (nonatomic, strong) NSString* carVersion;
@property (nonatomic, strong) NSString* sunRoofState;
@property (nonatomic, strong) NSNumber* sunRoofPercentOpen;
@property (nonatomic, strong) NSString* wheelType;
@property (nonatomic, strong) NSString* roofColor;
@property (nonatomic, strong) NSString* performanceConfiguration;

- (void) notifyUpdated;

@end

/*
 {
 "df": false,                  // driver's side front door open
 "dr": false,                  // driver's side rear door open
 "pf": false,                  // passenger's side front door open
 "pr": false,                  // passenger's side rear door open
 "ft": false,                  // front trunk is open
 "rt": false,                  // rear trunk is open
 "car_verson": "1.19.42",      // car firmware version
 "locked": true,               // car is locked
 "sun_roof_installed": false,  // panoramic roof is installed
 "sun_roof_state": "unknown",
 "sun_roof_percent_open": 0,   // null if not installed
 "dark_rims": false,           // gray rims installed
 "wheel_type": "Base19",       // wheel type installed
 "has_spoiler": false,         // spoiler is installed
 "roof_color": "Colored",      // "None" for panoramic roof
 "perf_config": "Base"
 }
*/