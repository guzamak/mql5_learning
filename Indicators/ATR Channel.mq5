#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
// use when want indicator in separate_window
//#property indicator_separate_window
// amout of data and plot (upper lower midder)
#property  indicator_buffers 3;
#property indicator_plots 3;
//style of indicator
//Main line
#property indicator_color1 clrGreen;
#property indicator_label1 "Main";
#property indicator_style1 STYLE_SOLID;
#property indicator_type1 DRAW_LINE;
#property indicator_width1 3;
// Upper line
#property indicator_color2 clrWhite;
#property indicator_label2 "Upper";
#property indicator_style2 STYLE_DOT;
#property indicator_type2 DRAW_LINE;
#property indicator_width2 1;
// Lower line
#property indicator_color3 clrYellow;
#property indicator_label3 "Lower";
#property indicator_style3 STYLE_DOT;
#property indicator_type3 DRAW_LINE;
#property indicator_width3 1;

//Input
input int InpMABars = 10;
input ENUM_MA_METHOD InpMAMethod = MODE_SMA;
input ENUM_APPLIED_PRICE InpMAAppliedPrice = PRICE_CLOSE;

input int InpATRBars = 10;
input double InpATRFactor = 3.0;

//indicator buffer[]
double BufferMain[];
double BufferUpper[];
double BufferLower[];

// indy handle
int HandleMa;
int HandleATR;
double ValuesMA[];
double ValuesATR[];



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
   SetIndexBuffer(BASE_LINE,BufferMain);
   SetIndexBuffer(UPPER_BAND,BufferUpper);
   SetIndexBuffer(LOWER_BAND,BufferLower);
   
   ArraySetAsSeries(BufferMain,true);
   ArraySetAsSeries(BufferUpper,true);
   ArraySetAsSeries(BufferLower,true);
   HandleMa = iMA(_Symbol,PERIOD_CURRENT,InpMABars,0,InpMAMethod,InpMAAppliedPrice);
   HandleATR = iATR(_Symbol,PERIOD_CURRENT,InpATRBars);
   ArraySetAsSeries(ValuesMA,true);
   ArraySetAsSeries(ValuesATR,true);
   return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason){
   IndicatorRelease( HandleMa );
   IndicatorRelease( HandleATR );
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, //No of bar that has avaiable in the current timeframe
                const int prev_calculated, // return  from last call
                const datetime &time[], //Array of bar start times
                const double &open[], // Array of open price 
                const double &high[], // Array of High price
                const double &low[], // Array of Low price
                const double &close[], //Array of Close price
                const long &tick_volume[], // Array of Tick Volume
                const long &volume[], // Array of Real volume
                const int &spread[]) //Array of spread (Ask - Bid) / Point
{
   int count = rates_total-prev_calculated;
   if (prev_calculated > 0) count++;
   
   if (CopyBuffer(HandleMa,0,0,count,ValuesMA) < count) return(0);
   if (CopyBuffer(HandleATR,0,0,count,ValuesATR) < count) return(0);
   
   for (int i = count-1; i >= 0;i--){
      BufferMain[i] = ValuesMA[i];
      double channelWidth = InpATRFactor * ValuesATR[i];
      BufferUpper[i] = BufferMain[i] + channelWidth;
      BufferLower[i] = BufferMain[i] - channelWidth;
      
   }
   
   return(rates_total);
}
