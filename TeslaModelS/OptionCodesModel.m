//
//  OptionCodesModel.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/29/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "OptionCodesModel.h"

@implementation OptionCodesModel

- (id) initWithString:(NSString*)optionCodes
{
    self = [super init];
    if (self) {
        // Initialization code
        [self parseOptionCodes:optionCodes];
    }
    return self;
}

- (void) parseOptionCodes:(NSString*)optionCodes
{
    NSArray* options = [optionCodes componentsSeparatedByString:@","];
    
    for (NSString* option in options) {
        
        if ([option isEqualToString:@"X001"])
        {
            _hasPowerLiftgate = YES;
        }
        else if ([option isEqualToString:@"X002"])
        {
            _hasPowerLiftgate = NO;
        }
        else if ([option isEqualToString:@"X003"])
        {
            _hasNavigation = YES;
        }
        else if ([option isEqualToString:@"X004"])
        {
            _hasNavigation = NO;
        }
        else if ([option isEqualToString:@"X007"])
        {
            _hasPremiumExteriorLighting = YES;
        }
        else if ([option isEqualToString:@"X008"])
        {
            _hasPremiumExteriorLighting = NO;
        }
        else if ([option isEqualToString:@"X011"])
        {
            _hasHomelink = YES;
        }
        else if ([option isEqualToString:@"X012"])
        {
            _hasHomelink = NO;
        }
        else if ([option isEqualToString:@"X013"])
        {
            _hasSatelliteRadio = YES;
        }
        else if ([option isEqualToString:@"X014"])
        {
            _hasSatelliteRadio = NO;
        }
        else if ([option isEqualToString:@"X019"])
        {
            _hasPerformanceExterior = YES;
        }
        else if ([option isEqualToString:@"X020"])
        {
            _hasPerformanceExterior = NO;
        }
        else if ([option isEqualToString:@"X024"])
        {
            _hasPerformancePowertrain = YES;
        }
        else if ([option isEqualToString:@"X025"])
        {
            _hasPerformancePowertrain = NO;
        }
        
        NSString *option2 = [option substringWithRange:NSMakeRange(0, 2)];
        NSString *value2 = [option substringWithRange:NSMakeRange(2, 4)];
        
        if ([option2 isEqualToString:@"MS"])
        {
            _yearModel = [value2 integerValue];
        }
        else if ([option2 isEqualToString:@"RE"])
        {
            if ([value2 isEqualToString:@"NA"])
            {
                _teslaRegion = TeslaRegionUsa;
            }
            else if ([value2 isEqualToString:@"NC"])
            {
                _teslaRegion = TeslaRegionCanada;
            }
        }
        else if ([option2 isEqualToString:@"TM"])
        {
            if ([value2 isEqualToString:@"00"])
            {
                _trimLevel = TrimLevelStandard;
            }
            else if ([value2 isEqualToString:@"01"])
            {
                _trimLevel = TrimLevelPerformance;
            }
            else if ([value2 isEqualToString:@"02"])
            {
                _trimLevel = TrimLevelSignaturePerformance;
            }
        }
        else if ([option2 isEqualToString:@"DR"])
        {
            if ([value2 isEqualToString:@"LH"])
            {
                _driverSide = DriverSideLeftHandDrive;
            }
            else if ([value2 isEqualToString:@"RH"])
            {
                _driverSide = DriverSideRightHandDrive;
            }
        }
        else if ([option2 isEqualToString:@"PF"])
        {
            _isPerformance = [value2 boolValue];
        }
        else if ([option2 isEqualToString:@"BT"])
        {
            _batterySize = [value2 integerValue];
        }
        else if ([option2 isEqualToString:@"RF"])
        {
            if ([value2 isEqualToString:@"BC"])
            {
                _roofType = RoofTypeColored;
            }
            else if ([value2 isEqualToString:@"PO"])
            {
                _roofType = RoofTypeNone;
            }
            else if ([value2 isEqualToString:@"BK"])
            {
                _roofType = RoofTypeBlack;
            }
        }
        else if ([option2 isEqualToString:@"WT"])
        {
            if ([value2 isEqualToString:@"19"])
            {
                _wheelType = WheelTypeBase19;
            }
            else if ([value2 isEqualToString:@"21"])
            {
                _wheelType = WheelTypeSilver21;
            }
            else if ([value2 isEqualToString:@"SP"])
            {
                _wheelType = WheelTypeCharcoal21;
            }
            else if ([value2 isEqualToString:@"SG"])
            {
                _wheelType = WheelTypeCharcoal21Performance;
            }
        }
        else if ([option2 isEqualToString:@"ID"])
        {
            if ([value2 isEqualToString:@"CF"])
            {
                _interiorDecor = InteriorDecorCarbonFiber;
            }
            else if ([value2 isEqualToString:@"LW"])
            {
                _interiorDecor = InteriorDecorLacewood;
            }
            else if ([value2 isEqualToString:@"OM"])
            {
                _interiorDecor = InteriorDecorObecheWoodMatte;
            }
            else if ([value2 isEqualToString:@"OG"])
            {
                _interiorDecor = InteriorDecorObecheWoodGloss;
            }
            else if ([value2 isEqualToString:@"PB"])
            {
                _interiorDecor = InteriorDecorPianoBlack;
            }
        }
        else if ([option2 isEqualToString:@"TR"])
        {
            _hasThirdRowSeating = [value2 boolValue];
        }
        else if ([option2 isEqualToString:@"SU"])
        {
            _hasAirSuspension = [value2 boolValue];
        }
        else if ([option2 isEqualToString:@"SC"])
        {
            _hasSuperCharging = [value2 boolValue];
        }
        else if ([option2 isEqualToString:@"TP"])
        {
            _hasTechPackage = [value2 boolValue];
        }
        else if ([option2 isEqualToString:@"AU"])
        {
            _hasAudioUpgrade = [value2 boolValue];
        }
        else if ([option2 isEqualToString:@"CH"])
        {
            _hasTwinChargers = [value2 boolValue];
        }
        else if ([option2 isEqualToString:@"HP"])
        {
            _hasHPWC = [value2 boolValue];
        }
        else if ([option2 isEqualToString:@"PA"])
        {
            _hasPaintArmor = [value2 boolValue];
        }
        else if ([option2 isEqualToString:@"PS"])
        {
            _hasParcelShelf = [value2 boolValue];
        }
        else if ([option2 isEqualToString:@"AD"])
        {
            // Adapter
            
            // 02 = NEMA 14-50
            
            _adapterType = [value2 integerValue];
        }
        else if ([option2 isEqualToString:@"PX"])
        {
            _isPerformancePlus = [value2 boolValue];
        }
        
        NSString *option3 = [option substringWithRange:NSMakeRange(0, 1)];
        NSString *value3 = [option substringWithRange:NSMakeRange(1, 4)];
        
        if ([option3 isEqualToString:@"P"])
        {
            if ([value3 isEqualToString:@"BSB"])
            {
                _teslaColor = TeslaColorBlack;
            }
            else if ([value3 isEqualToString:@"BCW"])
            {
                _teslaColor = TeslaColorWhite;
            }
            else if ([value3 isEqualToString:@"MSS"])
            {
                _teslaColor = TeslaColorMetallicSilver;
            }
            else if ([value3 isEqualToString:@"MTG"])
            {
                _teslaColor = TeslaColorMetallicDolphinGrey;
            }
            else if ([value3 isEqualToString:@"MAB"])
            {
                _teslaColor = TeslaColorMetallicBrown;
            }
            else if ([value3 isEqualToString:@"MMB"])
            {
                _teslaColor = TeslaColorMetallicBrown;
            }
            else if ([value3 isEqualToString:@"MSG"])
            {
                _teslaColor = TeslaColorMetallicGreen;
            }
            else if ([value3 isEqualToString:@"PSW"])
            {
                _teslaColor = TeslaColorPearlWhite;
            }
            else if ([value3 isEqualToString:@"PMR"])
            {
                _teslaColor = TeslaColorMulticoatRed;
            }
            else if ([value3 isEqualToString:@"PSR"])
            {
                _teslaColor = TeslaColorSignatureRed;
            }
        }
        else if ([option3 isEqualToString:@"I"])
        {
            // Interior Seats
            
            /*
             
             B* - base textile seats
                MB - black
             P* - leather
                MB - black
                MG - gray
                MT - tan
             Z* - performance leather
                MB - black with red piping
                MG - gray with piping
                MT - tan with piping
             S* - signature perforated leather
                ZW - white
                MT - tan
                MB - black

             */
        }
    }
}

@end
