//
//  AppDelegate.h
//  beaconDemo
//
//  Created by Nguyenh on 3/11/15.
//  Copyright (c) 2015 Nguyenh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beacon.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Beacon* b;
}
@property (strong, nonatomic) UIWindow *window;


@end

