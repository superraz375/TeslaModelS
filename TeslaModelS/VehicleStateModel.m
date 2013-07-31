//
//  TeslaVehicleModel.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/18/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "VehicleStateModel.h"
#import "TeslaClient.h"

@interface VehicleStateModel ()

@end

@implementation VehicleStateModel

- (void) notifyUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:VehicleStateNotification object:self];
}

@end
