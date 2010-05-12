//
//  QCbacklightPlugIn.h
//  QCbacklight
//
//  Created by Geordie Millar on 19/03/08.
//  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface QCbacklightPlugIn : QCPlugIn
{
}

/*
Declare here the Obj-C 2.0 properties to be used as input and output ports for the plug-in e.g.
@property double inputFoo;
@property(assign) NSString* outputBar;
You can access their values in the appropriate plug-in methods using self.inputFoo or self.inputBar
*/

kern_return_t		kr;
SInt32        in_brightness, out_brightness;
static io_connect_t dataPort = 0;
io_service_t      serviceObject;
kern_return_t kr;

@property double inputValue;

@end
