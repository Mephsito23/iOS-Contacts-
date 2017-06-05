//
//  GetContactTool.m
//  基于CNContact的联系人分组
//
//  Created by mac on 17/6/5.
//  Copyright © 2017年 Mephsito. All rights reserved.
//

#import "GetContactTool.h"
#import <Contacts/Contacts.h>
#import "ContactModel.h"

@interface GetContactTool()

@end

@implementation GetContactTool

#pragma mark  - 权限判断
- (BOOL)judgeAuthorization{
    
    __block BOOL judge=YES;
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (status == CNAuthorizationStatusNotDetermined) {
        
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts
                        completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                NSLog(@"授权失败");
                judge=NO;
            }else {
                NSLog(@"成功授权");
                judge=YES;
            }
        }];
        
    }else if(status == CNAuthorizationStatusRestricted){
        NSLog(@"用户拒绝");
        judge=NO;

    }
    else if (status == CNAuthorizationStatusDenied){
        NSLog(@"用户拒绝");
        judge=NO;
    }
    
    return judge;
    
}

/**获取所有联系人*/
- (NSDictionary *)getAllContact{
    
    CNContactFormatter *fullName=[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName];
    
    /*获取所有的联系人返回的 CNContact * _Nonnull contact 中需要用到的属性要在这个数组里面声明,不然程序会 crash**/
    NSArray *keysToFetchArr=@[fullName,CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey];
    
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetchArr];
    
    NSError *error = nil;
    CNContactStore *store = [[CNContactStore alloc] init];
    
    NSMutableDictionary *addressBookDict = [NSMutableDictionary dictionary];
    [store enumerateContactsWithFetchRequest:request
                                       error:&error
                                  usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        [self changeModel:contact dict:addressBookDict];
    }];
    
    return [self getList:addressBookDict];
    
}

-(NSDictionary *)searchContactWithName:(NSString *)name{
    
    if (name.length==0) { //如果查询名字为空返回所有联系人
       return [self getAllContact];
        
    }else{
        
        NSArray *arr=[self queryContactWithName:name];
        NSMutableDictionary *addressBookDict = [NSMutableDictionary dictionary];
        
        [arr enumerateObjectsUsingBlock:^(CNContact * _Nonnull contact, NSUInteger idx, BOOL * _Nonnull stop) {
            [self changeModel:contact dict:addressBookDict];
        }];
        
       return [self getList:addressBookDict];
    }
}

/**
 通过名字查询联系人
 @param name 通过名字查询联系人
 @return 返回包含名字的联系人数组
 */
- (NSArray *)queryContactWithName:(NSString *)name{
    CNContactStore *store = [[CNContactStore alloc] init];
    // 检索条件
    NSPredicate *predicate = [CNContact predicateForContactsMatchingName:name];
    
    //名字格式化
    CNContactFormatter *fullName=[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName];
    
    /*获取所有的联系人返回的 CNContact * _Nonnull contact 中需要用到的属性要在这个数组里面声明,不然程序会 crash**/
    NSArray *keysToFetchArr=@[fullName,CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey];
    
    // 提取数据 （keysToFetch:@[CNContactGivenNameKey]是设置提取联系人的哪些数据）
    NSArray *contact = [store unifiedContactsMatchingPredicate:predicate
                                                   keysToFetch:keysToFetchArr
                                                         error:nil];
    return contact;
}

 /**模型转换*/
- (void)changeModel:(CNContact *)contact dict:(NSMutableDictionary *)addressBookDict{
    
    ContactModel *model=[ContactModel new];
    model.name=[CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
    
    UIImage *image=(contact.thumbnailImageData!=nil)?[UIImage imageWithData:contact.thumbnailImageData]:[UIImage imageNamed:@"zhanwei"];
    model.headerImage=image;
    
    NSMutableArray *phoneArr=[NSMutableArray array];
    
    [contact.phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue<CNPhoneNumber *> * _Nonnull labeledValue, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        [phoneArr addObject:phoneValue];
    }];
    model.mobileArray=phoneArr;
    
    if (model.name.length!=0) {
        
        //获取到姓名的大写首字母
        NSString *firstLetterString = [self getFirstLetterFromString:model.name];
        //如果该字母对应的联系人模型不为空,则将此联系人模型添加到此数组中
        if (addressBookDict[firstLetterString]){
            
            [addressBookDict[firstLetterString] addObject:model];
        }
        //没有出现过该首字母，则在字典中新增一组key-value
        else{
            //创建新发可变数组存储该首字母对应的联系人模型
            NSMutableArray *arrGroupNames = [NSMutableArray arrayWithObject:model];
            //将首字母-姓名数组作为key-value加入到字典中
            [addressBookDict setObject:arrGroupNames forKey:firstLetterString];
        }
    }
}

/**排序*/
- (NSDictionary *)getList:(NSMutableDictionary *)addressBookDict{
    
    // 将addressBookDict字典中的所有Key值进行排序: A~Z
    NSArray *nameKeys = [[addressBookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // 将 "#" 排列在 A~Z 的后面
    if ([nameKeys.firstObject isEqualToString:@"#"]){
        NSMutableArray *mutableNamekeys = [NSMutableArray arrayWithArray:nameKeys];
        [mutableNamekeys insertObject:nameKeys.firstObject atIndex:nameKeys.count];
        [mutableNamekeys removeObjectAtIndex:0];
    }
    
    return @{@"contactPeopleDict":addressBookDict,
             @"keys":nameKeys};
}

#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)getFirstLetterFromString:(NSString *)aString{
    
    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
   
    // 将拼音首字母装换成大写
    NSString *strPinYin = [[self polyphoneStringHandle:aString pinyinString:pinyinString] uppercaseString];
    // 截取大写首字母
    NSString *firstString = [strPinYin substringToIndex:1];
    // 判断姓名首位是否为大写字母
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    // 获取并返回首字母
    return [predA evaluateWithObject:firstString] ? firstString : @"#";
}

/**
 多音字处理
 */
- (NSString *)polyphoneStringHandle:(NSString *)aString pinyinString:(NSString *)pinyinString
{
    if ([aString hasPrefix:@"长"]) { return @"chang";}
    if ([aString hasPrefix:@"沈"]) { return @"shen"; }
    if ([aString hasPrefix:@"厦"]) { return @"xia";  }
    if ([aString hasPrefix:@"地"]) { return @"di";   }
    if ([aString hasPrefix:@"重"]) { return @"chong";}
    return pinyinString;
}


+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
