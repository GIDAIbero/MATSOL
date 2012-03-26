/*
 *  MATSOLDefines.h
 *  MATSOL
 *
 *  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 13/06/10.
 *  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
 *	com.yourcompany.${PRODUCT_NAME:rfc1034identifier}
 *	eetoolkit.ie.uia.mx
 */
#define NO_DEBUG
#define NO_DEBUG_INTERFACE
#define NO_VERBOSE

#define MATSOL_VERSION  @"1.1dev"
#define MATSOL_BUILD    @"a8c03a5"
//git log --pretty=format:'%h' -n 1

//Number of pages in the scroll view controller, when just a single
//page is requested, the page controller won't appear at the bottom
#define NUMBER_OF_MENU_PAGES 1

//How should the navigation be from text field to text field
#define MOVE_HORIZONTAL

//Testing the drawing algorithm for the resistor calculator
#define NO_ALGORITHM_TEST

//The color of the fonts to be used in the Color Decoder other option WHITE_FONTS
#define BLACK_FONTS

//The only custom color of the application
#define darkGrayMATSOL  colorWithRed:.161 green:.161 blue:0.161 alpha:1.0