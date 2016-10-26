//
//  ViewController.m
//  Accelerometer
//
//  Created by Love on 9/27/16.
//  Copyright © 2016 Love. All rights reserved.
//

#import "ViewController.h"
@import CoreMotion;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *staticLabel;

@property (weak, nonatomic) IBOutlet UILabel *dynamicLabel;
@property (weak, nonatomic) IBOutlet UIButton *staticButton;
@property (weak, nonatomic) IBOutlet UIButton *dynamicStartButton;
@property (weak, nonatomic) IBOutlet UIButton *dynamicStopButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//CMMotion manager to handle all the sensor related requests;
@property(strong,nonatomic) CMMotionManager *manager;

@property(assign,nonatomic)double x,y,z;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.staticLabel.text = @"No data";
    self.dynamicLabel.text =@"No data";
    
    self.staticButton.enabled = NO;
    self.dynamicStartButton.enabled = NO;
    self.dynamicStopButton.enabled = NO;
    
    self.x = 0.0;
    self.y = 0.0;
    self.z = 0.0;
    
    self.imageView.image = [UIImage imageNamed:@"clownfish.jpg"];
    
    self.manager =[[CMMotionManager alloc] init];
    
    if(self.manager.accelerometerAvailable){
        self.staticButton.enabled = YES;
        self.dynamicStartButton.enabled = YES;
        
    }
    else{
        self.staticLabel.text = @"No Accelerometer Available";
        self.dynamicLabel.text = @"No Accelerometer Available";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)staticRequest:(id)sender {
    
    CMAccelerometerData *aData = self.manager.accelerometerData;
    if(aData!=nil){
        CMAcceleration acceleration = aData.acceleration;
        self.staticLabel.text =[NSString stringWithFormat:@"x:%f\n y:%f\nz:%f",acceleration.x,acceleration.y, acceleration.z];
        
    }
}
- (IBAction)dynamicStart:(id)sender {
    
    self.dynamicStartButton.enabled = NO;
    self.dynamicStopButton.enabled = YES;
    
    //how often we need the information
    self.manager.accelerometerUpdateInterval = 0.01;
    
    
    //weak reference to ourselves
    ViewController * __weak weakself = self;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    
    [self.manager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *data,NSError *error){
        //add task to the custom queue,the task is illustrated with a block
        [[NSOperationQueue mainQueue ] addOperationWithBlock: ^{
            
            
            
            //Update UI here
            
            
            
            
            
            
            double x =  data.acceleration.x;
            double y =  data.acceleration.y;
            double z =  data.acceleration.z;
            
            self.x = 0.9*self.x +.1*x;
            self.y = 0.9*self.y +0.1*y;
            self.z = 0.9*self.z +0.1*y;
            
            //1.update image
            double rotation = -atan2(self.x, -self.y);
           
            weakself.imageView.transform = CGAffineTransformMakeRotation(rotation);
            
            //2.update x,y and z
            weakself.dynamicLabel.text = [NSString stringWithFormat:@"x:%f/ny:%f\nz:%f",x,y,z];
        }];
        
    }];
    
}


- (IBAction)dynamicStop:(id)sender {
    
    [self.manager stopAccelerometerUpdates];
    self.dynamicStartButton.enabled= YES;
    self.dynamicStopButton.enabled = NO;
    
}


@end
