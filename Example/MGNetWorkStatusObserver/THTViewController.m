//
//  THTViewController.m
//  MGNetWorkStatusObserver
//
//  Created by 1096462733@qq.com on 10/11/2017.
//  Copyright (c) 2017 1096462733@qq.com. All rights reserved.
//

#import "THTViewController.h"
#import <MGNetWorkStatusObserver/MGNetworkStatusObserver.h>

@interface THTViewController ()

@end

@implementation THTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"当前的网络状态:%@" , [MGNetworkStatusObserver currentNetWorkStatusString]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
