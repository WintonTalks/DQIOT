//
//  DQServiceInfoCell.h
//  WebThings
//
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceInfoCell_h
#define DQServiceInfoCell_h

@interface DQServiceInfoCell : UITableViewCell
{
    UILabel *_lblTitle;
    UILabel *_lblDetail;
}

- (void)setData:(NSDictionary *)dict;

@end

#endif /* DQServiceInfoCell_h */
