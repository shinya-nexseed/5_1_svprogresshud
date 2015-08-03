//
//  ViewController.m
//  5_1_svprogresshud
//
//  Created by Shinya Hirai on 2015/08/03.
//  Copyright (c) 2015年 Shinya Hirai. All rights reserved.
//

#import "ViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.myLabel.hidden = YES; // ラベルの存在を消しておく
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapBtn:(id)sender {
    [SVProgressHUD show]; // プログレスビューを表示
    // 非同期処理 (dispatch)
    dispatch_queue_t global_q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // 裏側で処理を動かすキューを作成
    dispatch_queue_t mail_q = dispatch_get_main_queue(); // globalなキューが終了した際に呼ばれるキューを作成
    
    dispatch_async(global_q, ^{
        // 重たい処理をさせる
        // apiを叩く処理 → 時間のかかる重たい処理
        NSString *urlString = @"http://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&titles=%E3%82%A8%E3%83%9E%E3%83%BB%E3%83%AF%E3%83%88%E3%82%BD%E3%83%B3&rvprop=content";
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSError *error = nil;
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        NSLog(@"%@",jsonObject);
        
        NSString *str = jsonObject[@"query"][@"pages"][@"128948"][@"title"];
        
        dispatch_async(mail_q, ^{
            // globalの処理が終わった際にやりたい処理
            self.myLabel.text = str;
            self.myLabel.hidden = NO;
            [SVProgressHUD dismiss];
        });
    });
    

    // プログレスビューを消す処理 → 重たい処理が終了したとき
}





@end
