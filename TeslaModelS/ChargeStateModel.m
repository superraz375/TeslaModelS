//
//  ChargeStateModel.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/18/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "ChargeStateModel.h"
#import "TeslaClient.h"

@implementation ChargeStateModel

- (void) notifyUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ChargeStateNotification object:self];
}

@end
