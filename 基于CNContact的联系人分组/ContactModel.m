//
//  ContactModel.m
//  基于CNContact的联系人分组
//
//  Created by mac on 17/6/5.
//  Copyright © 2017年 Mephsito. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

- (NSMutableArray *)mobileArray
{
    if(!_mobileArray)
    {
        _mobileArray = [NSMutableArray array];
    }
    return _mobileArray;
}

@end
