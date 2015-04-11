//
//  UIPlaceHolderTextView.m
//  iMeituan
//
//  Created by lin yu on 11-12-7.
//  Copyright (c) 2011年 meituan. All rights reserved.
//

#import "MTTextView.h"

@implementation MTTextView

@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setPlaceholder:self.placeholder];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:self.placeholder];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
        
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

- (void)designatePlaceholder:(NSString *)string
{
    self.placeholder = string;
}

- (BOOL)becomeFirstResponder {
    if (!self.isFirstResponder) {
        UIView *view = self;
        while (view.superview && ![[view nextResponder] isKindOfClass:[UIViewController class]]) {
            view = view.superview;
            if ([view isKindOfClass:[UIScrollView class]]) {
                break;
            }
        }
        CGRect frame = [self.superview convertRect:self.frame toView:view];
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            if (frame.origin.y+frame.size.height - scrollView.contentOffset.y > 250) {
                int move = (frame.origin.y-scrollView.contentOffset.y)+frame.size.height - (scrollView.height-250);
                [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y+move) animated:YES];
            }
        }else {
            if (frame.origin.y+frame.size.height > view.height-250) {
                
                _movedPix = frame.origin.y+frame.size.height - (view.height-250);
                _movedPix = _movedPix>0 ? _movedPix : 0;
                [UIView animateWithDuration:0.3 animations:^{
                    view.top -= _movedPix;
                }];
            }
        }
    }
    return [super becomeFirstResponder];
}
- (BOOL)resignFirstResponder {

    if (self.isFirstResponder && _movedPix!=0) {
        UIView *view = self;
        while (view.superview && ![[view nextResponder] isKindOfClass:[UIViewController class]]) {
            view = view.superview;
            if ([view isKindOfClass:[UIScrollView class]]) {
                break;
            }
        }
        [UIView animateWithDuration:0.3 animations:^{
            view.top += _movedPix;
            _movedPix = 0;
        }];
    }
    return [super resignFirstResponder];
}

@end
