//
//  GetContactTool.h
//  基于CNContact的联系人分组
//
//  Created by mac on 17/6/5.
//  Copyright © 2017年 Mephsito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GetContactTool : NSObject


/**
 根据颜色返回图片
 @param color 输入的颜色
 @return  返回的图片
 */
+(UIImage *) createImageWithColor:(UIColor *)color;

/**
 判断手机通讯录权限是否开启
 @return @YES 开启 @NO 未开启
 */
- (BOOL)judgeAuthorization;

/**
  获取所有的联系人(已转换为ContactModel)

 @return 返回@{@"contactPeopleDict":addressBookDict,
                           @"keys":nameKeys};字典
 */
- (NSDictionary *)getAllContact;


/**
 根据输入名字查询联系人

 @param name 要查询的名字
 获取所有的联系人(已转换为ContactModel)
 
 @return 返回@{@"contactPeopleDict":addressBookDict,
                           @"keys":nameKeys};字典
*/

-(NSDictionary *)searchContactWithName:(NSString *)name;

@end
