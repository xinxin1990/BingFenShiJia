//
//  BFZFViewController.h
//  缤微纷购
//
//  Created by 郑洋 on 16/3/4.
//  Copyright © 2016年 xinxincao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFZFViewController : UIViewController
/**拼团id*/
@property (nonatomic, strong) NSString *ID;
@property (nonatomic,retain)NSMutableArray *modelArr;
@property (nonatomic)BOOL isPT;
@property (nonatomic,copy)void (^removeBlock)();

@end
