//+------------------------------------------------------------------+
//|                                                       Ordens.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

#include <Trade/Trade.mqh>                   // Biblioteca para realizar operações de compra e venda
CTrade trade;
// #include <_Class/Ordens.mqh>              // Biblioteca otimizada para a operaçãoes de compra e venda
// COrdens ordens

//+------------------------------------------------------------------+
//| DEFINICÕES                                                       |
//+------------------------------------------------------------------+
class COrdens
  {
protected:

public:
                     COrdens(void);
                    ~COrdens(void);
   bool              SetComprarAMercado(double lote, double priceAsk, double stopLoss, double takeProfit, string symbol);
   bool              SetVenderAMercado(double lote, double priceBid, double stopLoss, double takeProfit, string symbol);

private:
  };
//---
COrdens::COrdens(void)
  {
   Print("Início! contrutor ORDENS!");
  }
//---
COrdens::~COrdens(void)
  {
   Print("Fim! destrutor ORDENS!");
  }
//+------------------------------------------------------------------+
//| COMPRA A MERCADO                                                 |
//+------------------------------------------------------------------+
bool COrdens::SetComprarAMercado(double lote, double priceAsk, double stopLoss = 0, double takeProfit = 0, string symbol = 0)
  {
   if(symbol == 0)
      symbol = _Symbol;

   double SL = NormalizeDouble((priceAsk - stopLoss * _Point), _Digits);
   double TP = NormalizeDouble((priceAsk + takeProfit * _Point), _Digits);

// Robo COMPRA SL=13350(50pts) TP=1550(150pts)
   string comentario = "Robo COMPRA SL=(" + DoubleToString(SL, _Digits) +
                       DoubleToString(stopLoss, _Digits) + "pts) " +
                       " TP=(" + DoubleToString(TP, _Digits) +
                       DoubleToString(takeProfit, _Digits) + "pts) ";


   trade.Buy(lote, symbol, priceAsk, SL, TP, comentario);

   return(true);
  }
//+------------------------------------------------------------------+
//| VENDA A MERCADO                                                  |
//+------------------------------------------------------------------+
bool COrdens::SetVenderAMercado(double lote, double priceBid, double stopLoss = ""0, double takeProfit = 0, string symbol = 0)
  {
   if(symbol == 0)
      symbol = _Symbol;

   double SL = NormalizeDouble((priceBid + stopLoss * _Point), _Digits);
   double TP = NormalizeDouble((priceBid - takeProfit * _Point), _Digits);

// Robo VENDA SL=13550(50pts) TP=1350(150pts)
   string comentario = "Robo VENDA SL=(" + DoubleToString(SL, _Digits) +
                       DoubleToString(stopLoss, _Digits) + "pts) " +
                       " TP=(" + DoubleToString(TP, _Digits) +
                       DoubleToString(takeProfit, _Digits) + "pts) ";


   trade.Sell(lote, symbol, priceBid, SL, TP, comentario);

   return(true);
  }
//+------------------------------------------------------------------+
