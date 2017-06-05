//
//  ContactCell.h
//  基于CNContact的联系人分组
//
//  Created by mac on 17/6/5.
//  Copyright © 2017年 Mephsito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

@interface ContactCell : UITableViewCell

@property (nonatomic, strong)ContactModel *model;

+(ContactCell*)dequeneCellWithTableView:(UITableView*)tableView;

@end
