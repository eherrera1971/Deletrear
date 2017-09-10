//
//  DeletrearViewController.m
//  Deletrear
//
//  Created by Eduardo Herrera on 27-12-13.
//  Copyright (c) 2013 Obelix. All rights reserved.
//

#import "ViewController.h"
#import <iAd/iAd.h>


@interface DeletrearViewController ()

@property (nonatomic, strong) NSMutableArray *palabras;
@property (nonatomic) NSUInteger posicion;
@property (nonatomic, strong) NSMutableArray *colorTexto;

@end

@implementation DeletrearViewController


- (IBAction)spellingButton:(UIButton *)sender {
    [self spellThis:self.textoUsuario.text];
}

-(void) spellThis : (NSString *)palabra
{
    NSUInteger largo=palabra.length;
    for (NSUInteger j=0;j<largo;j++)
    {
        [self.colorTexto insertObject:palabra atIndex:j];
    }
    NSString *caracter;
    _textoUsuario.clearsOnInsertion=YES;
    for (NSUInteger i=0; i<largo;i++) {
        caracter = [palabra substringWithRange:NSMakeRange(i, 1)];
        caracter = [caracter lowercaseString];
        caracter = ([caracter  isEqual: @" "]) ? @"space" : caracter;
        caracter = ([caracter  isEqual: @"@"]) ? @"at" : caracter;
        caracter = ([caracter  isEqual: @"."]) ? @"dot" : caracter;
        caracter = ([caracter  isEqual: @","]) ? @"coma" : caracter;
        caracter = ([caracter  isEqual: @"-"]) ? @"dash" : caracter;
        NSString *potencialNumero = @"";
        NSString *potencialDigito = caracter;
        NSUInteger digitos=0;
        while ([self esNumero:potencialDigito]) {
            digitos++;
            potencialNumero = [NSString stringWithFormat:@"%@%@",potencialNumero,potencialDigito];
            caracter = potencialNumero;
            if (i+digitos+1>largo) {
                break;
            }
            potencialDigito = [palabra substringWithRange:NSMakeRange(i+digitos, 1)];
        }
        [self.colorTexto insertObject:caracter atIndex:i];
        if (potencialNumero.length>1) i = i + potencialNumero.length - 1;
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:caracter];
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-us"];
        [self.synthesizer speakUtterance:utterance];
    }
}

-(BOOL) esNumero : (NSString *)digito
{
    BOOL resultado = NO;
NSArray *numeros=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"."];
    for (NSString *secuencia in numeros) {
        if ([digito isEqualToString:secuencia]) {
            resultado = YES;
        }
    }
    return resultado;
}



- (IBAction)oneWordButton:(UIButton *)sender {
    NSUInteger cantidadDePalabras = [self.palabras count];
    NSUInteger index = (arc4random() % cantidadDePalabras);
    NSString *oneWord = self.palabras[index][@"unaPalabra"];
    self.textoUsuario.text=oneWord;
    [self spellThis:oneWord];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self spellThis:[textField text]];
    return YES;
}


- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    NSMutableAttributedString *tString = [[NSMutableAttributedString alloc] initWithString:_textoUsuario.text];
    
    NSString *temporal = self.colorTexto[_posicion];
    
    NSRange rango = NSMakeRange(_posicion, temporal.length);
    
    [tString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rango];
    
    NSLog(@"DATOS:posicion %lu  largoLectura %lu largoString %lu", (unsigned long)_posicion,(unsigned long)temporal.length, (unsigned long)tString.length);
    
    _posicion=_posicion+ temporal.length;
    
    NSUInteger largo = tString.length - _posicion;
    
    rango = NSMakeRange(_posicion, largo);
    
    [tString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rango];
    
    _textoUsuario.attributedText = tString;
    
}


- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance;
{
    if (_posicion == _textoUsuario.text.length) {
     _textoUsuario.textColor= [UIColor blackColor];
    _textoUsuario.text = _textoUsuario.text;
        _posicion=0;
        _textoUsuario.clearsOnInsertion=NO;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.posicion = 0;
    _sesion = [AVAudioSession sharedInstance];
    [_sesion setCategory:AVAudioSessionCategoryPlayback error:nil];
    _synthesizer = [[AVSpeechSynthesizer alloc] init];
    [_synthesizer setDelegate:self];
    _textoUsuario.delegate = self;
    [_textoUsuario becomeFirstResponder];
    
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"Palabras" ofType:@"plist"];
    self.palabras = [[NSMutableArray alloc] init];
    self.palabras= [NSMutableArray arrayWithContentsOfFile:plistCatPath];
    self.colorTexto = [[NSMutableArray alloc] init];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 320, 50)];
    [self.view addSubview:adView];
}





@end
