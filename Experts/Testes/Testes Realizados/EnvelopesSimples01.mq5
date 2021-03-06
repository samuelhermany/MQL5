//+------------------------------------------------------------------+
//|                                                    Envelopes.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh> // Biblioteca padrão CTrade
// Create an instance from CTrade
CTrade trade;

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
input double myLote_2 = 1;
input int myTakeProfit_1 = 10;
input int myStopLoss_1 = 5;
input int myPeriodoMediaMovel = 5;
input int myPeriodoEnvelope = 5;

//+------------------------------------------------------------------+
//| Globais                                                          |
//+------------------------------------------------------------------+
// -------- Manipuladores dos indicadores de média móvel
int superiorHandle = INVALID_HANDLE;
int inferiorHandle = INVALID_HANDLE;
//--- indicator buffers
double SuperiorBuffer[];
double InferiorBuffer[];

//+------------------------------------------------------------------+
//| Expert ao inicialização o robo                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,SuperiorBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,InferiorBuffer,INDICATOR_DATA);

//---
   return(INIT_SUCCEEDED);
  }


//+------------------------------------------------------------------+
//| Expert execução do robo                                          |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(isNewBar())
     {
      // Calcula o preço ASK(venda)
      double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);//+ Spread;

      // Calcula o preço BID(compra)
      double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);//;- Spread;

      // Calcula o preço SPREED(taxa corretora FOREX)
      double Spread = Ask - Bid;

      // Crie uma matriz para os preços
      MqlRates PriceInformation[];

      // Organiza a matriz do candlestick atual que está sendo formado
      ArraySetAsSeries(PriceInformation, true);

      // Copiar dados de preços para a matriz
      int Data = CopyRates(Symbol(), Period(), 0, Bars(Symbol(), Period()), PriceInformation);

      // Crie uma matriz para vários preços(Linha Superio/ Linha Inferior)
      double UpperBandArray[];
      double LowerBandArray[];

      // Reduz a matriz dos preços para o candlestick que esta sendo formado
      ArraySetAsSeries(UpperBandArray, true);
      ArraySetAsSeries(LowerBandArray, true);

      // Define o indicador ENVELOPES
      int EnvelopesDefinition = iEnvelopes(_Symbol, _Period, myPeriodoEnvelope, 0, MODE_SMA, PRICE_CLOSE, 0.100);

      // Copiar informações de preço para a matriz
      CopyBuffer(EnvelopesDefinition, 0, 0, 3, UpperBandArray);
      CopyBuffer(EnvelopesDefinition, 1, 0, 3, LowerBandArray);

      // Calcular os valores das matriz
      double myUpperBandValue = NormalizeDouble(UpperBandArray[0], 6);
      double myLowerBandValue = NormalizeDouble(LowerBandArray[0], 6);

      // Sinal de Compra / Venda
      bool sinalCompra, sinalVenda = false;

      //+------------------------------------------------------------------+
      //| SINAIS DE COMPRA E VENDA                                         |
      //+------------------------------------------------------------------+
      // Se a última vela fechou abaixo da BandaInferior
      double valor = PriceInformation[1].close;
      if(myUpperBandValue != 0 || myLowerBandValue != 0)
        {
         if(PriceInformation[1].close > myUpperBandValue)
           {
            sinalVenda = true;
           }
         // Se a última vela fechou acima da BandaSuperior
         else
            if(PriceInformation[1].close <  myLowerBandValue)
              {
               sinalCompra = true;
              }
        }

      //+------------------------------------------------------------------+
      //| VERIFICAR SE ESTOU POSICIONADO                                   |
      //+------------------------------------------------------------------+
      bool comprado, vendido = false;

      if(PositionSelect(_Symbol))
        {
         //--- se a posição for comprada
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
            comprado = true;

         //--- se a posição for vendida
         if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
            vendido = true;
        }

      //+------------------------------------------------------------------+
      //| LÓGICA DE ROTEAMENTO                                             |
      //+------------------------------------------------------------------+
      //--- Se não tem nenhuma ordem compra ou vendida em aberto
      if(!comprado && !vendido)
        {
         //--- sinal de compra = true
         if(sinalCompra)
            SetBuy(Ask, Spread);

         //--- sinal de venda = true
         if(sinalVenda)
            SetSell(Bid, Spread);
        }
      else
        {
         //--- estou comprado
         if(comprado)
           {
            //--- sinal de venda = true
            if(sinalVenda)
               SetSell(Bid, Spread);
           }
         //--- estou vendido
         else
            if(vendido)
              {
               //--- sinal de compra = true
               if(sinalCompra)
                  SetBuy(Ask, Spread);
              }
        }
     }
  }



//+------------------------------------------------------------------+
//| MÉTODOS                                                          |
//+------------------------------------------------------------------+
//Vender
bool SetSell(double Bid, double Spread)
  {
//trade.Sell(tamanho do lote, symbol=NULL, price, stop loss, take profit, comment="")
   trade.Sell(myLote_2, NULL, Bid, (Bid + myStopLoss_1 * _Point), (Bid - myTakeProfit_1 * _Point), "Robo = venda a mercado");
   return(true);
  }

//Comprar
bool SetBuy(double Ask, double Spread)
  {
//trade.Buy(tamanho do lote, symbol=NULL, price, stop loss, take profit, comment="")
   trade.Buy(myLote_2, NULL, Ask, (Ask - myStopLoss_1 * _Point), (Ask + myTakeProfit_1 * _Point), "Robo = compra a mercado");
   return(true);
  }


//+------------------------------------------------------------------+
//| CADA NOVO CANDLE QUE FOR FORMADO                                 |
//+------------------------------------------------------------------+
bool isNewBar()
  {
//--- Memoriza o tempo de abertura do último candelstick na variável estática
   static datetime last_time=0;
//--- Hora atual
   datetime lastbar_time=(datetime)SeriesInfoInteger(Symbol(),Period(),SERIES_LASTBAR_DATE);

//--- Se for a primeira chamada da função
   if(last_time==0)
     {
      //--- Definir a hora e sair
      last_time=lastbar_time;
      return(false);
     }

//--- Se os tempos forem diferentes
   if(last_time!=lastbar_time)
     {
      //--- Memorizar o tempo
      last_time=lastbar_time;
      return(true);
     }
//--- if we passed to this line, then the bar is not new; return false
//---  Se passarmos para esta linha, a barra não é nova
   return(false);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
