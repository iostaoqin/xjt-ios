//
//  JTEmptyView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTEmptyView : UIView
@property (nonatomic, strong)UIImageView *emptyImg;
@property (nonatomic, strong)UILabel *emptyLable;
-(void)getEmptyImg:(NSString *)img emptyTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
