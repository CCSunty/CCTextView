//
//  ViewController.m
//  CCTextView
//
//  Created by Cents on 2016/12/27.
//  Copyright © 2016年 Cents. All rights reserved.
//

#import "ViewController.h"
#import "CCTextView.h"

@interface ViewController ()

@property (weak,nonatomic) CCTextView* textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CCTextView* textView = [CCTextView new];
    _textView = textView;
    [self.view addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@200);
    }];
    
    textView.totalCount = 200;
    
    textView.placeholder = @"不想说点什么？";
    
    textView.text = @"121212121212";
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
