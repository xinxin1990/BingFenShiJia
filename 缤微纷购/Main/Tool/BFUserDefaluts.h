//
//  BFUserDefaluts.h
//  缤微纷购
//
//  Created by 程召华 on 16/3/8.
//  Copyright © 2016年 xinxincao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFUserInfo.h"
@interface BFUserDefaluts : NSObject
/**获取user信息*/
+ (BFUserInfo *)getUserInfo;
/**修改user信息*/
+ (void)modifyUserInfo:(BFUserInfo *)userInfo;
@end
