#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
//+------------------------------------------------------------------+
//| variables                                 |
//+------------------------------------------------------------------+
input int InpFastPeriod = 14;
input int InpSlowPeriod = 21;
input int InpStoploss = 100;
input int InpTakeprofit = 200;
//+------------------------------------------------------------------+
//|  Global variables                                   |
//+------------------------------------------------------------------+
int fastHandle;
int slowHandle;
//store data of ema
double fastBuffer[];
double slowBuffer[];
datetime openTimeBuy = 0;
datetime openTimeSell = 0;
CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   if (InpStoploss <= 0){
      Alert("Stoploss <= 0");
      return (INIT_PARAMETERS_INCORRECT);
   }
    if (InpTakeprofit <= 0){
      Alert("Takeprofit <= 0");
      return (INIT_PARAMETERS_INCORRECT);
   }
   if (InpFastPeriod <= 0){
      Alert("FastPeriod <= 0");
      return (INIT_PARAMETERS_INCORRECT);
   }
   
   if (InpSlowPeriod <= 0){
      Alert("SlowPeriod <= 0");
      return (INIT_PARAMETERS_INCORRECT);
   }
   
   if (InpFastPeriod >= InpSlowPeriod){
      Alert("FastPeriod >= SlowPeriod");
      return (INIT_PARAMETERS_INCORRECT);
   }
   //create handles
   fastHandle = iMA(_Symbol,PERIOD_CURRENT,InpFastPeriod,0,MODE_EMA,PRICE_CLOSE);
   if (fastHandle == INVALID_HANDLE){
      Alert("Failed to create fast handle");
      return (INIT_FAILED);
   }
   slowHandle = iMA(_Symbol,PERIOD_CURRENT,InpSlowPeriod,0,MODE_EMA,PRICE_CLOSE);
   if (slowHandle == INVALID_HANDLE){
      Alert("Failed to create slow handle");
      return (INIT_FAILED);
   }
   ArraySetAsSeries(fastBuffer,true);
   ArraySetAsSeries(slowBuffer,true);
   return(INIT_SUCCEEDED);
  }
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){

   if (fastHandle != INVALID_HANDLE){IndicatorRelease(fastHandle);}
   if (slowHandle != INVALID_HANDLE){IndicatorRelease(slowHandle);}
}
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   int values = CopyBuffer(fastHandle,0,0,2,fastBuffer); 
   if (values != 2){
      Print("Not enough data for fast moving averrage");
      return;
   }
   values = CopyBuffer(slowHandle,0,0,2,slowBuffer); 
   if (values != 2){
      Print("Not enough data for slow moving averrage");
      return;
   }
   
   Comment(
   //[0] current [1] pervios
   "fast[0]", fastBuffer[0],"\n",
   "fast[1]", fastBuffer[1],"\n",
   "slow[0]", slowBuffer[0],"\n",
   "slow[1]", slowBuffer[1]
   );
   
   //buy
   if (fastBuffer[1] <= slowBuffer[1] && fastBuffer[0] > slowBuffer[0] && openTimeBuy != iTime(_Symbol,PERIOD_CURRENT,0)){
      double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      double sl = ask - InpStoploss * SymbolInfoDouble(_Symbol,SYMBOL_POINT);
      double tp = ask + InpTakeprofit * SymbolInfoDouble(_Symbol,SYMBOL_POINT);
      trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,1,ask,sl,tp,"Cross EA");
      openTimeBuy = iTime(_Symbol,PERIOD_CURRENT,0);
   }
   //sell
   if (fastBuffer[1] >= slowBuffer[1] && fastBuffer[0] < slowBuffer[0] && openTimeSell != iTime(_Symbol,PERIOD_CURRENT,0)){
      double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double sl = bid + InpStoploss * SymbolInfoDouble(_Symbol,SYMBOL_POINT);
      double tp = bid - InpTakeprofit * SymbolInfoDouble(_Symbol,SYMBOL_POINT);
      trade.PositionOpen(_Symbol,ORDER_TYPE_SELL,1,bid,sl,tp,"Cross EA");
      openTimeSell = iTime(_Symbol,PERIOD_CURRENT,0);
   }
 }

