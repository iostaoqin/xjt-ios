//
//  JFNewCardEditView.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/26.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol changeAddressDelegate <NSObject>
-(void)changeAddress;

@end
@interface JFNewCardEditView : UIView
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *detailLable;
@property (nonatomic, strong)UIImageView *rightImg;
@property (nonatomic, strong)UIImageView *locationImg;
@property (nonatomic, strong)UILabel *addressLable;
@property (nonatomic, strong)UIButton *changeCityBtn;
@property (nonatomic, strong)UILabel *lineLable;
@property  (nonatomic, weak)id<changeAddressDelegate>addressDelegate;
@end

NS_ASSUME_NONNULL_END
