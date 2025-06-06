#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 1
#property  indicator_plots 1

#property indicator_color1 clrAqua
#property indicator_label1 "Main"
#property indicator_style1 STYLE_SOLID
#property indicator_type1 DRAW_LINE
#property indicator_width1 4

input ENUM_TIMEFRAMES InpTimeframe = PERIOD_H1;
input int  InpMAPeriod =24;
input ENUM_MA_METHOD InpMethod = MODE_SMA;
input ENUM_APPLIED_PRICE InpAppliedPrice = PRICE_CLOSE;

double BufferMA[];
int EMA_Handle;
double EMA_Values[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int OnInit(){
   if (InpTimeframe < PERIOD_CURRENT){
      PrintFormat("You must select a timeframe higher");
      return(INIT_PARAMETERS_INCORRECT);
   }
   EMA_Handle = iMA(_Symbol,InpTimeframe,InpMAPeriod,0,InpMethod,InpAppliedPrice);
   SetIndexBuffer(0,BufferMA);
   ArraySetAsSeries(EMA_Values,true);
   ArraySetAsSeries(BufferMA,true);
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
   datetime time0 = iTime(_Symbol,InpTimeframe,0);
   int limit = iBarShift(_Symbol,PERIOD_CURRENT,time0);
   if (prev_calculated == 0) limit = rates_total-1;
   
   for (int i = limit ; i >=0;i--){
      double maTimeframe[];
      datetime timei = iTime(_Symbol,PERIOD_CURRENT,i);
      int index = iBarShift(_Symbol,InpTimeframe,timei);
      if (CopyBuffer(EMA_Handle,0,index,1,maTimeframe) == -1) return 0;
      BufferMA[i] = maTimeframe[0];
   }
   
   return(rates_total);
  }
