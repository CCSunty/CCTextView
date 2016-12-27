//
//  CCTextView.m
//  CCTextView
//
//  Created by Cents on 2016/12/27.
//  Copyright © 2016年 Cents. All rights reserved.
//

#import "CCTextView.h"

@interface CCTextView() <UITextViewDelegate>

@property (weak,nonatomic) UITextView* textView;

@property (weak,nonatomic) UILabel* countLabel;

@property (weak,nonatomic) UILabel* placeholderLabel;

@end

@implementation CCTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化textView
        UITextView* textView = [UITextView new];
        _textView = textView;
        _textView.font = CCTextViewDefaultFont;
        _textView.textColor = CCTextViewDefaultFontColor;
        [self addSubview:textView];
        
        // 初始化countlabel
        UILabel* countLabel = [UILabel new];
        _countLabel = countLabel;
        [self addSubview:countLabel];
        _countLabel.font = CCTextViewDefaultFont;
        _countLabel.textColor = CCTextViewDefaultFontColor;
        _countLabel.hidden = YES;
        
        // 初始化placeholder
        UILabel* placeholderLabel = [UILabel new];
        _placeholderLabel = placeholderLabel;
        _placeholderLabel.font = CCTextViewDefaultFont;
        _placeholderLabel.textColor = CCTextViewDefaultFontColor;
        [self addSubview:placeholderLabel];
        _textView.delegate = self;
    }
    return self;
}

- (void)setFont:(UIFont *)font{
    _font = font;
    _textView.font = font;
    _placeholderLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _textView.textColor = textColor;
    _placeholderLabel.textColor = textColor;
}


- (void)setTotalCount:(NSInteger)totalCount{
    _totalCount = totalCount;
    _countLabel.hidden = NO;
    [_countLabel setText:[NSString stringWithFormat:@"%ld/%ld",_textView.text.length,_totalCount]];
    [self setNeedsUpdateConstraints];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
    [self setNeedsUpdateConstraints];
}

-(void)setText:(NSString *)text{
    _text = text;
    if (text && text.length > 0) {
        _textView.text = text;
        // fixed 中英文混排
        _textView.attributedText = [self attributeString:text];
        _placeholderLabel.hidden = _textView.hasText;
    }
    
    [self textCount:_textView];
    [self setNeedsUpdateConstraints];
}

#pragma mark - override
- (void)updateConstraints{
    
    [_countLabel sizeToFit];
    CGFloat countHeight = 0;
    if (!_countLabel.hidden) {
        countHeight = _countLabel.frame.size.height;
    }
    
    [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self);
        make.bottom.equalTo(self).offset(-countHeight);
    }];
    
    if (!_countLabel.hidden) {
        [_countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.and.right.equalTo(self);
            make.top.equalTo(_textView.mas_bottom);
        }];
    }else{
        [_countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }

    [_placeholderLabel sizeToFit];
    UIEdgeInsets padding = UIEdgeInsetsMake(_textView.textContainerInset.top, 3.f, 0, 0);
    [_placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView).offset(padding.top);
        make.left.equalTo(_textView).offset(padding.left);
    }];
    
    [super updateConstraints];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)textCount:(UITextView *)textView
{
    NSString *string = textView.text;
    NSString *lang = [(UITextInputMode*)[[UITextInputMode activeInputModes] firstObject] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        //如果输入有中文，且没有出现文字备选框就对字数统计和限制
        //出现了备选框就暂不统计
        UITextRange *range = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:range.start offset:0];
        if (!position)
        {
            
            if (string.length > _totalCount && _totalCount > 0)
            {
                textView.text = [string substringToIndex:_totalCount];
            }
            NSInteger length = textView.text.length;
            NSInteger num = _totalCount - length;
            num = MAX(num, 0);
            [_countLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)num,(long)_totalCount]];
            [_countLabel sizeToFit];
        }
    }else{
        if (string.length > _totalCount && _totalCount > 0)
        {
            textView.text = [string substringToIndex:_totalCount];
        }
        NSInteger length = textView.text.length;
        NSInteger num = _totalCount - length;
        num = MAX(num, 0);
        [_countLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)num,(long)_totalCount]];
        [_countLabel sizeToFit];
    }
}

- (NSMutableAttributedString *)attributeString:(NSString*) text{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:
                                       text attributes:@{NSFontAttributeName:CCTextViewDefaultFont,NSParagraphStyleAttributeName:paragraphStyle}];
    return attr;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    _placeholderLabel.font = placeholderFont;
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor{
    _placeholderTextColor = placeholderTextColor;
    _placeholderLabel.textColor = placeholderTextColor;
}

@end

@implementation CCTextView(Delegate)

- (void)textViewDidChange:(UITextView *)textView{
    _placeholderLabel.hidden = textView.hasText;
    [self textCount:textView];
}

// 屏蔽掉回车换行
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if( [ @"\n" isEqualToString: text]){
        [textView endEditing:YES];
        return NO;
    }
    return YES;
}

@end
