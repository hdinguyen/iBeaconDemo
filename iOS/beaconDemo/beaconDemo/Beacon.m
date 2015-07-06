//
//  Beacon.m
//  Groupon
//
//  Created by Nguyenh on 12/12/14.
//  Copyright (c) 2014 Nguyenh. All rights reserved.
//

#import "Beacon.h"
#import "Service.h"

//static NSString * const kUUID = @"98e47e2e-26c8-46e5-acdc-5d3a207e9ec5";
static NSString * const kUUID = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
static NSString * const kIdentifier = @"com.nguyenh.beaconDemo";

@interface Beacon ()

@property (nonatomic, strong) NSArray *detectedBeacons;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRangingRegion;
@property (nonatomic, strong) CLBeaconRegion *beaconMonitoringRegion;
@property (weak, nonatomic) IBOutlet UILabel *state;

@end

@implementation Beacon

- (void)createLocationManager
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
}

-(void)createBeaconRegionWithType:(BEACON_REGION_TYPE)type
{
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:kUUID];
    if (type == BEACON_MONITORING)
    {
        if (self.beaconMonitoringRegion)
            return;
        self.beaconMonitoringRegion = [[CLBeaconRegion alloc]initWithProximityUUID:proximityUUID identifier:kIdentifier];
        [self.beaconMonitoringRegion setNotifyEntryStateOnDisplay:YES];
    }
    else
    {
        if (self.beaconRangingRegion)
            return;
        self.beaconRangingRegion = [[CLBeaconRegion alloc]initWithProximityUUID:proximityUUID identifier:kIdentifier];
        [self.beaconRangingRegion setNotifyEntryStateOnDisplay:YES];
    }
}

-(void)startRanging
{
    [self createLocationManager];
    [self checkLocationAccessForMonitoring];
    [self turnOnRanging];
}

-(void)stopRanging
{
    NSLog(@"Stop ranging");
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRangingRegion];
}

-(void)startMonitoring
{
    [self createLocationManager];
    [self checkLocationAccessForMonitoring];
    [self turnOnMonitoring];
}
- (void)turnOnMonitoring
{
    NSLog(@"Turning on monitoring...");
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        NSLog(@"Couldn't turn on region monitoring: Region monitoring is not available for CLBeaconRegion class.");
        return;
    }
    [self createBeaconRegionWithType:BEACON_MONITORING];
    [self.locationManager startMonitoringForRegion:self.beaconMonitoringRegion];
}

-(void)stopMonitoring
{
    [self.locationManager stopMonitoringForRegion:self.beaconMonitoringRegion];
}

- (void)turnOnRanging
{
    if (![CLLocationManager isRangingAvailable]) {
        NSLog(@"Couldn't turn on ranging: Ranging is not available.");
        return;
    }
    if (self.locationManager.rangedRegions.count > 0) {
        NSLog(@"Didn't turn on ranging: Ranging already on.");
        return;
    }
    
    [self createBeaconRegionWithType:BEACON_RANGING];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRangingRegion];
    
    NSLog(@"Ranging turned on for region: %@.", self.beaconRangingRegion);
}



- (void)checkLocationAccessForRanging {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Couldn't turn on ranging: Location services are not enabled.");
        return;
    }
    
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    switch (authorizationStatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Always");
            return;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"When Use");
            return;
            
        default:
            NSLog(@"Couldn't turn on");
            break;
    }
}

- (NSArray *)filteredBeacons:(NSArray *)beacons
{
    // Filters duplicate beacons out; this may happen temporarily if the originating device changes its Bluetooth id
    NSMutableArray *mutableBeacons = [beacons mutableCopy];
    
    NSMutableSet *lookup = [[NSMutableSet alloc] init];
    for (int index = 0; index < [beacons count]; index++) {
        CLBeacon *curr = [beacons objectAtIndex:index];
        NSString *identifier = [NSString stringWithFormat:@"%@/%@", curr.major, curr.minor];
        
        // this is very fast constant time lookup in a hash table
        if ([lookup containsObject:identifier]) {
            [mutableBeacons removeObjectAtIndex:index];
        } else {
            [lookup addObject:identifier];
        }
    }
    
    return [mutableBeacons copy];
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    NSArray *filteredBeacons = [self filteredBeacons:beacons];
    if (filteredBeacons.count == 0) {
        [_state setText:@"Lost Signal"];
        NSLog(@"No beacons found nearby.");
    } else {
        switch ([[filteredBeacons objectAtIndex:0] proximity]) {
            case CLProximityNear:
                NSLog(@"Near");
                [_state setText:@"Near"];
                break;
                
            case CLProximityImmediate:
                NSLog(@"Immediate");
                [_state setText:@"Immediate"];
                break;
                
            case CLProximityFar:
                NSLog(@"Far");
                [_state setText:@"Far"];
                break;
                
            default:
                [_state setText:@"Unknown"];
                break;
        }
        NSLog(@"Found %lu %@.", (unsigned long)[filteredBeacons count],
              [filteredBeacons count] > 1 ? @"beacons" : @"beacon");
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Entered region: %@", region);
}

- (void)sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region
{
    UILocalNotification *notification = [UILocalNotification new];
    // Notification details
    notification.alertBody = @"Keep calm and we have a big sale here!";
    notification.alertAction = NSLocalizedString(@"View Details", nil);
    notification.soundName = UILocalNotificationDefaultSoundName;

    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//    [SERVICE logWithData:nil :^(NSDictionary *response) {
//        NSLog(@"Wrote");
//    } :^(NSString *error) {
//        NSLog(@"Service Error");
//    }];
}

-(void)sayGoodbye
{
    UILocalNotification *notification = [UILocalNotification new];
    // Notification details
    notification.alertBody = @"Goodbye and see ya!";
    notification.alertAction = @"GOODBYE";
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//    [SERVICE logWithData:nil :^(NSDictionary *response) {
//        NSLog(@"Wrote");
//    } :^(NSString *error) {
//        NSLog(@"Service Error");
//    }];
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exited region: %@", region);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSString *stateString = nil;
    switch (state) {
        case CLRegionStateInside:
        {
            stateString = @"inside";
            [self sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region];
            break;
        }
        case CLRegionStateOutside:
            [self sayGoodbye];
            stateString = @"outside";
            break;
        case CLRegionStateUnknown:
            [_state setText:@"Unknown"];
            stateString = @"unknown";
            break;
    }
    
    NSLog(@"State changed to %@ for region %@.", stateString, region);
}


- (void)checkLocationAccessForMonitoring {
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        if (authorizationStatus == kCLAuthorizationStatusDenied ||
            authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Missing"
                                                            message:@"Required Location Access(Always) missing. Click Settings to update Location Access."
                                                           delegate:self
                                                  cancelButtonTitle:@"Settings"
                                                  otherButtonTitles:@"Cancel", nil];
            [alert show];
            return;
        }
        [self.locationManager requestAlwaysAuthorization];
    }
}



@end
