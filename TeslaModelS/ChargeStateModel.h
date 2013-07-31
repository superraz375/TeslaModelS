//
//  ChargeStateModel.h
//  TeslaModelS
//
//  Created by Raz Friman on 7/18/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargeStateModel : NSObject

@property (nonatomic, strong) NSString* chargingState;
@property (nonatomic) NSInteger chargeLimitSoc;
@property (nonatomic) NSInteger chargeLimitSocMax;
@property (nonatomic) NSInteger chargeLimitSocMin;
@property (nonatomic) NSInteger chargeLimitSocStd;
@property (nonatomic) BOOL isChargeToMaxRange;
@property (nonatomic) BOOL isBatteryHeaterOn;
@property (nonatomic) BOOL isNotEnoughPowerToHeat;
@property (nonatomic) NSInteger maxRangeChargeCounter;
@property (nonatomic) BOOL isUsingSupercharger;
@property (nonatomic) double batteryRange;
@property (nonatomic) double estimatedBatteryRange;
@property (nonatomic) double idealBatteryRange;
@property (nonatomic) NSInteger batteryLevel;
@property (nonatomic) double batteryCurrent;
@property (nonatomic, strong) NSNumber* chargeStartingRange;
@property (nonatomic, strong) NSNumber* chargeStartingSoc;
@property (nonatomic) NSInteger chargerVoltage;
@property (nonatomic) NSInteger chargerPilotCurrent;
@property (nonatomic) NSInteger chargerActualCurrent;
@property (nonatomic) NSInteger chargerPower;
@property (nonatomic, strong) NSNumber* timeUntilFullCharge;
@property (nonatomic) double chargeRate;
@property (nonatomic) BOOL isChargePortDoorOpen;
@property (nonatomic, strong) NSDate* scheduledChargingStartTime;
@property (nonatomic) BOOL scheduledChargingPending;
@property (nonatomic) BOOL isUserChargeEnableRequest; // CHECK FOR NSNUMBER* IF NULL
@property (nonatomic) BOOL isChargeEnableRequest;

- (void) notifyUpdated;

@end

/*
 charging_state=Charging
 charge_limit_soc=90
 charge_limit_soc_std=90
 charge_limit_soc_min=50
 charge_limit_soc_max=100
 charge_to_max_range=false
 battery_heater_on=false
 not_enough_power_to_heat=false
 max_range_charge_counter=0
 
 fast_charger_present=true
 battery_range=138.69
 est_battery_range=159.64
 ideal_battery_range=159.62
 battery_level=59
 battery_current=137.0
 charge_starting_range=null
 charge_starting_soc=null
 charger_voltage=377
 charger_pilot_current=0
 charger_actual_current=0
 charger_power=-52
 time_to_full_charge=0.52
 charge_rate=257.6
 charge_port_door_open=true
 scheduled_charging_start_time=null
 scheduled_charging_pending=false
 user_charge_enable_request=null
 charge_enable_request=true
 */

/*
 {
 "charging_state": "Complete",  // "Charging", ??
 "charge_to_max_range": false,  // current std/max-range setting
 "max_range_charge_counter": 0,
 "fast_charger_present": false, // connected to Supercharger?
 "battery_range": 239.02,       // rated miles
 "est_battery_range": 155.79,   // range estimated from recent driving
 "ideal_battery_range": 275.09, // ideal miles
 "battery_level": 91,           // integer charge percentage
 "battery_current": -0.6,       // current flowing into battery
 "charge_starting_range": null,
 "charge_starting_soc": null,
 "charger_voltage": 0,          // only has value while charging
 "charger_pilot_current": 40,   // max current allowed by charger & adapter
 "charger_actual_current": 0,   // current actually being drawn
 "charger_power": 0,            // kW (rounded down) of charger
 "time_to_full_charge": null,   // valid only while charging
 "charge_rate": -1.0,           // float mi/hr charging or -1 if not charging
 "charge_port_door_open": true
 }
*/