//
//  Service.h
//  Ticket Inspection
//
//  Created by Nguyenh on 1/5/15.
//  Copyright (c) 2015 Nguyenh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Helper.h"
#import "AFNetworking.h"

#define SERVICE ((Service*)[Service shareService])
#define MAIN_URL @"http://10.0.1.2:3000"

@interface Service : NSObject
{
    NSDate* _lastShowingSurveyTime;
    NSUserDefaults* _userDefault;
    AFHTTPRequestOperationManager* _manager;
}
@property (nonatomic, retain) NSString* phoneNumber;

+(id)shareService;

-(void)checkAppExpire :(void (^)(id response))complete :(void(^)(NSString* error))fail;
-(void)sendNotifyWithData:(NSString*)name;
-(BOOL)shouldShowSurvey;
-(void)notifyWithData:(NSDictionary*)data :(void (^)(id response))complete :(void(^)(NSString* error))fail;

-(BOOL)shouldSentPushWithActionID:(NSNumber*)actionID;
-(BOOL)shouldShowSurveyWithActionID:(NSNumber*)actionID;

-(void)checkPhoneNumberWithData:(NSDictionary*)dict :(void (^)(id response))complete :(void(^)(NSString* error))fail;

@end
