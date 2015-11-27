//
//  ViewController.m
//  ProtocolKitDemo
//
//  Created by su xinde on 15/11/18.
//  Copyright © 2015年 com.su. All rights reserved.
//

#import "ViewController.h"

#import "Forkable.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ForkableConcrete *o = [ForkableConcrete new];
    [o fork];
}

@end
