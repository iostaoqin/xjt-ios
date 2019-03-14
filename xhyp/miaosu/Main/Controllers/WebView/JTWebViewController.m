//
//  JTWebViewController.m
//  Flower
//
//  Created by Daisy  on 2019/1/25.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTWebViewController.h"
#import <WebKit/WebKit.h>
@interface JTWebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@property (nonatomic, strong)UIProgressView *progressLayer;
@property (nonatomic, strong)WKWebView *wkWebView;
@end

@implementation JTWebViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //TODO:加载
    NSString *result = [self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:result]]];
    //TODO:kvo监听，获得页面title和加载进度值
    
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"webSuccessNotice" object:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    WEAKSELF;
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressLayer.progress = self.wkWebView.estimatedProgress;
        if (self.progressLayer.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressLayer.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressLayer.hidden = YES;
                
            }];
        }
    }else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.wkWebView)
        {
            self.title = self.wkWebView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    
}
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressLayer.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressLayer.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressLayer];
    //
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //加载完成后隐藏progressView
    self.progressLayer.hidden = YES;
    if (self.dic.count ) {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *paraStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 将JSON字符串转成无换行无空格字符串
    paraStr = [self noWhiteSpaceString:paraStr];
    
    NSString * backStr = [NSString stringWithFormat:@"%@('%@','%@')", @"fromClientParams",self.showtype,paraStr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // OC 调用JS方法
        [self.wkWebView evaluateJavaScript:backStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        }];
    });
    }
}
- (NSString *)noWhiteSpaceString:(NSString  *)str {
    NSString *newString = str;
    //去除掉首尾的空白字符和换行字符
    newString = [newString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符使用
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    可以去掉空格，注意此时生成的strUrl是autorelease属性的，所以不必对strUrl进行release操作！
    return newString;
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
   
   
    decisionHandler(WKNavigationActionPolicyAllow);
}
//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //加载失败同样需要隐藏progressView
    self.progressLayer.hidden = YES;
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
   
   
}

#pragma mark -加载结束

- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
        _wkConfig.preferences.minimumFontSize    = 14;
          WKUserContentController *userCC = _wkConfig.userContentController;
        //JS调用OC 添加处理脚本
        
//        [userCC addScriptMessageHandler:self.wkWebView name:@"getUserInfo"];
        if (@available(iOS 9.0, *)) {
            _wkConfig.allowsPictureInPictureMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
    }
    return _wkConfig;
}
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH -kTabBarHeight) configuration:self.wkConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}
-(UIProgressView *)progressLayer{
    if (!_progressLayer) {
        _progressLayer = [[UIProgressView alloc]init];
        _progressLayer.frame  = CGRectMake(0, 0, JT_ScreenW , 2);
        _progressLayer.tintColor  =[UIColor  blueColor];
        _progressLayer.backgroundColor = [UIColor  lightGrayColor];
        _progressLayer.transform  = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self.view addSubview:_progressLayer];
    }
    return _progressLayer;
}

-(void)leftBarButtonItemEvent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
