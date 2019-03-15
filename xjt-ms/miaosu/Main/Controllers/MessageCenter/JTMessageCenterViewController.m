//
//  JTMessageCenterViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTMessageCenterViewController.h"
#import "JTMessageCenterTableViewCell.h"
@interface JTMessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView  *messageTableView;
@property (nonatomic, strong)NSMutableArray  *messageArray;
@end

@implementation JTMessageCenterViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统通知";
    [self messageTableViewUI];
    self.messageArray  =[NSMutableArray array];
    if (@available(iOS 11.0, *)) {
        _messageTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self notificationlistsData];
    /*请求已读接口 */
    [self notificationReadData];
}
-(void)notificationReadData{
   
    JFUserInfoTool *userinfo =[JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:userinfo.keyStr]) {
        
        NSString *noticeurl  =[NSString stringWithFormat:@"%@/xjt/message",JT_MS_URL];
        
        NSDictionary   *dic = @{@"read":@"true"};
        NSString *url  =   [JFHSUtilsTool conectUrl:[dic mutableCopy] url:noticeurl];
        [JFHttpsTool requestType:@"post" passwordStr:@"" putWithUrl:url withParameter:@{} withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
             JTLog(@"已读信息=%@",data);
            if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
                
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:data[@"resultCodeMessage"]];
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                });
                if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"2"]) {
                    [self againLogin];
                }
            }
        } withErrorCodeTwo:^{
            
        } withErrorBlock:^(NSError * _Nonnull error) {
            
        }];
    }
}
-(void)leftBarButtonItemEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)messageTableViewUI{
    self.messageTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0,0, JT_ScreenW, JT_ScreenH-kTabBarHeight -15 *JT_ADAOTER_WIDTH) style:UITableViewStyleGrouped];
    [self.view addSubview:self.messageTableView];
    self.messageTableView.delegate  = self;
    self.messageTableView.dataSource  = self;
    self.messageTableView.backgroundColor   = [UIColor colorWithHexString:@"#F5F5F5"];
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messageTableView.tableFooterView  =[UIView new];
}
#pragma mark  -请求通知信息
-(void)notificationlistsData{
    JFUserInfoTool *userinfo =[JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:userinfo.keyStr]) {
        
        NSString *noticeurl  =[NSString stringWithFormat:@"%@/xjt/messages",JT_MS_URL];
        [PPNetworkHelper setValue:userinfo.keyStr forHTTPHeaderField:@"API_KEY"];
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
        [PPNetworkHelper GET:noticeurl parameters:nil success:^(id responseObject) {
            JTLog(@"请求通知信息=%@",responseObject);
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
                CGFloat font;
                if (JT_IS_iPhone5) {
                    font = 12;
                }else{font =  14;}
                [self.messageArray removeAllObjects];
                NSArray *temeArr  =responseObject[@"messages"];
                if (temeArr.count ==0) {
                    [self emptyUI];
                }else{
                    for (NSDictionary  *msgdic in responseObject[@"messages"]) {
                        JTMessageModel *model =[JTMessageModel mj_objectWithKeyValues:msgdic];
                        CGFloat  height =[UILabel  text:model.messageText heightWithFontSize:font width:JT_ScreenW - 52 *JT_ADAOTER_WIDTH lineSpacing:6];
                        model.cellHeight = height + 67*JT_ADAOTER_WIDTH;
                        [self.messageArray addObject:model];
                        JTLog(@"cellHeight=%f",model.cellHeight);
                    }
                }
            }else{
                //错误提示信息
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:responseObject[@"resultCodeMessage"]];
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                });
                if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"2"]) {
                    [self againLogin];
                }
            }
            [self.messageTableView reloadData];
        } failure:^(NSError *error) {
             [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        }];
        
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.messageArray.count) {
        return self.messageArray.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20*JT_ADAOTER_WIDTH;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView =[UIView new];
    headerView.backgroundColor= [UIColor colorWithHexString:@"F5F5F5"];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.messageArray.count) {
        JTMessageModel *model = self.messageArray[indexPath.section];
        if (model.cellHeight <= 90 * JT_ADAOTER_WIDTH) {
         return 90 *JT_ADAOTER_WIDTH;
        }return model.cellHeight + 5 *JT_ADAOTER_WIDTH;
        
    }return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell  = @"JTMessageCenterTableViewCell";
    JTMessageCenterTableViewCell *messageCell  =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!messageCell) {
        messageCell  =[[JTMessageCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    if (self.messageArray.count) {
        [messageCell getMessagedata:self.messageArray[indexPath.section]];
    }
    messageCell.selectionStyle =UITableViewCellSelectionStyleNone;
    messageCell.backgroundColor  = [UIColor clearColor];
    return messageCell;
}
-(void)emptyUI{
    JTEmptyView *emptyView  =[JTEmptyView new];
    [self.view addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(105  * JT_ADAOTER_WIDTH);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(120*JT_ADAOTER_WIDTH);
    }];
    [emptyView getEmptyImg:@"messageEmpty" emptyTitle:@"暂无消息~"];
}
@end
