//---ea เปิดปิดตามเวลาเเละปิดใน 1 ชม 
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>
//+------------------------------------------------------------------+
//| variables                                 |
//+------------------------------------------------------------------+
input int openHour;
input int closeHour;
bool isTradeOpen = false;
CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int OnInit(){
   if (openHour == closeHour){
      Alert("close and open shouldnt be same");
      return(INIT_PARAMETERS_INCORRECT);
   };
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
      //call every time price change
      
      //get current time
      MqlDateTime timeNow;
      TimeToStruct(TimeCurrent(),timeNow);
      
      //check for trade open 
      if (openHour == timeNow.hour && !isTradeOpen){
         //position open
         trade.PositionOpen( _Symbol,ORDER_TYPE_BUY,1,SymbolInfoDouble(_Symbol,SYMBOL_ASK),0,0);
         isTradeOpen = true;
      }
      
      if (closeHour == timeNow.hour && isTradeOpen){
         trade.PositionClose(_Symbol);
         isTradeOpen = false;
      }
  }