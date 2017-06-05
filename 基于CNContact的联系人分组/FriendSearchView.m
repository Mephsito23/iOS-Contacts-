//
//  FriendSearchView.m
//  BlankProject
//
//  Created by mac on 17/5/25.
//  Copyright © 2017年 Mephsito. All rights reserved.
//

#import "FriendSearchView.h"
#import "GetContactTool.h"

@interface FriendSearchView()<UISearchBarDelegate>

@end

@implementation FriendSearchView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
        
        [self configureSubView];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    UISearchBar*bar=[self viewWithTag:111];
    bar.frame=self.bounds;
    
}

- (void)configureSubView{
    
    self.backgroundColor=[UIColor whiteColor];
    
    UIImage*searchImage=[GetContactTool createImageWithColor:[UIColor lightGrayColor]];
    
    UISearchBar*bar=[UISearchBar new];
    bar.delegate=self;
    //设置背景色
    [bar setBackgroundImage:searchImage];
    bar.backgroundColor=[UIColor whiteColor];
    bar.barTintColor=[UIColor whiteColor];
    
    
    UITextField *searchField=[bar valueForKey:@"_searchField"];
    searchField.backgroundColor=[UIColor whiteColor];
    [searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    bar.tag=111;
    [self addSubview:bar];
    bar.placeholder=@"搜索";
    [self addSubview:bar];
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    if ([self.delegate respondsToSelector:@selector(searchViewWithSearchText:)]) {
        [self.delegate searchViewWithSearchText:theTextField.text];
    }
}


#pragma mark  -UITextField 代理


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
     if ([self.delegate
          respondsToSelector:@selector(serchViewSearchBarBtnClickWithbar:)]) {
         [self.delegate serchViewSearchBarBtnClickWithbar:searchBar];
     }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if ([self.delegate respondsToSelector:@selector(searchViewWithSearchText:)]) {
        [self.delegate searchViewWithSearchText:searchBar.text];
    }
    
}




@end
