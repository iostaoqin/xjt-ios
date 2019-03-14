//
//  JTOperatorView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol OperatorViewHeaderDelegate <NSObject>
-(void)OperatorViewleftBarButtonItemEvent;
@end
@interface JTOperatorView : UIView
@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic,  strong)UILabel *nameLable;
@property (nonatomic, strong)UIImageView *operationImg;
@property (nonatomic, weak)id<OperatorViewHeaderDelegate>delegate;
-(void)getOperationLogoImg:(NSString *)img;
@end

NS_ASSUME_NONNULL_END
