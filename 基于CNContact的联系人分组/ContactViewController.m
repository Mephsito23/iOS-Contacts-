//
//  ContactViewController.m
//  基于CNContact的联系人分组
//
//  Created by mac on 17/6/5.
//  Copyright © 2017年 Mephsito. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactCell.h"
#import "GetContactTool.h"
#import "FriendSearchView.h"

#define KSbounds [UIScreen mainScreen].bounds
#define KSwidth [UIScreen mainScreen].bounds.size.width
#define KSheight [UIScreen mainScreen].bounds.size.height

@interface ContactViewController ()<UITableViewDataSource,
                                    UITableViewDelegate,
                                    SearchViewProtocol>

@property (nonatomic, strong)UITableView *tableV;
@property (nonatomic, strong)FriendSearchView *searchV;

@property (nonatomic, strong)GetContactTool *tool;
@property (nonatomic, copy) NSDictionary *contactPeopleDict;
@property (nonatomic, copy) NSArray *keys;

@end

@implementation ContactViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.searchV];
    [self.view addSubview:self.tableV];
    
    [self configureData];
    
}

- (void)configureData{
    self.tool=[GetContactTool new];
    if ([self.tool judgeAuthorization]) [self updataTableView:[self.tool getAllContact]];
}

- (void)updataTableView:(NSDictionary *)dict{
    self.contactPeopleDict=dict[@"contactPeopleDict"];
    self.keys=dict[@"keys"];
    [self.tableV reloadData];
}

#pragma mark  - UITableView 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *key = self.keys[section];
    NSInteger count=[self.contactPeopleDict[key] count];
    return count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.keys[section];
}

//右侧的索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.keys;
}

#pragma mark  - UitableView 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContactCell *cell=[ContactCell dequeneCellWithTableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContactCell *tempCell=(ContactCell *)cell;
    NSString *key = self.keys[indexPath.section];
    ContactModel *people = [self.contactPeopleDict[key] objectAtIndex:indexPath.row];
    tempCell.model=people;
}

#pragma mark  - searchView 代理
- (void)searchViewWithSearchText:(NSString *)serchText{
    
    NSDictionary *dict=[self.tool searchContactWithName:serchText];
    [self updataTableView:dict];
}

- (void)serchViewSearchBarBtnClickWithbar:(UISearchBar *)searchBar{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    NSDictionary *dict=[self.tool searchContactWithName:searchBar.text];
    [self updataTableView:dict];
}

#pragma mark  - getter and setter

- (UITableView *)tableV{
    if (_tableV==nil) {
        
        CGRect frame=CGRectMake(0, 108,KSwidth, KSheight-108);
        _tableV=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableV.delegate=self;
        _tableV.dataSource=self;
        _tableV.rowHeight=60;
        _tableV.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableV;
}

- (FriendSearchView *)searchV{
    if (_searchV==nil) {
        
        CGRect frame=CGRectMake(0, 64, KSwidth, 44);
        _searchV=[[FriendSearchView alloc]initWithFrame:frame];
        _searchV.delegate=self;
    }
    return _searchV;
}


@end
