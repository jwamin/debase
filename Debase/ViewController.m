//
//  ViewController.m
//  Debase
//
//  Created by Joss Manger on 4/25/20.
//  Copyright © 2020 Joss Manger. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize value;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setTitle:@"Debase"];
  
  NSURL *imageTextFileUrl = [[NSBundle mainBundle] URLForResource:@"img" withExtension:@"txt"];
  
  [_textInputArea setString:[NSString stringWithContentsOfURL:imageTextFileUrl encoding:NSUTF8StringEncoding error:nil]];

  [self updateBase64String];
  [self handleStringForImage];

}

-(void)handleStringForImage{
  
  NSData *data = [[NSData alloc] initWithBase64EncodedString:value options:NSDataBase64DecodingIgnoreUnknownCharacters];
  
  NSImage *img = [[NSImage alloc]initWithData:data];
  
  if (img == nil) {
    img = [NSImage imageNamed:NSImageNameCaution];
  }
  
  [_imageView setImage:img];
  
}

-(void) updateBase64String {
  
  NSString *str = [_textInputArea string];
  value = str;
  
}

- (void)textDidChange:(NSNotification *)notification{
 
  [self updateBase64String];
  [self handleStringForImage];
  
}

@end
