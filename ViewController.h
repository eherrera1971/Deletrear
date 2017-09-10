//
//  DeletrearViewController.h
//  Deletrear
//
//  Created by Eduardo Herrera on 27-12-13.
//  Copyright (c) 2013 Obelix. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface DeletrearViewController : UIViewController
<AVSpeechSynthesizerDelegate, UITextFieldDelegate >;

//Interfaz de usuario
@property (strong, nonatomic) IBOutlet UITextField *textoUsuario;

//Sound

@property (strong, nonatomic) AVAudioSession *sesion;

@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@end


/*
 
 -(IBAction)talk:(id)sender;
 
*/