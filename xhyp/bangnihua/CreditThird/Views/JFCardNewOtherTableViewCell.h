//
//  JFCardNewOtherTableViewCell.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/28.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFCardNewOtherTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *cardNameLable;
@property (nonatomic, strong)UITextView *textViewDetail;
-(void)getFirstData:(NSMutableArray *)cardModelArr  showIndx:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
