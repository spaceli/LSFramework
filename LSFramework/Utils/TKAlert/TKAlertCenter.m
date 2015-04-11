//
//  TKAlertCenter.m
//  Created by Devin Ross on 9/29/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "TKAlertCenter.h"


#pragma mark -
@interface TKAlertView : UIView {
	CGRect _messageRect;
	NSString *_text;
	UIImage *_image;
}

- (id) init;
- (void) setMessageText:(NSString*)str;
- (void) setImage:(UIImage*)image;

@end


#pragma mark -
@implementation TKAlertView

- (id) init{
	if(!(self = [super initWithFrame:CGRectMake(0, 0, 100, 100)])) return nil;
	_messageRect = CGRectInset(self.bounds, 10, 10);
	self.backgroundColor = [UIColor clearColor];
	return self;
	
}

- (void) drawRect:(CGRect)rect{
	[[UIColor colorWithWhite:0 alpha:0.6] set];
	[UIView drawRoundRectangleInRect:rect withRadius:5];
//	[[UIColor whiteColor] set];
    [RGBCOLOR(233, 233, 233) set];
	[_text drawInRect:_messageRect withFont:[UIFont boldSystemFontOfSize:16] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
    
	CGRect r = CGRectZero;
	r.origin.y = 15;
	r.origin.x = (rect.size.width-_image.size.width)/2;
	r.size = _image.size;
	
	[_image drawInRect:r];
}

#pragma mark Setter Methods
- (void) adjust{
	
//	CGSize s = [_text sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(160,200) lineBreakMode:UILineBreakModeWordWrap];
	
    CGSize s = [_text sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(200,200) lineBreakMode:UILineBreakModeWordWrap];
    
	float imageAdjustment = 0;
	if (_image) {
		imageAdjustment = 7+_image.size.height;
	}
	
//	self.bounds = CGRectMake(0, 0, s.width+40, s.height+15+15+imageAdjustment);
	self.bounds = CGRectMake(0, 0, s.width+22+22, s.height+22+22+imageAdjustment);
    
	_messageRect.size = s;
	_messageRect.size.height += 5;
	_messageRect.origin.x = 22;
	_messageRect.origin.y = 22+imageAdjustment;
	
	[self setNeedsLayout];
	[self setNeedsDisplay];
	
}
- (void) setMessageText:(NSString*)str{
	_text = str;
	[self adjust];
}
- (void) setImage:(UIImage*)img{
	_image = img;
	[self adjust];
}

@end


#pragma mark -
@implementation TKAlertCenter

#pragma mark Init & Friends
+ (TKAlertCenter*) defaultCenter {
	static TKAlertCenter *defaultCenter = nil;
	if (!defaultCenter) {
		defaultCenter = [[TKAlertCenter alloc] init];
	}
	return defaultCenter;
}
- (id) init{
	if(!(self=[super init])) return nil;
	
	_alerts = [[NSMutableArray alloc] init];
	_alertView = [[TKAlertView alloc] init];
	_active = NO;
	
	
	_alertFrame = [UIApplication sharedApplication].keyWindow.bounds;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];

	return self;
}


#pragma mark Show Alert Message
- (void) showAlerts{
	
	if([_alerts count] < 1) {
		_active = NO;
		return;
	}
	
	_active = YES;
	
	_alertView.transform = CGAffineTransformIdentity;
	_alertView.alpha = 0;
	[[UIApplication sharedApplication].keyWindow addSubview:_alertView];

	
	NSArray *ar = [_alerts objectAtIndex:0];
	
	UIImage *img = nil;
	if([ar count] > 1) img = [[_alerts objectAtIndex:0] objectAtIndex:1];
	
	[_alertView setImage:img];

	if([ar count] > 0) [_alertView setMessageText:[[_alerts objectAtIndex:0] objectAtIndex:0]];
	
	
	
	_alertView.center = CGPointMake(_alertFrame.origin.x+_alertFrame.size.width/2, _alertFrame.origin.y+_alertFrame.size.height/2);
		
	
	CGRect rr = _alertView.frame;
	rr.origin.x = (int)rr.origin.x;
	rr.origin.y = (int)rr.origin.y;
	_alertView.frame = rr;
	
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat degrees = 0;
	if(o == UIInterfaceOrientationLandscapeLeft ) degrees = -90;
	else if(o == UIInterfaceOrientationLandscapeRight ) degrees = 90;
	else if(o == UIInterfaceOrientationPortraitUpsideDown) degrees = 180;
	_alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	//_alertView.transform = CGAffineTransformScale(_alertView.transform, 2, 2);
	
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStep2)];
	
	//_alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	//_alertView.frame = CGRectMake((int)_alertView.frame.origin.x, (int)_alertView.frame.origin.y, _alertView.frame.size.width, _alertView.frame.size.height);
	_alertView.alpha = 1;
	
	[UIView commitAnimations];
	
	
}
- (void) animationStep2{
	[UIView beginAnimations:nil context:nil];

	// depending on how many words are in the text
	// change the animation duration accordingly
	// avg person reads 200 words per minute
	NSArray * words = [[[_alerts objectAtIndex:0] objectAtIndex:0] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	double duration = MAX(((double)[words count]*60.0/200.0),1);
	
	[UIView setAnimationDelay:duration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationStep3)];
	
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat degrees = 0;
	if(o == UIInterfaceOrientationLandscapeLeft ) degrees = -90;
	else if(o == UIInterfaceOrientationLandscapeRight ) degrees = 90;
	else if(o == UIInterfaceOrientationPortraitUpsideDown) degrees = 180;
	_alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	_alertView.transform = CGAffineTransformScale(_alertView.transform, 0.5, 0.5);
	
	_alertView.alpha = 0;
	[UIView commitAnimations];
}
- (void) animationStep3{
	
	[_alertView removeFromSuperview];
	[_alerts removeObjectAtIndex:0];
	[self showAlerts];
	
}
- (void) postAlertWithMessage:(NSString*)message image:(UIImage*)image{
	[_alerts addObject:[NSArray arrayWithObjects:message,image,nil]];
	if(!_active) [self showAlerts];
}
- (void) postAlertWithMessage:(NSString*)message{
	[self postAlertWithMessage:message image:nil];
}


#pragma mark System Observation Changes
CGRect subtractRect(CGRect wf,CGRect kf);
CGRect subtractRect(CGRect wf,CGRect kf){
	
	
	
	if(!CGPointEqualToPoint(CGPointZero,kf.origin)){
		
		if(kf.origin.x>0) kf.size.width = kf.origin.x;
		if(kf.origin.y>0) kf.size.height = kf.origin.y;
		kf.origin = CGPointZero;
		
	}else{
		
		
		kf.origin.x = abs(kf.size.width - wf.size.width);
		kf.origin.y = abs(kf.size.height -  wf.size.height);
		
		
		if(kf.origin.x > 0){
			CGFloat temp = kf.origin.x;
			kf.origin.x = kf.size.width;
			kf.size.width = temp;
		}else if(kf.origin.y > 0){
			CGFloat temp = kf.origin.y;
			kf.origin.y = kf.size.height;
			kf.size.height = temp;
		}
		
	}
	return CGRectIntersection(wf, kf);
	
	
	
}
- (void) keyboardWillAppear:(NSNotification *)notification {
	
	NSDictionary *userInfo = [notification userInfo];
	NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect kf = [aValue CGRectValue];
	CGRect wf = [UIApplication sharedApplication].keyWindow.bounds;
    
	[UIView beginAnimations:nil context:nil];
	_alertFrame = subtractRect(wf,kf);
	_alertView.center = CGPointMake(_alertFrame.origin.x+_alertFrame.size.width/2, _alertFrame.origin.y+_alertFrame.size.height/2);

	[UIView commitAnimations];

}
- (void) keyboardWillDisappear:(NSNotification *) notification {
	_alertFrame = [UIApplication sharedApplication].keyWindow.bounds;

}
- (void) orientationWillChange:(NSNotification *) notification {
	
	NSDictionary *userInfo = [notification userInfo];
	NSNumber *v = [userInfo objectForKey:UIApplicationStatusBarOrientationUserInfoKey];
	UIInterfaceOrientation o = [v intValue];
	
	
	
	
	CGFloat degrees = 0;
	if(o == UIInterfaceOrientationLandscapeLeft ) degrees = -90;
	else if(o == UIInterfaceOrientationLandscapeRight ) degrees = 90;
	else if(o == UIInterfaceOrientationPortraitUpsideDown) degrees = 180;
	
	[UIView beginAnimations:nil context:nil];
	_alertView.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
	_alertView.frame = CGRectMake((int)_alertView.frame.origin.x, (int)_alertView.frame.origin.y, (int)_alertView.frame.size.width, (int)_alertView.frame.size.height);
	[UIView commitAnimations];
	
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////


@implementation UIView (TKCategory)



CGPoint demoLGStart(CGRect bounds);
CGPoint demoLGStart(CGRect bounds){
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.25);
};
CGPoint demoLGEnd(CGRect bounds);
CGPoint demoLGEnd(CGRect bounds){
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.75);
}
CGPoint demoRGCenter(CGRect bounds);
CGPoint demoRGCenter(CGRect bounds){
	return CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}
CGFloat demoRGInnerRadius(CGRect bounds);
CGFloat demoRGInnerRadius(CGRect bounds){
	CGFloat r = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
	return r * 0.125;
}


+ (void) drawGradientInRect:(CGRect)rect withColors:(NSArray*)colors{
	
	NSMutableArray *ar = [NSMutableArray array];
	for(UIColor *c in colors){
		[ar addObject:(id)c.CGColor];
	}
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	
	
	CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)ar, NULL);
	
    
	CGContextClipToRect(context, rect);
	
	CGPoint start = CGPointMake(0.0, 0.0);
	CGPoint end = CGPointMake(0.0, rect.size.height);
	
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);
	
}


+ (void) drawLinearGradientInRect:(CGRect)rect colors:(CGFloat[])colours{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colours, NULL, 2);
	CGColorSpaceRelease(rgb);
	CGPoint start, end;
	
	start = demoLGStart(rect);
	end = demoLGEnd(rect);
	
	
	
	CGContextClipToRect(context, rect);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(context);
	
}



+ (void) drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	
	CGRect rrect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
    
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFill);
}




+ (void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors {
	
	[UIView drawLineInRect:rect colors:colors width:1 cap:kCGLineCapButt];
	
}
+ (void) drawLineInRect:(CGRect)rect red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
	CGFloat colors[4];
	colors[0] = red;
	colors[1] = green;
	colors[2] = blue;
	colors[3] = alpha;
	[UIView drawLineInRect:rect colors:colors];
}
+ (void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors width:(CGFloat)lineWidth cap:(CGLineCap)cap{
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	
	CGContextSetRGBStrokeColor(context, colors[0], colors[1], colors[2], colors[3]);
	CGContextSetLineCap(context,cap);
	CGContextSetLineWidth(context, lineWidth);
    
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context,rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
	CGContextStrokePath(context);
	
	
	CGContextRestoreGState(context);
	
}



@end
