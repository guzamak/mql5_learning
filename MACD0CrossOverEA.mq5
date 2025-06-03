#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
input int sl_point = 500;
input int tp_point = 1000;
input double lotsize = 0.01;
input int macd_fast = 12;
input int macd_slow = 26;
input int signal = 9;
CTrade trade;



int macd_handle;
double macd_buffer[],signal_buffer[];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   ArraySetAsSeries(macd_buffer,true);
   ArraySetAsSeries(signal_buffer,true);
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
   macd_handle = iMACD(_Symbol,PERIOD_CURRENT,macd_fast,macd_slow,signal,PRICE_CLOSE);
   CopyBuffer(macd_handle,0,0,2,macd_buffer);
   CopyBuffer(macd_handle,1,0,2,signal_buffer);
   
   if(PositionsTotal() == 0){
      if(macd_buffer[0] > 0 && macd_buffer[1] <= 0 ){
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double sl = ask - sl_point * SymbolInfoDouble(_Symbol,SYMBOL_POINT);
         double tp = ask + tp_point * SymbolInfoDouble(_Symbol,SYMBOL_POINT);
         trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,lotsize,ask,sl,tp,"Cross 0");
         //openTimeBuy = iTime(_Symbol,PERIOD_CURRENT,0);
      }
      else if (macd_buffer[0] < 0 && macd_buffer[1] >= 0 ){
         double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         double sl = bid + sl_point * SymbolInfoDouble(_Symbol,SYMBOL_POINT);
         double tp = bid - tp_point * SymbolInfoDouble(_Symbol,SYMBOL_POINT);
         trade.PositionOpen(_Symbol,ORDER_TYPE_SELL,lotsize,bid,sl,tp,"Cross EA");
         //openTimeBuy = iTime(_Symbol,PERIOD_CURRENT,0);
      }else{
         Comment("No signal");
      }
   
   }else{
      Comment("Maximun Order Reach");
   }
}
