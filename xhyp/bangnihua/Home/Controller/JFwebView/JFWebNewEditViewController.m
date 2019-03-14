//
//  JFWebNewEditViewController.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/4.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFWebNewEditViewController.h"
#import <WebKit/WebKit.h>
#import <StoreKit/StoreKit.h>
@interface JFWebNewEditViewController ()<WKNavigationDelegate,WKUIDelegate,SKStoreProductViewControllerDelegate>
@property (nonatomic, strong)WKWebView *wkWebView;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@property (nonatomic, strong)UIProgressView *progressLayer;
@end

@implementation JFWebNewEditViewController
-(void)dealloc{
    
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
     [self.wkWebView removeObserver:self forKeyPath:@"title"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
   //神策提交用户 浏览时长事件
    [[SensorsAnalyticsSDK  sharedInstance]trackTimerStart:@"ViewProduct"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSDictionary *dic  = @{@"product_type":self.webArr[2],@"product_id":self.webArr[1],@"product_name":self.webArr[0],@"product_url":self.url};
    [[SensorsAnalyticsSDK  sharedInstance]trackTimerEnd:@"ViewProduct" withProperties:dic];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLeftButtonItemWithImage:@"mine_comeBack_img" secondImg:@"new_closeImg"];
    if (self.imgBlock) {
        self.imgBlock();
    }
    //TODO:加载
//    1.字符串加百分号转义使用编码 (这个方法会把参数里面的东西转义)
//    NSString *str1 = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    2.字符串替换百分号转义使用编码
    NSString *result = [self.url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *result = [self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
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
    

    
    
    [webView evaluateJavaScript:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.src = \'https://v3.jiebangbang.cn/inject.app.js';"
     "document.getElementsByTagName('head')[0].appendChild(script);" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
         
     }];
    
    
    
    //加载完成后隐藏progressView
    self.progressLayer.hidden = YES;
    
  
    
    
    
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
        NSString *strUrl = navigationAction.request.URL.absoluteString;
    if ([[SensorsAnalyticsSDK sharedInstance] showUpWebView:webView WithRequest:navigationAction.request]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if (webView != self.wkWebView) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [self.wkWebView loadRequest:navigationAction.request];
//    }
    NSURL *url  = navigationAction.request.URL;
    UIApplication *app  = [UIApplication sharedApplication];
    //appstore
    if ([url.absoluteString containsString:@"itunes.apple.com"]) {
//        if ([app canOpenURL:url]) {
//            if (@available(iOS 10.0, *)) {
//                [app openURL:url options:@{} completionHandler:^(BOOL success) {
//
//                }];
//            } else {
//                // Fallback on earlier versions
//            }
//            decisionHandler(WKNavigationActionPolicyCancel);
//            return;
//        }
        
                NSArray *stringUrlTwo = [strUrl componentsSeparatedByString:@"id"];
                JTLog(@"字符串截取%@",stringUrlTwo);
                SKStoreProductViewController *productVC = [[SKStoreProductViewController alloc]init];
                productVC.delegate  = self;
                [productVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:stringUrlTwo[1]} completionBlock:^(BOOL result, NSError * _Nullable error) {
                    if (error) {
                        JTLog(@"%@",error);
                    }else{
                        [self presentViewController:productVC animated:YES completion:nil];
                    }
                }];
    }
   
    //appstore的外的包
    if ([url.absoluteString containsString:@"itms-services://"]||[url.absoluteString containsString:@"fir.im"]||[url.absoluteString containsString:@"https://itunes"]) {
    
        if (@available(iOS 10.0, *)) {
            [app openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            // Fallback on earlier versions
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    //加载不守信认的url
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        
    }
}



//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //加载失败同样需要隐藏progressView
    self.progressLayer.hidden = YES;
}
#pragma mark -加载结束
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
   self.title   =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
   
}
- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        _wkConfig.allowsInlineMediaPlayback = YES;
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
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH ) configuration:self.wkConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}
-(UIProgressView *)progressLayer{
    if (!_progressLayer) {
        _progressLayer = [[UIProgressView alloc]init];
        _progressLayer.frame  = CGRectMake(0, JT_NAV, JT_ScreenW , 2);
        _progressLayer.tintColor  =[UIColor  blueColor];
        _progressLayer.backgroundColor = [UIColor  lightGrayColor];
        _progressLayer.transform  = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self.view addSubview:_progressLayer];
    }
    return _progressLayer;
}
-(void)firstCloseImgEvent:(id)sender{
    
    if ([self.whereVC isEqualToString:@"JFUserLoginViewController"]) {
        //从登录界面过来 直接n返回最初一级
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        if (self.wkWebView.canGoBack) {
            //返回上级页面
            [self.wkWebView goBack];
            
        }else{
          [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
//如果是H5页面里面自带的返回按钮处理如下: #pragma mark
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSString * requestString = [[request URL] absoluteString]; requestString = [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    //获取H5页面里面按钮的操作方法,根据这个进行判断返回是内部的还是push的上一级页面
//    if ([requestString hasPrefix:@"goback:"]) { [self.navigationController popViewControllerAnimated:YES];
//
//    }else
//    {
//        [self.webView goBack];
//
//    }
//    return YES;
//
//}

-(void)secondCloseImgEvent:(id)sender{
    if ([self.whereVC isEqualToString:@"JFUserLoginViewController"]) {
        //从登录界面过来 直接n返回最初一级
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
