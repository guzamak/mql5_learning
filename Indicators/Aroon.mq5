#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots 2

#property indicator_type1 DRAW_LINE
#property indicator_color1 clrYellow
#property indicator_style1 STYLE_SOLID
#property indicator_width1 3
#property indicator_label1 "Up"

#property indicator_type2 DRAW_LINE
#property indicator_color2 clrRed
#property indicator_style2 STYLE_SOLID
#property indicator_width2 3
#property indicator_label2 "Down"

#property indicator_level1 70.0
#property indicator_level2 50.0
#property indicator_level3 30.0
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_DOT

input int InpPeriod = 25;
input int InpShift = 0;

double BufferUp[];
double BufferDown[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0,BufferUp,INDICATOR_DATA);
   PlotIndexSetInteger(0,PLOT_SHIFT,InpShift);
   PlotIndexSetInteger(0, PLOT_DRAW_BEGIN,InpPeriod);
   ArraySetAsSeries(BufferUp,true);
   
   SetIndexBuffer(1,BufferDown,INDICATOR_DATA);
   PlotIndexSetInteger(1,PLOT_SHIFT,InpShift);
   PlotIndexSetInteger(1,PLOT_DRAW_BEGIN,InpPeriod);
   ArraySetAsSeries(BufferDown,true);
   
   string indicatorNamer = StringFormat("Aroon {%i,%i}",InpPeriod,InpShift);
   IndicatorSetString(INDICATOR_SHORTNAME,indicatorNamer);
   IndicatorSetInteger(INDICATOR_DIGITS,0);
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
   if (rates_total < InpPeriod - 1) return(0);
   
   int count = rates_total - prev_calculated;
   if (prev_calculated > 0) count++;
   if (count > (rates_total - InpPeriod+1)) count = (rates_total-InpPeriod+1);
   for (int i = count -1;i >=0;i--){
      int highest = iHighest(_Symbol,PERIOD_CURRENT,MODE_HIGH,InpPeriod,i); 
      int lowest = iLowest(_Symbol,PERIOD_CURRENT,MODE_LOW,InpPeriod,i);
   
      BufferUp[i] = (InpPeriod- (highest - i)) * 100 /InpPeriod;
      BufferDown[i] = (InpPeriod- (lowest - i)) * 100 /InpPeriod;
   }
   
   return(rates_total);
  }
