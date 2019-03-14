//
//  JTFirstInformationTableViewCell.h
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ProvincesDelegate <NSObject>
-(void)ProvincesBtnItemEvent;
@end
@interface JTFirstInformationTableViewCell : UITableViewCell<UITextViewDelegate>
@property(nonatomic, strong)UILabel *nameLable;
@property(nonatomic, strong)UIImageView *arrow;
@property(nonatomic, strong)UIImageView *waringArrow;//当用户填写的地址少于5个字的时候
@property(nonatomic, strong)UILabel *tipsLable;
@property(nonatomic, strong)UITextView *addressTextView;
@property(nonatomic, strong)UILabel *placeLable;
@property(nonatomic, strong)UILabel *lineLable;
@property(nonatomic, weak)id<ProvincesDelegate> delegate;
-(void)getInformationPlaceHolder:(NSString *)placeStr indx:(NSInteger)idx;
@end

NS_ASSUME_NONNULL_END
