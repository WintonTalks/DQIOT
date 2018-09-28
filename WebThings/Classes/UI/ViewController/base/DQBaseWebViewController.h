//
//  DQBaseWebViewController.h
//  WebThings
//
//  Created by Heidi on 2017/9/22.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#ifndef DQBaseWebViewController_h
#define DQBaseWebViewController_h

#import "EMIBaseViewController.h"

@interface DQBaseWebViewController : EMIBaseViewController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *navTitle;

@end

#endif /* DQBaseWebViewController_h */
