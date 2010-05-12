//
//  qcscreenbacklightPlugIn.h
//  qcscreenbacklight
//
//  Created by Geordie Millar on 20/03/08.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface qcscreenbacklightPlugIn : QCPlugIn
{
}

/*
Declare here the Obj-C 2.0 properties to be used as input and output ports for the plug-in e.g.
@property double inputFoo;
@property(assign) NSString* outputBar;
You can access their values in the appropriate plug-in methods using self.inputFoo or self.inputBar
*/

  CGDisplayErr      dErr;
  io_service_t      service;
  CGDirectDisplayID targetDisplay;
  CFStringRef key;

@property double inputBrightness;

@end
