//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh> // Biblioteca padrão CTrade
CTrade trade;

input int myLote_1 = 10;
input int myTakeProfit_1 = 10;
input int myStopLoss_1 = 3;

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
// Calcula o preço ASK(venda)
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

// Calcula o preço BID(compra)
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

   if(OrdersTotal()==0 && PositionsTotal()==0)
     {
      trade.BuyLimit(1, (Bid - (5*_Point)), NULL, 0, 0, ORDER_TIME_GTC, 0, "Robo Buy Limit");
     }
  }
//+------------------------------------------------------------------+
