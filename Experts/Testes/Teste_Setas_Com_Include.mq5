//+------------------------------------------------------------------+
//|                                                  Teste_Setas.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <_Class/Setas.mqh> // Biblioteca para criação de setas de compra e venda
CSetas setas;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
// Crie uma matriz para os preços
   MqlRates PriceInformation[];

// Organiza a matriz do candlestick atual que está sendo formado
   ArraySetAsSeries(PriceInformation, true);

// Organiza a matriz do candlestick atual que está sendo formado
   int Data = CopyRates(Symbol(), Period(), 0, Bars(Symbol(), Period()), PriceInformation);   
   
   
   setas.CriarSetaDeCompra(PriceInformation[0].high);
  }
//+------------------------------------------------------------------+
