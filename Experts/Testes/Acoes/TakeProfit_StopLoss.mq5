//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh> // Biblioteca padrão CTrade
CTrade trade;

input const double myLote = 0.1;
input int myTakeProfit = 100;
input int myStopLoss = 30;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
// Calcula o preço SPREED(taxa corretora FOREX)
   double Spread = SymbolInfoInteger(Symbol(),SYMBOL_SPREAD) * _Point;

// Calcula o preço ASK(venda)
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Ask1 = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits) + Spread;

// Calcula o preço BID(compra)
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits) - Spread;

   
// Obtem o saldo disponível
   double Balance = AccountInfoDouble(ACCOUNT_BALANCE);

// Get the equity
   double Equity = AccountInfoDouble(ACCOUNT_EQUITY);

// Buy when Equity is equal or above Balance
   if(Equity >= Balance)
      trade.Buy(myLote, NULL, Ask, (Ask - myStopLoss * _Point), (Ask + myTakeProfit * _Point), "Robo Compra");

// Saida do gráfico
   Comment("Balance: ", Balance, "\nEquity: ", Equity, "\nTakeProfitValue: ", myTakeProfit);
  }
//+------------------------------------------------------------------+
