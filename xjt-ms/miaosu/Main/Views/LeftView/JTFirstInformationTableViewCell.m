//
//  JTFirstInformationTableViewCell.m
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTFirstInformationTableViewCell.h"

@implementation JTFirstInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.nameLable =[UILabel new];
    self.lineLable  =[UILabel new];
    self.waringArrow  =[UIImageView new];
     self.addressTextView  =[UITextView new];
    self.placeLable =[UILabel new];
    self.tipsLable =[UILabel new];
    
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.lineLable];
    [self.contentView addSubview:self.addressTextView];
    [self.addressTextView addSubview:self.placeLable];
    [self.addressTextView addSubview:self.waringArrow];
    [self.addressTextView addSubview:self.tipsLable];
    
    self.nameLable.text  = @"常驻地址";
    self.lineLable.backgroundColor  =[UIColor colorWithHexString:@"#EEEEEE"];
    self.waringArrow.image = [UIImage imageNamed:@"info_fill"];
    self.addressTextView.scrollEnabled = NO;
    self.addressTextView.delegate  = self;
    //place
    self.placeLable.tag = 999;
    self.placeLable.alpha = 0;
    [self.placeLable setNumberOfLines:0];
    self.placeLable.textColor   =[UIColor colorWithHexString:@"999999"];
  
    //
    self.tipsLable.textColor   =[UIColor colorWithHexString:@"999999"];
    self.tipsLable.text= @"填写地址过短";
    if (JT_IS_iPhone5) {
        self.nameLable.font =  kFontSystem(14);
        self.addressTextView.font  = kFontSystem(14);
        self.placeLable.font  = kFontSystem(14);
        self.tipsLable.font  = kFontSystem(12);
    }else{
        self.nameLable.font =  kFontSystem(16);
        self.addressTextView.font  = kFontSystem(16);
         self.placeLable.font  = kFontSystem(16);
         self.tipsLable.font  = kFontSystem(14);
    }
    [self makeConstraintsUI];
    
}
-(void)makeConstraintsUI{
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
        make.centerY.equalTo(self.contentView);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    [self.addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(self.contentView.mas_left).offset(112 *JT_ADAOTER_WIDTH);
     make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.lineLable.mas_top);
    }];

    [self.placeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressTextView.mas_left);
        make.top.equalTo(self.addressTextView.mas_top).offset(7);
        make.right.equalTo(self.addressTextView.mas_right);
    }];
   
    [self.waringArrow  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18*JT_ADAOTER_WIDTH, 18 *JT_ADAOTER_WIDTH));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_right).offset(-130*JT_ADAOTER_WIDTH);
    }];
    [self.tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.waringArrow.mas_right).offset(5);
    }];
    if ([[_addressTextView text]length]==0) {
        [[_addressTextView viewWithTag:999] setAlpha:1];
    }
    
  
    self.waringArrow.hidden = YES;
    self.tipsLable.hidden  = YES;
}
-(void)textChange:(NSNotification *)notification{
    if ([[self.addressTextView text]length] == 0) {
        [[self.addressTextView viewWithTag:999]setAlpha:1];
    }else{
        [[self.addressTextView viewWithTag:999]setAlpha:0];
    }
    if (self.addressTextView.text.length <  5 && self.addressTextView.text.length !=0) {
        self.waringArrow.hidden = NO;
        self.tipsLable.hidden  = NO;
    }else{
        self.waringArrow.hidden = YES;
        self.tipsLable.hidden  = YES;
    }
   
}
-(void)getInformationPlaceHolder:(NSString *)placeStr indx:(NSInteger)idx{
    self.placeLable.text =  placeStr;
    if (idx  ==0) {
        //添加手势
      
        UITapGestureRecognizer *getsture  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapProviceGesture)];
        [self.addressTextView addGestureRecognizer:getsture];
    }else{
        //监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
}
-(void)tapProviceGesture{
    if ([self.delegate respondsToSelector:@selector(ProvincesBtnItemEvent)]) {
        [self.delegate ProvincesBtnItemEvent];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//每次 textView 内容改变的时候，就重新计算一次 textView 的大小，并让 tableView 更新高度。
- (void)textViewDidChange:(UITextView *)textView{
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize; textView.bounds = bounds;
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
    
}
- (UITableView *)tableView{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
        
    }
    return (UITableView *)tableView;
    
}

@end
