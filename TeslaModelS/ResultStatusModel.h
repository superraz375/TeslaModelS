//
//  ResultStatusModel.h
//  TeslaModelS
//
//  Created by Raz Friman on 7/23/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultStatusModel : NSObject

@property (nonatomic) BOOL result;
@property (nonatomic, strong) NSString* reason;

@end

/*
 {
 "result": false,
 "reason": "failure reason"
 }
*/