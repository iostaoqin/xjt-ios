//
//  AppDelegate.h
//  miaosu
//
//  Created by Daisy  on 2019/2/16.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,RESideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong)NSArray  *messageArr;
@property (nonatomic, strong)RESideMenu *sideMenuViewController;
@end

