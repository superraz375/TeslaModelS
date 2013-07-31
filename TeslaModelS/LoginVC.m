//
//  LoginVC.m
//  TeslaModelS
//
//  Created by Raz Friman on 7/16/13.
//  Copyright (c) 2013 Raz Friman. All rights reserved.
//

#import "LoginVC.h"
#import "TeslaClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPRequestOperation.h"
#import "SVProgressHUD.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_emailTextField becomeFirstResponder];
    
    [self loadCookies];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _emailTextField)
    {
        [_passwordTextField becomeFirstResponder];
    }
    else if (textField == _passwordTextField)
    {
        [_passwordTextField resignFirstResponder];

        [self login];
    }
    
    return YES;
}


- (void)saveCookies{
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    
}

- (void)loadCookies{
    
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
    
}

- (void) login
{
    
    if ([_emailTextField.text isEqualToString:@""])
    {
        UIAlertView* alertview = [ [UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid email and try again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil , nil];
        
        [alertview show];
        return;
    }
    
    if ([_emailTextField.text isEqualToString:@""])
    {
        UIAlertView* alertview = [ [UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a password and try again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil , nil];
        
        [alertview show];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    TeslaClient* client = [TeslaClient sharedClient];
    
    id params = @{
                   @"user_session[email]": _emailTextField.text,
                   @"user_session[password]": _passwordTextField.text
                   };
        
    [client postPath:@"/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [SVProgressHUD dismiss];
        
        [self saveCookies];
        
        if ([operation.responseString rangeOfString:@"You do not have access"].location != NSNotFound)
        {
            NSLog(@"Error. Not logged in.");
            
            UIAlertView* alertview = [ [UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid email/password.\r\nPlease try again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil , nil];
            
            [alertview show];
            
        }
        
        [self getVehicles];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        [SVProgressHUD dismiss];
        
        NSLog(@"Login Error: %@", error);
        
    }];
}

- (void) getVehicles
{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    TeslaClient* client = [TeslaClient sharedClient];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"/vehicles" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [SVProgressHUD dismiss];
            
            NSArray *vehicles = (NSArray*) JSON;
            
            if ([vehicles count] == 0)
            {
                UIAlertView* alertview = [ [UIAlertView alloc] initWithTitle:@"Error" message:@"There are no linked vehicles.\r\nYour car may not be ready yet." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil , nil];
                
                [alertview show];
                
                return;
            }
            else if ([vehicles count] == 1)
            {
                NSDictionary* carAttributes = [vehicles objectAtIndex:0];

                [client.teslaVehicleModel load:carAttributes];
                
                // Begin loading and updating all of the Models
                [client startTimer];
                
                [self performSegueWithIdentifier:@"tabSegue" sender:self];
            }
            else if ([vehicles count] > 1)
            {
                [self performSegueWithIdentifier:@"SelectCarSegue" sender:self];

            } 
            
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"Error: Cannot load vehicles"];
            
            NSLog(@"Load Vehicle Error: %@", error);
        }];
    
    [operation start];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([segue.identifier isEqualToString:@"tabSegue"]) {
        //[segue.destinationViewController setHappiness:100];
    } else if ([segue.identifier isEqualToString:@"SelectCarSegue"]) {
        //[segue.destinationViewController setHappiness:0];
    }
}




@end
