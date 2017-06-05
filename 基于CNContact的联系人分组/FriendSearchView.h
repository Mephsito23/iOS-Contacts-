//
//  FriendSearchView.h
//  BlankProject
//
//  Created by mac on 17/5/25.
//  Copyright © 2017年 Mephsito. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewProtocol <NSObject>

@optional

/**
  搜索框文字改变
 @param serchText 返回改变的文字
 */
- (void)searchViewWithSearchText:(NSString *)serchText;

/**
 键盘上搜索按钮被点击
 @param searchBar 返回搜索框
 */
- (void)serchViewSearchBarBtnClickWithbar:(UISearchBar *)searchBar;

@end

@interface FriendSearchView : UIView

@property(nonatomic,weak)id<SearchViewProtocol>delegate;

@end
