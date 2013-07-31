//
//  DriveStateModel.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/21/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "DriveStateModel.h"
#import "TeslaClient.h"

@implementation DriveStateModel

- (void) notifyUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DriveStateNotification object:self];
}

@end
