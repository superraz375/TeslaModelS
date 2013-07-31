//
//  GuiSettingsModel.h
//  TeslaModelS
//
//  Created by Raz Friman on 7/21/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuiSettingsModel : NSObject

@property (nonatomic, strong) NSString* distanceUnits;
@property (nonatomic, strong) NSString* temperatureUnits;
@property (nonatomic, strong) NSString* chargeRateUnits;
@property (nonatomic, strong) NSString* rangeDisplay;
@property (nonatomic) BOOL is24HourTime;

- (void) notifyUpdated;

@end

/*
 {
 "gui_distance_units": "mi/hr",
 "gui_temperature_units": "F",
 "gui_charge_rate_units": "mi/hr",
 "gui_24_hour_time": false,
 "gui_range_display": "Rated"
 }
*/