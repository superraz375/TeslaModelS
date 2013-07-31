//
//  ClimateStateModel.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/21/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "ClimateStateModel.h"
#import "TeslaClient.h"

@implementation ClimateStateModel

- (void) notifyUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ClimateStateNotification object:self];
}

@end
