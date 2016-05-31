//
//  CWStackProtocol.h
//  CWStackControllerDemo
//
//  Created by Guojiubo on 14-9-14.
//  Copyright (c) 2014年 CocoaWind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CWStackController.h"

@protocol CWStackProtocol <NSObject>
@optional
- (UIViewController *)nextViewController;
- (void )previousViewController;;

@required

@end
