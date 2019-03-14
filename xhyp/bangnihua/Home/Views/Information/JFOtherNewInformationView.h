//
//  JFOtherNewInformationView.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/28.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFInformationTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN
@protocol sureInstitutionsDelegate <NSObject>
-(void)sureEventClick:(NSMutableArray *)endSelectedArray;
-(void)selectedAllEventClick:(UIButton *)btn;
@end
@interface JFOtherNewInformationView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UILabel *tipsLable;
@property (nonatomic, strong)UIButton *selecBtn;
@property (nonatomic, strong)UITableView *institutionsTableView;
@property (nonatomic,strong)UIButton *sureBtn;
@property (nonatomic, strong)NSMutableArray *boundsArray;//源数据
@property (nonatomic, strong)NSMutableArray *endArray;//用户 最终选择的 数据
@property (nonatomic, assign)BOOL firstSelected;//v标记用户没有进行选择的时候
@property (nonatomic, weak)id<sureInstitutionsDelegate>delegate;
-(void)getBoundsData:(NSMutableArray *)boundsArray;
@end

NS_ASSUME_NONNULL_END
