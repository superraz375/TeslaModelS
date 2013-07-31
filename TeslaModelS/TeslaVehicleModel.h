//
//  TeslaVehicleModel.h
//  TeslaModelS
//
//  Created by Raz Friman on 7/22/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionCodesModel.h"

@interface TeslaVehicleModel : NSObject

@property (nonatomic, strong) NSString* color;
@property (nonatomic, strong) NSString* displayName;
@property (nonatomic) NSInteger idNumber;
@property (nonatomic, strong) OptionCodesModel* optionCodes;
@property (nonatomic) NSInteger userId;
@property (nonatomic) NSInteger vehicleId;
@property (nonatomic, strong) NSString* vin;
@property (nonatomic, strong) NSArray* tokens;
@property (nonatomic, strong) NSString* state; //Online/Asleep


- (void) notifyUpdated;
- (void) load:(NSDictionary*) attributes;

@end

/*
 "color": null,
 "display_name": null,
 "id": 321,
 "option_codes": "MS01,RENA,TM00,DRLH,PF00,BT85,PBCW,RFPO,WT19,IBMB,IDPB,TR00,SU01,SC01,TP01,AU01,CH00,HP00,PA00,PS00,AD02,X020,X025,X001,X003,X007,X011,X013",
 "user_id": 123,
 "vehicle_id": 1234567890,
 "vin": "5YJSA1CN5CFP01657",
 "tokens": ["x", "x"],
 "state": "online"
 */
