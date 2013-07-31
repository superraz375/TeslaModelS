//
//  GuiSettingsModel.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/21/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "GuiSettingsModel.h"
#import "TeslaClient.h"

@implementation GuiSettingsModel

- (void) notifyUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GuiSettingsNotification object:self];
}

@end
