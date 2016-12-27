//
//  CCTextView.h
//  CCTextView
//
//  Created by Cents on 2016/12/27.
//  Copyright © 2016年 Cents. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDefine.h"

@interface CCTextView : UIView

@property (nonatomic,assign) NSInteger totalCount;

@property (nonatomic,copy) NSString* placeholder;

@property (strong,nonatomic) UIFont* placeholderFont;

@property (strong,nonatomic) UIFont* font;

@property (strong,nonatomic) UIColor* textColor;

@property (strong,nonatomic) UIColor* placeholderTextColor;

@property (nonatomic,copy) NSString* text;

@end
