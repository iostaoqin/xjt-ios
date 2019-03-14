//
//  JFNewHeaderCollectionReusableViewEdit.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFNewHeaderCollectionReusableViewEdit : UICollectionReusableView<SDCycleScrollViewDelegate>
@property (nonatomic, strong)UIImageView *headerImg;
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)SDCycleScrollView *titleCycleView;//轮播文字
@property (nonatomic, strong)UILabel *lineLable;
@end

NS_ASSUME_NONNULL_END
