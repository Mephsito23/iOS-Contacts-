//
//  ViewController.m
//  基于CNContact的联系人分组
//
//  Created by mac on 17/6/5.
//  Copyright © 2017年 Mephsito. All rights reserved.
//

#import "ViewController.h"
#import "ContactViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(50, 100, 100, 50)];
    [btn setTitle:@"联系人" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnCLick:(UIButton *)btn{
    
    ContactViewController *vc=[[ContactViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
