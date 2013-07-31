//
//  DriveStateModel.h
//  TeslaModelS
//
//  Created by Raz Friman on 7/21/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriveStateModel : NSObject

@property (nonatomic) float longitude;
@property (nonatomic) float latitude;

@property (nonatomic, strong) NSString* shiftState;
@property (nonatomic, strong) NSNumber* speed;
@property (nonatomic) NSInteger heading;
@property (nonatomic) long gpsTimestamp;

- (void) notifyUpdated;

@end

/*
 {
 "shift_state": null,          //
 "speed": null,                //
 "latitude": 33.794839,        // degrees N of equator
 "longitude": -84.401593,      // degrees W of the prime meridian
 "heading": 4,                 // integer compass heading, 0-359
 "gps_as_of": 1359863204       // Unix timestamp of GPS fix
 }
*/