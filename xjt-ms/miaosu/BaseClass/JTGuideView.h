//
//  JTGuideView.h
//  miaosu
//
//  Created by Daisy  on 2019/3/4.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RunPageControllerDelegate <NSObject>

-(void)OnButtonClick;

@end
NS_ASSUME_NONNULL_BEGIN

@interface JTGuideView : UIView
@property id<RunPageControllerDelegate>guideDelagte;
@end

NS_ASSUME_NONNULL_END
