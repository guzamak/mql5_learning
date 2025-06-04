//+------------------------------------------------------------------+
//|                                       PositionSizeCalculator.mq5 |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window

input double MoneyRisk = 100;
input double EntryPrice = 1.18888;
input double SLPrice = 1.155555;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
  double SymbolTickValue = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
  double SL_Point = MathAbs(EntryPrice - SLPrice)/Point();
  double _1_Lot_MoneyRisk = SL_Point * SymbolTickValue;
  double PositionSize = MoneyRisk/_1_Lot_MoneyRisk;
  
  
  Comment("TickValue : ",SymbolTickValue
           ,"\nPoint : ", Point()
           ,"\nEntryPrice : ", EntryPrice
           ,"\nSLPrice : ", SLPrice
           ,"\nSL_Point : ", SL_Point
           ,"\n_1_Lot_MoneyRisk : ",_1_Lot_MoneyRisk
           ,"\nPositionSize : ",DoubleToString(PositionSize,3));

   return(rates_total);
  }
