//
//  DQKeyValueTitleCell.h
//  WebThings
//
//  Created by 孙文强 on 2017/9/20.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQKeyValueTitleCell : UITableViewCell
@property (nonatomic, strong) NSString *keyTitle;
@property (nonatomic, strong) NSString *valueTitle;

- (void)configKey:(NSString *)key value:(NSString *)value;
@end
