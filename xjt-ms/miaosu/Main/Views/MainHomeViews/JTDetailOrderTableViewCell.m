//
//  JTDetailOrderTableViewCell.m
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTDetailOrderTableViewCell.h"

@implementation JTDetailOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
    
}
-(void)initView{
    self.nameLable  =[UILabel new];
    self.detailNameLable  =[UILabel new];
    self.lineLable  =[UILabel new];
    self.loanImg  =[UIButton new];
    [self.contentView addSubview:self.loanImg];
    [self.contentView addSubview:self.lineLable];
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.detailNameLable];
    if (JT_IS_iPhone5) {
        self.nameLable.font = kFontSystem(14);
        self.detailNameLable.font = kFontSystem(14);
       
    }else{
        self.nameLable.font = kFontSystem(16);
        self.detailNameLable.font = kFontSystem(16);
       
    }
    self.nameLable.textColor  =[UIColor colorWithHexString:@"#333333"];
    self.detailNameLable.textColor  =[UIColor colorWithHexString:@"#666666"];
    self.lineLable.backgroundColor  =[UIColor colorWithHexString:@"#EEEEEE"];
    [self.loanImg setImage:[UIImage imageNamed:@"questionMark"] forState:UIControlStateNormal];
    self.lineLable.hidden = YES;
    self.loanImg.hidden   = YES;
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(16*JT_ADAOTER_WIDTH);
    }];
    [self.detailNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-16*JT_ADAOTER_WIDTH);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    [self.loanImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_right).offset(5);
        make.centerY.equalTo(self.nameLable);
        make.size.mas_equalTo(CGSizeMake(16*JT_ADAOTER_WIDTH, 16 *JT_ADAOTER_WIDTH));
    }];
}
-(void)getNameLeftStr:(NSString *)str rightDetailStr:(NSString *)rightStr{
    self.nameLable.text = str;
    self.detailNameLable.text  = rightStr;
}
-(void)getPayLeftData:(NSArray *)leftStr payModel:(JTLoanModel *)loanModel index:(NSInteger)idx{

//    self.nameLable.text = str;
    if ([loanModel.recordType isEqualToString:@"1"]) {
        self.nameLable.text  = leftStr[0][idx];
        //还款记录
        if (idx ==0) {
            self.detailNameLable.text=   [NSString stringWithFormat:@"%@元",[NSString stringWithFormat:@"%.2f",[JFHSUtilsTool roundFloat:[loanModel.repaymentAmount floatValue]/100]]];
            
        }else{
            self.detailNameLable.text = loanModel.recentRepaymentDate = [JFHSUtilsTool getDateStringWithTimeStr:loanModel.repaymentDate showType:@"yyyy-MM-dd HH:mm:ss"];
            
        }
     
    }else{
        //续期记录
        if (idx ==0) {
            self.detailNameLable.text=   [NSString stringWithFormat:@"%@元",[NSString stringWithFormat:@"%.2f",[JFHSUtilsTool roundFloat:[loanModel.repaymentAmount floatValue]/100]]];
            
        }else{
            self.detailNameLable.text = loanModel.recentRepaymentDate = [JFHSUtilsTool getDateStringWithTimeStr:loanModel.repaymentDate showType:@"yyyy-MM-dd HH:mm:ss"];
            
        }
        self.nameLable.text  = leftStr[1][idx];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
