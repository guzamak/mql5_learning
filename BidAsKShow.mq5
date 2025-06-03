#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

MqlRates bar[];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
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
    double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    //---0-9
    CopyRates(_Symbol,PERIOD_CURRENT,0,10,bar);
    Comment("Bid: ", bid, " | Ask: ", ask);
    int barIndex = 1;
    Comment("bar 0 open:",bar[barIndex].open,"| High:",bar[barIndex].high,":| Low:",bar[barIndex].low," | Close:",bar[0].close);
    string pair = "EURUSDm";
    ENUM_TIMEFRAMES check_Period = PERIOD_H1;
    Comment(iOpen(pair,check_Period,barIndex),iHigh(pair,check_Period,barIndex),iLow(pair,check_Period,barIndex),iClose(pair,check_Period,barIndex));
}
