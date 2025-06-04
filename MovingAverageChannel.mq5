#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>

input double lotsize = 0.01;
input int ma_period = 50;
input int ma_mode = 0;
input int magicNo = 888;
int ma_H_handle,ma_L_handle;
double ma_H_buffer[],ma_L_buffer[];
int ma_200;
double ma_200_buffer[];
MqlRates bar[];
CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   ma_H_handle = iMA(_Symbol,PERIOD_CURRENT,ma_period,0,MODE_SMA,PRICE_HIGH);
   ma_L_handle = iMA(_Symbol,PERIOD_CURRENT,ma_period,0,MODE_SMA,PRICE_LOW);
   ma_200 = iMA(_Symbol,PERIOD_CURRENT,200,0,MODE_SMA,PRICE_CLOSE);
   ArraySetAsSeries(ma_H_buffer,true);
   ArraySetAsSeries(ma_L_buffer,true);
   ArraySetAsSeries(ma_200_buffer,true);
   ArraySetAsSeries(bar,true);
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
   CopyBuffer(ma_H_handle,0,0,3,ma_H_buffer);
   CopyBuffer(ma_L_handle,0,0,3,ma_L_buffer);
   CopyBuffer(ma_200,0,0,3,ma_200_buffer);
   CopyRates(_Symbol,PERIOD_CURRENT,0,3,bar);
   if(PositionsTotal() == 0){
      if(bar[2].close <= ma_H_buffer[2] && bar[1].close > ma_H_buffer[1] && bar[1].close > ma_200_buffer[1] ){
         double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double tp = 0; //not set tp
         double sl = ma_L_buffer[1];
         trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,lotsize,ask,sl,tp,"Cross 0");
      }
      else if (bar[2].close >= ma_L_buffer[2] && bar[1].close < ma_L_buffer[1] && bar[1].close < ma_200_buffer[1]){
         double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
         double tp = 0;
         double sl = ma_H_buffer[1];
         trade.PositionOpen(_Symbol,ORDER_TYPE_SELL,lotsize,bid,sl,tp,"Cross EA");
      }else{
         Comment("No signal");
      }
   
   }else{
      for(int i = 0; i < PositionsTotal(); i++){
         if(PositionGetSymbol(i) == _Symbol){
            ulong ticket = PositionGetTicket(i);
            double current_sl = NormalizeDouble(PositionGetDouble(POSITION_SL), _Digits);

            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY){
               double new_sl = NormalizeDouble(ma_L_buffer[1], _Digits);
               if(new_sl > current_sl){  // only if better SL (higher)
                  trade.PositionModify(ticket, new_sl, 0);
               }
            }
            else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL){
               double new_sl = NormalizeDouble(ma_H_buffer[1], _Digits);
               if(new_sl < current_sl){ 
                  trade.PositionModify(ticket, new_sl, 0);
               }
            }
         }
        }
   }
}
