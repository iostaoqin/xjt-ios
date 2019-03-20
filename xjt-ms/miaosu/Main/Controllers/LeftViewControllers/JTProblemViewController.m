//
//  JTProblemViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTProblemViewController.h"
#import "JTProblemTableViewCell.h"
@interface JTProblemViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *problemTB;
@property (nonatomic, strong)NSArray *colorNameArr;
@property (nonatomic, strong)NSArray *nameArr;
@property (nonatomic, strong)NSMutableArray *heightArr;
@end

@implementation JTProblemViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)leftBarButtonItemEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title  = @"常见问题";
    self.heightArr =  [NSMutableArray array];
    [self problemTBUI];
    if (@available(iOS 11.0, *)) {
        _problemTB.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
-(void)problemTBUI{
    _problemTB  =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH-JT_NAV) style:UITableViewStylePlain];
    _problemTB.backgroundColor =  [UIColor colorWithHexString:@"#F5F5F5"];
    _problemTB.delegate = self;
    _problemTB.dataSource  = self;
    _problemTB.separatorStyle  =  UITableViewCellSeparatorStyleNone;
    _problemTB.tableFooterView   = [UIView new];
    [self.view addSubview:_problemTB];
    //遍历数组
    CGFloat font;
    if (JT_IS_iPhone5) {
        font  = 12;
    }else{font = 14;}
    for (NSInteger i = 0; i < self.colorNameArr.count; i ++) {
        CGFloat height   =[UILabel text:self.colorNameArr[i][3] heightWithFontSize:font width:JT_ScreenW-56 *JT_ADAOTER_WIDTH lineSpacing:6] + 57  *JT_ADAOTER_WIDTH;
        [self.heightArr addObject:[NSString stringWithFormat:@"%f",height]];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.colorNameArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellheight  = [self.heightArr[indexPath.row] floatValue];
    if (cellheight <= 80*JT_ADAOTER_WIDTH) {
         return 80 *JT_ADAOTER_WIDTH;
    }else{
        return cellheight + 10 *JT_ADAOTER_WIDTH;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell  = @"JTProblemTableViewCell";
    JTProblemTableViewCell *problemCell =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!problemCell) {
        problemCell = [[JTProblemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    if (indexPath.row  == self.nameArr.count -1) {
        problemCell.lineLable.hidden =  YES;
    }
    [problemCell getLeftProblemTitle:self.nameArr[indexPath.row] leftNameColor:self.colorNameArr[indexPath.row]];
   
    problemCell.selectionStyle  = UITableViewCellSelectionStyleNone;
    return problemCell;
}
-(NSArray *)colorNameArr{
    if (!_colorNameArr) {
        _colorNameArr = @[@[@"#FF4D4F",@"系统审核时间?",@"#52C41A",@"一般在5-15分钟，实际以您界面显示时间为准"],@[@"#FF4D4F",@"申请条件?",@"#52C41A",@"年龄在18-50周岁，具有完全民事能力即可"],@[@"#FF4D4F",@"审核通过后到账时间?",@"#52C41A",@"1小时内，实际以银行卡到账时间为准"],@[@"#FF4D4F",@"如何修改手机号?",@"#52C41A",@"目前不支持修改手机号"],@[@"#FF4D4F",@"能否重新绑卡?",@"#52C41A",@"暂不支持，如需解绑、重新绑定请联系客服"],@[@"#FF4D4F",@"我的个人资料是否会泄露?",@"#52C41A",@"我们注重您的个人隐私，个人资料会进行严格保密"],@[@"#FF4D4F",@"我的订单没有通过，能否再次申请?",@"#52C41A",@"7天后可重新申请，紧急情况请联系客服"],@[@"#FF4D4F",@"如果我逾期了怎么办?",@"#52C41A",@"请尽快处理，我们对逾期人员，会有专门人员进行跟踪，为了您的个人信用，请及时还款"]];
    }
    return _colorNameArr;
}
-(NSArray *)nameArr{
    if (!_nameArr) {
        _nameArr = @[@[@"问",@"答"],@[@"问",@"答"],@[@"问",@"答"],@[@"问",@"答"],@[@"问",@"答"],@[@"问",@"答"],@[@"问",@"答"],@[@"问",@"答"]];
    }
    return _nameArr;
}
@end
