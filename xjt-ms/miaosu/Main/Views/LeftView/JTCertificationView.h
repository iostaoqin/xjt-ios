//
//  JTCertificationView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CertificationHeaderDelegate <NSObject>
-(void)certificationleftBarButtonItemEvent;
@end
@interface JTCertificationView : UIView
@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic, strong)UILabel *titleLable;
@property (nonatomic, strong)UILabel *firstNameLable;
@property (nonatomic, strong)UILabel *numberLable;
@property (nonatomic, strong)UILabel *secondNameLable;
@property (nonatomic, strong)UILabel *detailNameLable;
@property (nonatomic, strong)UIImageView *middleImg;
@property (nonatomic, weak)id<CertificationHeaderDelegate> certificationDelegate;
-(void)getAreadyCeitication:(NSString *)numberStr;
@end

NS_ASSUME_NONNULL_END
