//
//  DQCommunicateFormViewCell.h
//  WebThings
//
//  Created by Eugene on 10/8/17.
//  Copyright © 2017 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQCommunicateFormViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isDirctionLeft;

- (void)setData:(NSDictionary *)dict;
 
@end
