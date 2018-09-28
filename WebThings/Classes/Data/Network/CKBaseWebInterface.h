//
//  CKBaseWebInterface.h
//  WebThings
//
//  Created by machinsight on 2017/7/11.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKBaseWebInterface : NSObject
@property(nonatomic,strong)NSString *fullUrl;
- (id)inBox:(id)param;
- (id)unBox:(id)param;

@end
