//
//  ViewController.m
//  Debase
//
//  Created by Joss Manger on 4/25/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewWithDragging.h"

@implementation ViewController

@synthesize value;
@synthesize attrValue;

+(NSFont*) standardFont {
  return [NSFont fontWithName:@"Andale Mono" size:27.0];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setTitle:@"Debase"];
  
  NSURL *imageTextFileUrl = [[NSBundle mainBundle] URLForResource:@"img" withExtension:@"txt"];
  
  [_textInputArea setFont:[ViewController standardFont]];
  
  [_textInputArea setString:[NSString stringWithContentsOfURL:imageTextFileUrl encoding:NSUTF8StringEncoding error:nil]];

  [self updateBase64String];
  [self handleStringForImage];
  [self convertStringToAttributedColorString];

}

-(void)handleStringForImage{
  
  NSData *data = [[NSData alloc] initWithBase64EncodedString:value options:NSDataBase64DecodingIgnoreUnknownCharacters];
  NSImage *img = [[NSImage alloc]initWithData:data];
  
  //Provide Default image
  if (img == nil) {
    img = [NSImage imageNamed:NSImageNameCaution];
  }
  
  [_imageView setImage:img];
  
  NSString *prefix = [value substringToIndex:5];
  
  NSDictionary *dictionary = @{
    @"imgData": data,
    @"imgName": prefix
  };

  [(ImageViewWithDragging*)_imageView setProviderData:dictionary];
  
}

-(void) convertStringToAttributedColorString{
  
  ViewController* __weak weakSelf = self;
  dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    
    NSUInteger length = weakSelf.value.length;
  unichar buffer[length+1];
  // do not use @selector(getCharacters:) it's unsafe
  [weakSelf.value getCharacters:buffer range:NSMakeRange(0, length)];

  NSMutableAttributedString *mut = [[NSMutableAttributedString alloc] initWithString:weakSelf.value];
  
  //O(n) :(
  for(int i = 0; i < length; i++)
  {
    NSLog(@"%C", buffer[i]);
    NSRange charRange = NSMakeRange(i, 1);
    if([[NSCharacterSet letterCharacterSet] characterIsMember:buffer[i]]){
      NSLog(@"letter");
      [mut addAttribute:NSForegroundColorAttributeName value:[NSColor systemRedColor] range:charRange];
    } else if ([[NSCharacterSet symbolCharacterSet] characterIsMember:buffer[i]]){
      NSLog(@"symbol");
      [mut addAttribute:NSForegroundColorAttributeName value:[NSColor systemTealColor] range:charRange];
    } else if ([[NSCharacterSet alphanumericCharacterSet] characterIsMember:buffer[i]]){
      NSLog(@"number");
      [mut addAttribute:NSForegroundColorAttributeName value:[NSColor systemPurpleColor] range:charRange];
    } else if ([[NSCharacterSet punctuationCharacterSet] characterIsMember:buffer[i]]){
      NSLog(@"punctuation");
      [mut addAttribute:NSForegroundColorAttributeName value:[NSColor systemIndigoColor] range:charRange];
    }
    
  }
  [mut addAttribute:NSFontAttributeName value:[ViewController standardFont] range:NSMakeRange(0, length)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [[weakSelf.textInputArea textStorage] setAttributedString:mut];
    });
 
  });
}

-(void) updateBase64String {
  
  NSString *str = [_textInputArea string];
  value = str;
  
}

#pragma mark - Actions

- (void)textDidChange:(NSNotification *)notification{
 
  [self updateBase64String];
  [self handleStringForImage];
  [self convertStringToAttributedColorString];
  
}

@end
