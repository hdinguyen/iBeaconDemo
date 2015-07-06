//
//  Beacon.h
//  Groupon
//
//  Created by Nguyenh on 12/12/14.
//  Copyright (c) 2014 Nguyenh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
//#import "Service.h"

typedef enum{
    BEACON_RANGING = 0,
    BEACON_MONITORING
}BEACON_REGION_TYPE;

@interface Beacon : NSObject<CLLocationManagerDelegate>

-(void)startRanging;
-(void)stopRanging;
-(void)startMonitoring;
-(void)stopMonitoring;

@end
