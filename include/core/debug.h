#ifndef DEBUG_H_INCLUDED
#define DEBUG_H_INCLUDED

// ----------------------------------------------------------------
// Debug printing to the Output Window
// D1..D4       print values
// DVAR1..DVAR4 print variable names followed by their values
// Both compile to nothing unless DEBUG is defined in build.4dm
// ----------------------------------------------------------------

#ifdef DEBUG

#define D1(I01)                   Print("DEBUG | "); Print(I01); Print();
#define D2(I01, I02)              Print("DEBUG | "); Print(I01); Print(" "); Print(I02); Print();
#define D3(I01, I02, I03)         Print("DEBUG | "); Print(I01); Print(" "); Print(I02); Print(" "); Print(I03); Print();
#define D4(I01, I02, I03, I04)    Print("DEBUG | "); Print(I01); Print(" "); Print(I02); Print(" "); Print(I03); Print(" "); Print(I04); Print();

#define DVAR1(I01)                Print("DEBUG | "); Print(#I01); Print(" = "); Print(I01); Print();
#define DVAR2(I01, I02)           DVAR1(I01) DVAR1(I02)
#define DVAR3(I01, I02, I03)      DVAR1(I01) DVAR1(I02) DVAR1(I03)
#define DVAR4(I01, I02, I03, I04) DVAR1(I01) DVAR1(I02) DVAR1(I03) DVAR1(I04)

#else

#define D1(I01)
#define D2(I01, I02)
#define D3(I01, I02, I03)
#define D4(I01, I02, I03, I04)

#define DVAR1(I01)
#define DVAR2(I01, I02)
#define DVAR3(I01, I02, I03)
#define DVAR4(I01, I02, I03, I04)

#endif

#endif
