//
//  ContactCell.m
//  基于CNContact的联系人分组
//
//  Created by mac on 17/6/5.
//  Copyright © 2017年 Mephsito. All rights reserved.
//

#import "ContactCell.h"
#import "UIViewExt.h"

@interface ContactCell()

@property (nonatomic, strong)UILabel *nameL;
@property (nonatomic, strong)UIImageView *iconV;
@property (nonatomic, strong)UILabel *phoneL;

@end

@implementation ContactCell

static const CGFloat XZSpace = 15;

+ (ContactCell*)dequeneCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID=@"ContactCell";
    ContactCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[ContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor whiteColor];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubView];
    }
    return self;
}


- (void)creatSubView{
    
    self.model=[ContactModel new];
    [self.contentView addSubview:self.iconV];
    [self.contentView addSubview:self.nameL];
    [self.contentView addSubview:self.phoneL];
    
    [self layPageSubViews];
    
}

- (void)layPageSubViews{
    
    self.iconV.size=CGSizeMake(45, 45);
    self.iconV.left=XZSpace;
    self.iconV.centerY=self.contentView.height*0.5f;
    
    self.nameL.left=self.iconV.right+XZSpace;
    self.nameL.height=20;
    self.nameL.top=self.iconV.top;
    self.nameL.width=self.contentView.right-self.nameL.left-XZSpace;
    
    self.phoneL.left=self.nameL.left;
    self.phoneL.width=self.nameL.width;
    self.phoneL.height=self.nameL.height;
    self.phoneL.bottom=self.iconV.bottom;
    
}

#pragma mark  - getter and setter

- (void)setModel:(ContactModel *)model{
    _model=model;
    
    self.iconV.image=model.headerImage;
    self.nameL.text=model.name;
    self.phoneL.text=model.mobileArray.lastObject;
}

- (UIImageView *)iconV{
    if (_iconV==nil) {
        _iconV=[UIImageView new];
        _iconV.backgroundColor=[UIColor grayColor];
        _iconV.contentMode=UIViewContentModeScaleAspectFill;
        _iconV.layer.cornerRadius=5;
        _iconV.layer.masksToBounds=YES;
    }
    return _iconV;
}

- (UILabel *)nameL{
    if (_nameL==nil) {
        _nameL=[UILabel new];
        _nameL.text=@"asdf";
        _nameL.textColor=[UIColor blackColor];
        _nameL.font=[UIFont systemFontOfSize:14];
    }
    return _nameL;
}

- (UILabel *)phoneL{
    if (_phoneL==nil) {
        _phoneL=[UILabel new];
        _phoneL.text=@"123456788";
        _phoneL.textColor=[UIColor grayColor];
        _phoneL.font=[UIFont systemFontOfSize:14];
    }
    return _phoneL;
}


@end
