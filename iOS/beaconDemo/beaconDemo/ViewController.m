//
//  ViewController.m
//  beaconDemo
//
//  Created by Nguyenh on 3/11/15.
//  Copyright (c) 2015 Nguyenh. All rights reserved.
//

#import "ViewController.h"
#import "Service.h"

@interface ViewController ()
{
    UIImageView* _img;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shoes.png"]];
    [_img setCenter:self.view.center];
    [_img setHidden:YES];
    [self.view addSubview:_img];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showDetail
{
    [_img setHidden:NO];
    [SERVICE notifyWithData:@{@"major":@"0", @"minor":@"1089"} :^(id response) {
        
    } :^(NSString *error) {
        
    }];
}

@end
