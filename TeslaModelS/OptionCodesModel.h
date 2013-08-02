//
//  OptionCodesModel.h
//  TeslaModelS
//
//  Created by Raz Friman on 7/29/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionCodesModel : NSObject


typedef enum panoramicRoofStates {
    PanoramicRoofStateOpen,
    PanoramicRoofStateComfort,
    PanoramicRoofStateVent,
    PanoramicRoofStateClose,
    PanoramicRoofStateMove,
    PanoramicRoofStateUnknown,
} PanoramicRoofState;

typedef enum performanceConfigurations{
    PerformanceConfigurationBase,
    PerformanceConfigurationSport,
} PerformanceConfiguration;

typedef enum roofTypes{
    RoofTypeColored,
    RoofTypeNone,
    RoofTypeBlack,
    
} RoofType;

typedef enum teslaRegions {
    TeslaRegionUsa,
    TeslaRegionCanada,
    
} TeslaRegion;

typedef enum trimLevels {
    TrimLevelStandard,
    TrimLevelPerformance,
    TrimLevelSignaturePerformance,
    
} TrimLevel;


typedef enum driverSides {
    DriverSideLeftHandDrive,
    DriverSideRightHandDrive,
    
} DriverSide;


typedef enum teslaColors {
    TeslaColorBlack,
    TeslaColorWhite,
    
    TeslaColorMetallicSilver,
    TeslaColorMetallicDolphinGrey,
    TeslaColorMetallicBrown,
    TeslaColorMetallicBlue,
    TeslaColorMetallicGreen,
    
    TeslaColorPearlWhite,
    TeslaColorMulticoatRed,
    
    TeslaColorSignatureRed,
    
} TeslaColor;


typedef enum wheelTypes {
    WheelTypeBase19,
    WheelTypeSilver21,
    WheelTypeCharcoal21,
    WheelTypeCharcoal21Performance,
    
} WheelType;

typedef enum InteriorDecors {
    InteriorDecorCarbonFiber,
    InteriorDecorLacewood,
    InteriorDecorObecheWoodMatte,
    InteriorDecorObecheWoodGloss,
    InteriorDecorPianoBlack,
    
} InteriorDecor;

@property (nonatomic) RoofType roofType;
@property (nonatomic) TeslaRegion teslaRegion;
@property (nonatomic) TrimLevel trimLevel;
@property (nonatomic) DriverSide driverSide;
@property (nonatomic) TeslaColor teslaColor;
@property (nonatomic) WheelType wheelType;
@property (nonatomic) InteriorDecor interiorDecor;

@property (nonatomic) NSInteger batterySize;
@property (nonatomic) NSInteger yearModel;
@property (nonatomic) NSInteger adapterType;

@property (nonatomic) BOOL isPerformance;
@property (nonatomic) BOOL isPerformancePlus;

@property (nonatomic) BOOL hasPowerLiftgate;
@property (nonatomic) BOOL hasNavigation;
@property (nonatomic) BOOL hasPremiumExteriorLighting;
@property (nonatomic) BOOL hasHomelink;
@property (nonatomic) BOOL hasSatelliteRadio;
@property (nonatomic) BOOL hasPerformanceExterior;
@property (nonatomic) BOOL hasPerformancePowertrain;
@property (nonatomic) BOOL hasThirdRowSeating;
@property (nonatomic) BOOL hasAirSuspension;
@property (nonatomic) BOOL hasSuperCharging;
@property (nonatomic) BOOL hasTechPackage;
@property (nonatomic) BOOL hasAudioUpgrade;
@property (nonatomic) BOOL hasTwinChargers;
@property (nonatomic) BOOL hasHPWC;
@property (nonatomic) BOOL hasPaintArmor;
@property (nonatomic) BOOL hasParcelShelf;
@property (nonatomic) BOOL hasParkingSensors;
@property (nonatomic) BOOL hasColdWeatherPackage;
@property (nonatomic) BOOL hasBlindSpotDetection;
//@property (nonatomic) BOOL hasSecurityProtection; //SP00
//YF00
//X009
//X027
//X031

- (id) initWithString:(NSString*)optionCodes;



@end
