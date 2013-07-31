//
//  TeslaClient.h
//  TeslaModelS
//
//  Created by Raz Friman on 7/17/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "ChargeStateModel.h"
#import "VehicleStateModel.h"
#import "ClimateStateModel.h"
#import "GuiSettingsModel.h"
#import "DriveStateModel.h"
#import "TeslaVehicleModel.h"

@interface TeslaClient : AFHTTPClient

+ (TeslaClient *)sharedClient;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray* teslaVehiclesArray;
@property (nonatomic, strong) TeslaVehicleModel* teslaVehicleModel;

@property (nonatomic, strong) ChargeStateModel* chargeStateModel;
@property (nonatomic, strong) VehicleStateModel* vehicleStateModel;
@property (nonatomic, strong) ClimateStateModel* climateStateModel;
@property (nonatomic, strong) GuiSettingsModel* guiSettingsModel;
@property (nonatomic, strong) DriveStateModel* driveStateModel;

extern NSString *const TeslaServerBaseString;
extern NSString *const TeslaVehicleNotification;
extern NSString *const ChargeStateNotification;
extern NSString *const VehicleStateNotification;
extern NSString *const ClimateStateNotification;
extern NSString *const GuiSettingsNotification;
extern NSString *const DriveStateNotification;


- (void) startTimer;
- (void) stopTimer;
- (void) updateModels:(NSTimer *) timer;

//- (void) getVehicles;
- (void) getVehicleStateModel:(int)vehicleId;
- (void) getChargeStateModel:(int)vehicleId;
- (void) getGuiSettingsModel:(int)vehicleId;
- (void) getDriveStateModel:(int)vehicleId;
- (void) getClimateStateModel:(int)vehicleId;
- (void) getMobileEnabledModel:(int)vehicleId;
- (void) openChargePortDoor:(int)vehicleId;
- (void) setChargeLimit:(int)vehicleId withPercent:(int)percent;
- (void) chargeStandard:(int)vehicleId; // Deprecated in v4.5
- (void) chargeMaxRange:(int)vehicleId; // Deprecated in v4.5
- (void) chargeStart:(int)vehicleId;
- (void) chargeStop:(int)vehicleId;
- (void) flashLights:(int)vehicleId;
- (void) honkHorn:(int)vehicleId;
- (void) doorUnlock:(int)vehicleId;
- (void) doorLock:(int)vehicleId;
- (void) startAirConditioning:(int)vehicleId;
- (void) stopAirConditioning:(int)vehicleId;
- (void) sunroofControl:(int)vehicleId;
- (void) setTemperture:(int)vehicleId;
@end