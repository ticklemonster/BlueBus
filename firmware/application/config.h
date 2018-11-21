// Configure the system

// FSEC
#pragma config BWRP = OFF            // Boot Segment may be written
#pragma config BSS = DISABLED        // Boot Segment Code-Protect Level bits (No Protection (other than BWRP))
#pragma config BSEN = OFF            // Boot Segment Control bit (No Boot Segment)
#pragma config GWRP = OFF            // General Segment Write-Protect bit (General Segment may be written)
#pragma config GSS = DISABLED        // General Segment Code-Protect Level bits (No Protection (other than GWRP))
#pragma config CWRP = OFF            // Configuration Segment Write-Protect bit (Configuration Segment may be written)
#pragma config CSS = DISABLED        // Configuration Segment Code-Protect Level bits (No Protection (other than CWRP))
#pragma config AIVTDIS = OFF         // Alternate Interrupt Vector Table bit (Disabled AIVT)

// FBSLIM
#pragma config BSLIM = 0x1FFF        // Boot Segment Flash Page Address Limit bits (Boot Segment Flash page address  limit)

// FOSCSEL
#pragma config FNOSC = FRCPLL        // Oscillator Source Selection (FRC with PLL module)
#pragma config PLLMODE = PLL96DIV2   // PLL Mode Selection (96 MHz PLL. (8 MHz input))
#pragma config IESO = OFF            // Two-speed Oscillator Start-up Enable bit (Start up with user-selected oscillator source)

// FOSC
#pragma config POSCMD = NONE         // Primary Oscillator Mode Select bits (None)
#pragma config OSCIOFCN = OFF        // OSC2 Pin Function bit (OSC2 is clock output)
#pragma config SOSCSEL = OFF         // SOSC Power Selection Configuration bits (SOSC is not used)
#pragma config PLLSS = PLL_FRC       // PLL Secondary Selection Configuration bit (PLL is fed by the FRC)
#pragma config IOL1WAY = ON          // Peripheral pin select configuration bit (Allow many reconfigurations)
#pragma config FCKSM = CSDCMD        // Clock Switching Mode bits (Both Clock switching and Fail-safe Clock Monitor are disabled)


// FWDT
#pragma config WDTPS = PS32768       // Watchdog Timer Postscaler bits (1:32,768)
#pragma config FWPSA = PR128         // Watchdog Timer Prescaler bit (1:128)
#pragma config FWDTEN = OFF          // Watchdog Timer Enable bits (WDT and SWDTEN disabled)
#pragma config WINDIS = OFF          // Watchdog Timer Window Enable bit (Watchdog Timer in Non-Window mode)
#pragma config WDTWIN = WIN25        // Watchdog Timer Window Select bits (WDT Window is 25% of WDT period)
#pragma config WDTCMX = WDTCLK       // WDT MUX Source Select bits (WDT clock source is determined by the WDTCLK Configuration bits)
#pragma config WDTCLK = LPRC         // WDT Clock Source Select bits (WDT uses LPRC)

// FPOR
#pragma config BOREN = ON            // Brown Out Enable bit (Brown Out Enable Bit)
#pragma config LPCFG = ON            // Low power regulator control (Retention Sleep controlled by RETEN)
#pragma config DNVPEN = ENABLE       // Downside Voltage Protection Enable bit (Downside protection enabled using ZPBOR when BOR is inactive)

// FICD
#pragma config ICS = PGD1            // ICD Communication Channel Select bits (Communicate on PGEC1 and PGED1)
#pragma config JTAGEN = OFF          // JTAG Enable bit (JTAG is disabled)
#pragma config BTSWP = OFF           // BOOTSWP Disable (BOOTSWP instruction disabled)

// FDEVOPT1
#pragma config ALTCMPI = DISABLE     // Alternate Comparator Input Enable bit (C1INC, C2INC, and C3INC are on their standard pin locations)
#pragma config TMPRPIN = OFF         // Tamper Pin Enable bit (TMPRN pin function is disabled)
#pragma config SOSCHP = OFF          // SOSC High Power Enable bit (valid only when SOSCSEL = 1 (Disable SOSC high power mode)
#pragma config ALTVREF = ALTVREFDIS  // Alternate Voltage Reference Location Enable bit (VREF+ and CVREF+ on RB0, VREF- and CVREF- on RB1)

// FBOOT
#pragma config BTMODE = SINGLE