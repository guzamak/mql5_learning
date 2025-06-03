#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

int fast_ema_handle;
int bb_handle;
double ema_value[];
double upper[], middle[], lower[];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   fast_ema_handle = iMA(_Symbol,PERIOD_CURRENT,14,0,MODE_EMA,PRICE_CLOSE);
   bb_handle = iBands(_Symbol,PERIOD_CURRENT,20,0,2.0,PRICE_CLOSE);
   ArraySetAsSeries(ema_value,true);
   ArraySetAsSeries(upper,true);
   ArraySetAsSeries(middle,true);
   ArraySetAsSeries(lower,true);
   return(INIT_SUCCEEDED);
}
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){

}
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   CopyBuffer(fast_ema_handle,0,0,2,ema_value);
   CopyBuffer(bb_handle, 1, 0, 2, upper);
   CopyBuffer(bb_handle, 0, 0, 2, middle);
   CopyBuffer(bb_handle, 2, 0, 2, lower);
   int barIndex = 0;
   Comment("Fast EMA BAR 1 : ",DoubleToString(ema_value[barIndex],Digits()), " | UpperBand : " , DoubleToString(upper[barIndex],Digits()), " | middleBand : " , DoubleToString(middle[barIndex],Digits()), " | lowerBand : " , DoubleToString(lower[barIndex],Digits()));
}
