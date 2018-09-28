//
//  DQServiceReportInfoCell.h
//  WebThings
//  报告Cell
//  Created by Heidi on 2017/10/10.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQServiceReportInfoCell_h
#define DQServiceReportInfoCell_h

@interface DQServiceReportInfoCell : UITableViewCell
{
    UILabel *_lblTitle;
    UIImageView *_icon;
}

- (void)setTitle:(NSString *)title;

@end

#endif /* DQServiceReportInfoCell_h */
