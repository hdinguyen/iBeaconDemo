//
//  Service.m
//  Ticket Inspection
//
//  Created by Nguyenh on 1/5/15.
//  Copyright (c) 2015 Nguyenh. All rights reserved.
//

#import "Service.h"

@implementation Service

+(id)shareService
{
    static Service *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init
{
    self = [super init];
    _userDefault = [NSUserDefaults standardUserDefaults];
    self.phoneNumber = [_userDefault objectForKey:@"PHONE"];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    return self;
}

-(void)callPostAPIWithURL:(NSString *)url params:(NSDictionary*)param callback:(void (^)(id response))completion failure:(void (^)(NSString* error))failure{
    NSLog(@"%@", param);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

-(void)sendGetRequestWithURL:(NSString*)url param:(NSDictionary*)param :(void (^)(id response))complete :(void(^)(NSString* error))fail
{
    BOOL firstParam = YES;
    NSMutableString* str = [NSMutableString stringWithString:url];
    
    for (NSString* i in param)
    {
        if (!firstParam) //is second param
        {
            [str appendFormat:@"&%@=%@",i,[param objectForKey:i]];
        }
        else //is first param
        {
            [str appendFormat:@"?%@=%@",i,[param objectForKey:i]];
            firstParam = NO;
        }
    }
    
    NSLog(@"URL CALLED: %@", str);
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
            fail(connectionError.description);
        else
        {
            NSError* err;
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if (err)
            {
                NSString* str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                complete(str);
            }
            else
                complete(dict);
        }
    }];
}

-(void)checkAppExpire:(void (^)(id))complete :(void (^)(NSString *))fail
{
    [self sendGetRequestWithURL:@"https://bitbucket.org/hdinguyen/apppermission/raw/master/command" param:nil :^(NSDictionary *response) {
        NSString* str = [response objectForKey:@"br"];
        complete(str);
    } :^(NSString *error) {
        fail(error);
    }];
}

-(void)sendNotifyWithData:(NSString*)name
{
    [self sendGetRequestWithURL:@"http://10.0.1.9/loyalty" param:@{@"name":name} :^(NSDictionary *response) {
        NSLog(@"%@", response);
    } :^(NSString *error) {
        NSLog(@"%@", error);
    }];
}

-(BOOL)shouldSentPushWithActionID:(NSNumber*)actionID
{
    NSString* pushKey = [NSString stringWithFormat:@"PUSH_%@",actionID.stringValue];
    if ([[_userDefault objectForKey:pushKey] isEqualToString:@"Y"])
    {
        return NO;
    }
    [_userDefault setObject:@"Y" forKey:pushKey];
    [_userDefault synchronize];
    return YES;
}

-(BOOL)shouldShowSurveyWithActionID:(NSNumber*)actionID
{
    NSString* surveyKey = [NSString stringWithFormat:@"SURVEY_%@", actionID.stringValue];
    if ([[_userDefault objectForKey:surveyKey] isEqualToString:@"Y"])
        return NO;
    [_userDefault setObject:@"Y" forKey:surveyKey];
    [_userDefault synchronize];
    return YES;
}

-(void)notifyWithData:(NSDictionary*)data :(void (^)(id response))complete :(void(^)(NSString* error))fail
{
    [self callPostAPIWithURL:[NSString stringWithFormat:@"%@/user/detect", MAIN_URL] params:data callback:^(id response) {
        
    } failure:^(NSString *error) {
        
    }];
}

-(void)checkPhoneNumberWithData:(NSDictionary*)dict :(void (^)(id response))complete :(void(^)(NSString* error))fail
{
    [self callPostAPIWithURL:@"" params:dict callback:^(id response) {
        complete(response);
    } failure:^(NSString *error) {
        complete(error);
    }];
}

@end
