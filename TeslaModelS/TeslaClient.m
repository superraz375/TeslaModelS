//
//  TeslaClient.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/17/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "TeslaClient.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Utilities.h"

#ifdef DEBUG
NSString *const TeslaServerBaseString = @"https://private-857c-timdorr.apiary.io/";
#else
NSString *const TeslaServerBaseString = @"https://portal.vn.teslamotors.com/";
#endif

static const double UPDATE_INTERVAL = 15.0;

NSString *const TeslaVehicleNotification = @"TeslaVehicleNotification";
NSString *const ChargeStateNotification = @"ChargeStateNotification";
NSString *const VehicleStateNotification = @"VehicleStateNotification";
NSString *const ClimateStateNotification = @"ClimateStateNotification";
NSString *const GuiSettingsNotification = @"GuiSettingsNotification";
NSString *const DriveStateNotification = @"DriveStateNotification";

@implementation TeslaClient

+ (TeslaClient *)sharedClient {
    
    static TeslaClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TeslaClient alloc] initWithBaseURL:[NSURL URLWithString:TeslaServerBaseString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    _teslaVehiclesArray = [[NSArray alloc] init];
    _teslaVehicleModel = [[TeslaVehicleModel alloc] init];
    
    _chargeStateModel = [[ChargeStateModel alloc] init];
    _vehicleStateModel = [[VehicleStateModel alloc] init];
    _climateStateModel = [[ClimateStateModel alloc] init];
    _guiSettingsModel = [[GuiSettingsModel alloc] init];
    _driveStateModel = [[DriveStateModel alloc] init];
        
    return self;
}

- (void) startTimer
{
    [self updateModels:nil];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL target:self selector:@selector(updateModels:) userInfo:Nil repeats:YES];
}

- (void) stopTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void) updateModels:(NSTimer *) timer
{
    [self getDriveStateModel:_teslaVehicleModel.idNumber];
    [self getChargeStateModel:_teslaVehicleModel.idNumber];
    [self getClimateStateModel:_teslaVehicleModel.idNumber];
    [self getGuiSettingsModel:_teslaVehicleModel.idNumber];
    [self getMobileEnabledModel:_teslaVehicleModel.idNumber];
    [self getVehicleStateModel:_teslaVehicleModel.idNumber];
}

/*
- (void) getVehicles
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"/vehicles" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            NSArray *vehicles = (NSArray*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Load Vehicle Error: %@", error);
                                                                                        }];
    
    [operation start];
}
*/

- (void) getVehicleStateModel:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/vehicle_state", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            NSDictionary *data = (NSDictionary*) JSON;
            
            VehicleStateModel* model = [self vehicleStateModel];
            model.isLeftFrontDoorOpen =[[data objectForKeyNotNull:@"df"] boolValue];
            model.isLeftRearDoorOpen =[[data objectForKeyNotNull:@"dr"] boolValue];
            model.isRightFrontDoorOpen =[[data objectForKeyNotNull:@"pf"] boolValue];
            model.isRightRearDoorOpen =[[data objectForKeyNotNull:@"pr"] boolValue];
            model.isFrontTrunkOpen =[[data objectForKeyNotNull:@"ft"] boolValue];
            model.isRearTrunkOpen =[[data objectForKeyNotNull:@"rt"] boolValue];
            model.isGreyRims =[[data objectForKeyNotNull:@"dark_rims"] boolValue];
            model.isLocked = [[data objectForKeyNotNull:@"locked"] boolValue];
            model.hasSunroof = [[data objectForKeyNotNull:@"sun_roof_installed"] boolValue];
            model.hasSpoiler = [[data objectForKeyNotNull:@"has_spoiler"] boolValue];
            
            model.carVersion = [data objectForKeyNotNull:@"car_verson"];
            model.sunRoofState = [data objectForKeyNotNull:@"sun_roof_state"];
            model.roofColor = [data objectForKeyNotNull:@"roof_color"];
            model.wheelType = [data objectForKeyNotNull:@"wheel_type"];
            model.performanceConfiguration = [data objectForKeyNotNull:@"perf_config"];
            model.sunRoofPercentOpen = [NSNumber numberWithInteger:[[data objectForKeyNotNull:@"sun_roof_percent_open"] integerValue]];

            [model notifyUpdated];
            
            
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            
            NSLog(@"Error: %@", error);
        }];
    
    [operation start];
}

- (void) getChargeStateModel:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/charge_state", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                NSDictionary *data = (NSDictionary*) JSON;
                
                ChargeStateModel* model = [self chargeStateModel];
             
                model.chargingState = [data objectForKeyNotNull:@"charging_state"];
                model.isChargeToMaxRange = [[data objectForKeyNotNull:@"charge_to_max_range"] boolValue];
                model.maxRangeChargeCounter = [[data objectForKeyNotNull:@"max_range_charge_counter"] integerValue];
                model.isUsingSupercharger = [[data objectForKeyNotNull:@"fast_charger_present"] boolValue];
                model.batteryRange = [[data objectForKeyNotNull:@"battery_range"] doubleValue];
                model.estimatedBatteryRange = [[data objectForKeyNotNull:@"est_battery_range"] doubleValue];
                model.idealBatteryRange = [[data objectForKeyNotNull:@"ideal_battery_range"] doubleValue];
                model.batteryLevel = [[data objectForKeyNotNull:@"battery_level"] integerValue];
                model.batteryCurrent = [[data objectForKeyNotNull:@"battery_current"] doubleValue];
                model.chargeStartingRange = [NSNumber numberWithInteger:[[data objectForKeyNotNull:@"charge_starting_range"] integerValue]];
                model.chargeStartingSoc = [NSNumber numberWithInteger:[[data objectForKeyNotNull:@"charge_starting_soc"] integerValue]];
                model.chargerVoltage = [[data objectForKeyNotNull:@"charger_voltage"] integerValue];
                model.chargerPilotCurrent = [[data objectForKeyNotNull:@"charger_pilot_current"] integerValue];
                model.chargerActualCurrent = [[data objectForKeyNotNull:@"charger_actual_current"] integerValue];
                model.chargerPower = [[data objectForKeyNotNull:@"charger_power"] integerValue];
                model.timeUntilFullCharge = [NSNumber numberWithDouble:[[data objectForKeyNotNull:@"time_to_full_charge"] doubleValue]];
                model.chargeRate = [[data objectForKeyNotNull:@"charge_rate"] doubleValue];
                model.isChargePortDoorOpen = [[data objectForKeyNotNull:@"charge_port_door_open"] boolValue];
                
                [model notifyUpdated];
                
            }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                
                NSLog(@"Error: %@", error);
            }];
    
    [operation start];
}

- (void) getGuiSettingsModel:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/gui_settings", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            NSDictionary *data = (NSDictionary*) JSON;
            
            GuiSettingsModel* model = [self guiSettingsModel];
            
            model.chargeRateUnits = [data objectForKeyNotNull:@"gui_charge_rate_units"];
            model.distanceUnits = [data objectForKeyNotNull:@"gui_distance_units"];
            model.rangeDisplay = [data objectForKeyNotNull:@"gui_range_display"];
            model.temperatureUnits = [data objectForKeyNotNull:@"gui_temperature_units"];
            model.is24HourTime = [[data objectForKeyNotNull:@"gui_24_hour_time"] boolValue];

            [model notifyUpdated];
            
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            
            NSLog(@"Error: %@", error);
        }];
    
    [operation start];
}

- (void) getDriveStateModel:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/drive_state", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            NSDictionary *data = (NSDictionary*) JSON;
            
            DriveStateModel* model = [self driveStateModel];
            
            model.longitude =[[data objectForKeyNotNull:@"longitude"] floatValue];
            model.latitude =[[data objectForKeyNotNull:@"latitude"] floatValue];
            model.shiftState =[data objectForKeyNotNull:@"shift_state"];
            model.speed = [NSNumber numberWithInteger:[[data objectForKeyNotNull:@"speed"] integerValue]];
            model.heading = [[data objectForKeyNotNull:@"heading"] intValue];
            model.gpsTimestamp = [[data objectForKeyNotNull:@"gps_as_of"] longValue];
            
            [model notifyUpdated];
            
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            
            NSLog(@"Error: %@", error);
        }];
    
    [operation start];
}

- (void) getClimateStateModel:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/climate_state", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                        NSDictionary *data = (NSDictionary*) JSON;
                        
                        ClimateStateModel* model = [self climateStateModel];
                                                                                            
                        model.frontDefroster = [NSNumber numberWithInteger:[[data objectForKeyNotNull:@"is_front_defroster_on"] integerValue]];
                        model.rearDefroster = [NSNumber numberWithInteger:[[data objectForKeyNotNull:@"is_rear_defroster_on"] integerValue]];
                        model.fanSpeed = [NSNumber numberWithInteger:[[data objectForKeyNotNull:@"fan_status"] integerValue]];
                        model.insideTemperature = [[data objectForKeyNotNull:@"inside_temp"] doubleValue];
                        model.outsideTemperature = [[data objectForKeyNotNull:@"outside_temp"] doubleValue];
                        model.driverTemperature = [[data objectForKeyNotNull:@"driver_temp_setting"] doubleValue];
                        model.passengerTemperature = [[data objectForKeyNotNull:@"passenger_temp_setting"] doubleValue];
                        model.isAirConditioningOn = [[data objectForKeyNotNull:@"is_auto_conditioning_on"] boolValue];
                                                
                    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                        
                        NSLog(@"Error: %@", error);
                    }];
    
    [operation start];
}

- (void) getMobileEnabledModel:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/mobile_enabled", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    
                    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                    //NSDictionary *data = (NSDictionary*) JSON;
                    
                }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                    
                    NSLog(@"Error: %@", error);
                }];
    
    [operation start];
}




- (void) openChargePortDoor:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/charge_port_door_open", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

- (void) setChargeLimit:(int)vehicleId withPercent:(int)percent
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/set_charge_limit?percent=%d", vehicleId, percent]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

// DEPRECATED in v4.5
- (void) chargeStandard:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/charge_standard", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

// DEPRECATED in v4.5
- (void) chargeMaxRange:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/charge_max_range", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

- (void) chargeStart:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/charge_start", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

- (void) chargeStop:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/charge_stop", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

- (void) flashLights:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/flash_lights", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

- (void) honkHorn:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/honk_horn", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

- (void) doorUnlock:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/door_unlock", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

- (void) doorLock:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/door_lock", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

- (void) startAirConditioning:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/auto_conditioning_start", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

- (void) stopAirConditioning:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/auto_conditioning_stop", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

//?state={state}
- (void) sunroofControl:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/sunroof_control", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}

//?driver_temp={driver_degC}&passenger_temp={pass_degC}
- (void) setTemperture:(int)vehicleId
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/vehicles/%d/command/set_temps", vehicleId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            //NSDictionary *data = (NSDictionary*) JSON;
                                                                                            
                                                                                        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                                                                            
                                                                                            NSLog(@"Error: %@", error);
                                                                                        }];
    
    [operation start];
}









@end