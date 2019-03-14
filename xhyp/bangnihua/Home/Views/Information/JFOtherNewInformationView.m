//
//  JFOtherNewInformationView.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/28.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFOtherNewInformationView.h"

@implementation JFOtherNewInformationView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)getBoundsData:(NSMutableArray *)boundsArray{
    JTLog(@"%@",boundsArray);
    self.boundsArray  =[[NSMutableArray alloc]init];
    self.boundsArray = boundsArray;
    if (boundsArray.count <5) {
        //小于4
        self.selecBtn.selected  = YES;
        
    }
    [_institutionsTableView reloadData];
}
-(void)initView{
    self.endArray =[[NSMutableArray alloc]init];
    self.firstSelected  = YES;
    self.tipsLable  = [UILabel new];
    self.selecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn =  [self buttonCreateWithNorStr:sure_btn_text nomalBgColor:@"#FF4D4F" textFont:16 cornerRadius:17];
    
    
    [self  addSubview:self.tipsLable];
    [self addSubview:self.selecBtn];
    [self addSubview:self.sureBtn];
    
    self.tipsLable.textColor = [UIColor colorWithHexString:@"#333333"];
    self.tipsLable.font  = kFontSystem(16);
    self.tipsLable.text  = institutions_tips_text;
    //
    [self.selecBtn setImage:[UIImage imageNamed:@"img_new_nomal"] forState:UIControlStateNormal];
    [self.selecBtn setImage:[UIImage imageNamed:@"img_new_selected"] forState:UIControlStateSelected];
    [self.selecBtn setImage:[UIImage imageNamed:@"img_new_selected"] forState:UIControlStateHighlighted];
    [self.selecBtn setTitle:all_selected_text forState:UIControlStateNormal];
    self.selecBtn.titleLabel.font =  kFontSystem(16);
    [self.selecBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [self.selecBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -35  * JT_ADAOTER_WIDTH, 0, 0)];
    [self.selecBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20 *  JT_ADAOTER_WIDTH, 0, 0)];
    
    self.institutionsTableView  =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.institutionsTableView.delegate  =self;
    self.institutionsTableView.dataSource= self;
    self.institutionsTableView.backgroundColor  =[UIColor clearColor];
    self.institutionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.institutionsTableView];
    
    [self.sureBtn  addTarget:self action:@selector(sureBtnEventClick:) forControlEvents:UIControlEventTouchUpInside];
     [self.selecBtn  addTarget:self action:@selector(selecBtnEventClick:) forControlEvents:UIControlEventTouchUpInside];
    [self makeConstraints];
 
}
-(void)sureBtnEventClick:(UIButton *)sender{
    NSInteger  count=0;
    if ([self.delegate respondsToSelector:@selector(sureEventClick:)]) {
        if (self.firstSelected == YES) {
            //取前四个
            for (JFEditHomeSmallModel *fourthModel in self.boundsArray) {
                if (count  < 4) {
                    
                    [self.endArray addObject:fourthModel];
                }
                count ++;
            }
        }
        [self.delegate sureEventClick:self.endArray];
    }
}
-(void)selecBtnEventClick:(UIButton *)sender{
     sender.selected = !sender.selected;
    
    for (JFEditHomeSmallModel *orgModel in self.boundsArray) {
        orgModel.option = sender.selected;
    }
    [self updateSelectedData];
    [_institutionsTableView reloadData];
    
}
-(void)makeConstraints{
    [self.tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(22 *  JT_ADAOTER_WIDTH);
    }];
    [self.selecBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLable.mas_bottom).offset(20 * JT_ADAOTER_WIDTH);
        make.left.equalTo(self.mas_left).offset(54  * JT_ADAOTER_WIDTH);
        make.width.mas_equalTo(100  * JT_ADAOTER_WIDTH);
    }];
    [self.institutionsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.top.equalTo(self.selecBtn.mas_bottom).offset(17);
        make.height.mas_equalTo(246 * JT_ADAOTER_WIDTH);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120 * JT_ADAOTER_WIDTH, 34  * JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-13 *JT_ADAOTER_WIDTH);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.boundsArray.count) {
         return self.boundsArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cellID";
    JFInformationTableViewCell *institutionsCell =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!institutionsCell) {
        institutionsCell =[[JFInformationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    //前4个是默认选中状态的
    JFEditHomeSmallModel *orgModel =self.boundsArray[indexPath.row];
//    if (indexPath.row < 4) {
//
//        orgModel.option = YES;
//    }
    [institutionsCell getboundsData:orgModel];
    institutionsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return institutionsCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JFEditHomeSmallModel *model = self.boundsArray[indexPath.row];
    if (model.option) {
        model.option =  NO;
    }else{
        model.option =  YES;
    }
     [self updateSelectedData];
    [_institutionsTableView reloadData];
}
#pragma mark - 更新选择数据及全选状态
-(void)updateSelectedData{
    NSInteger counts  = 0;
    self.firstSelected  = NO;;
    [self.endArray removeAllObjects];
    for (JFEditHomeSmallModel *selectedModel in self.boundsArray) {
        if (selectedModel.option) {
            counts ++;
            [self.endArray addObject:selectedModel];
        }
    }
    if (counts != self.boundsArray.count) {
        self.selecBtn.selected = NO;
    }else{
        self.selecBtn.selected = YES;
    }
    JTLog(@"用户最终选择的数据%@",self.endArray);
}
@end
