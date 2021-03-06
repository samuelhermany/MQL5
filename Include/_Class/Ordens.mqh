//+------------------------------------------------------------------+
//|                                                       Ordens.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link "https://www.mql5.com"

#include <Trade/Trade.mqh> // Biblioteca para realizar operações de compra e venda
CTrade trade;
// #include <_Class/Ordens.mqh>              // Biblioteca otimizada para a operaçãoes de compra e venda e ajuste de posiÇÕes
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
   bool              CheckStopMovel(double tickLast, double pts_stopMovel);

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
   string comentario = "Robo COMPRA SL=" + DoubleToString(SL, _Digits) + "(" +
                       DoubleToString(stopLoss, _Digits) + "pts) " +
                       " TP=" + DoubleToString(TP, _Digits) + "(" +
                       DoubleToString(takeProfit, _Digits) + "pts) ";

   if(takeProfit == 0)
      trade.Buy(lote, symbol, priceAsk, SL, 0, comentario);
   else
      trade.Buy(lote, symbol, priceAsk, SL, TP, comentario);


   return (true);
  }
//+------------------------------------------------------------------+
//| VENDA A MERCADO                                                  |
//+------------------------------------------------------------------+
bool COrdens::SetVenderAMercado(double lote, double priceBid, double stopLoss = "", double takeProfit = 0, string symbol = 0)
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

   if(takeProfit == 0)
      trade.Sell(lote, symbol, priceBid, SL, 0, comentario);
   else
      trade.Sell(lote, symbol, priceBid, SL, TP, comentario);

   return (true);
  }
//+------------------------------------------------------------------+
//| ATUALZIA O TRALLING STOP                                         |
//+------------------------------------------------------------------+
bool COrdens::CheckStopMovel(double tickLast, double pts_StopMovel)
  {
   for(int i = 0; i < PositionsTotal(); i++)
     {
      // Verifica se o Ativo atual é igual ao da ordem limita que está sendo lida
      if(PositionGetSymbol(i) == _Symbol)
        {
         // indexador de ordens abertas
         ulong ticket = PositionGetTicket(i);
         double price_Start = PositionGetDouble(POSITION_PRICE_OPEN);
         double SL_Atual = PositionGetDouble(POSITION_SL);
         double TP_Atual = PositionGetDouble(POSITION_TP);

         if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            UpdateOrdemCompra(ticket, tickLast, price_Start, SL_Atual, TP_Atual, pts_StopMovel);
         else
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
               UpdateOrdemVenda(ticket, tickLast, price_Start, SL_Atual, TP_Atual, pts_StopMovel);
        }
     }

   return true;
  }

// Atualiza a ordem de COMPRA
void UpdateOrdemCompra(ulong ticket, double tickLast, double price_Start, double SL_Atual, double TP_Atual, double pts_stopMovel)
  {
   double SL_Novo = NormalizeDouble((tickLast - pts_stopMovel) * _Point, _Digits);

   if(SL_Novo > SL_Atual && SL_Novo >= price_Start && SL_Atual != SL_Novo)
     {
      if(TP_Atual == 0)
        {
         double TP_Novo = NormalizeDouble((SL_Novo + 1000) * _Point, _Digits);
         UpdateOrdem(ticket, SL_Novo, TP_Atual, "Compra", price_Start, SL_Atual);
        }
     }
  }

// Atualiza a ordem de VENDA
void UpdateOrdemVenda(ulong ticket, double tickLast, double price_Start, double SL_Atual, double TP_Atual, double pts_StopMovel)
  {
   double SL_Novo = NormalizeDouble((tickLast + pts_StopMovel) * _Point, _Digits);

   if(SL_Novo < SL_Atual && SL_Novo <= price_Start && SL_Atual != SL_Novo)
     {
      if(TP_Atual == 0)
        {
         double TP_Novo = NormalizeDouble((SL_Novo - 1000) * _Point, _Digits);
         UpdateOrdem(ticket, SL_Novo, TP_Atual, "Venda", price_Start, SL_Atual);
        }
     }
  }

// Atualiza a ordem no Meta Trader
void UpdateOrdem(ulong ticket, double SL_Novo, double TP_Atual, string orderType, double price_Start, double SL_Atual)
  {
   trade.PositionModify(ticket, SL_Novo, TP_Atual);
   Print(orderType, " - SL atual = ", SL_Atual, ", SL Novo = ", SL_Novo, ", Preço de entrada = ", price_Start);
  }
//+------------------------------------------------------------------+
