//+------------------------------------------------------------------+
//|                                         EvelopesMediaMovel02.mq5 |
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
input double myLote_1 = 10;
input int myTakeProfit_1 = 10;
input int myStopLoss_1 = 5;
input int myPeriodoMediaMovel = 5;
input int myPeriodoEnvelope = 5;
input double myDeviationEnvelope = 0.1;

//+------------------------------------------------------------------+
//| Globais                                                          |
//+------------------------------------------------------------------+
// -------- Manipuladores dos indicadores de média móvel
int envelopesManipulador = INVALID_HANDLE;
int mediaMovelManipulador = INVALID_HANDLE;
//--- indicator buffers
double SuperiorBuffer[];
double InferiorBuffer[];
double MediaMovelBuffer[];

//+------------------------------------------------------------------+
//| Expert ao inicialização o robo                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Indicator buffers mapping
   SetIndexBuffer(0,SuperiorBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,InferiorBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,MediaMovelBuffer,INDICATOR_DATA);
   
//--- Define o indicador ENVELOPES
   envelopesManipulador = iEnvelopes(_Symbol, _Period, myPeriodoEnvelope, 0, MODE_SMA, PRICE_CLOSE, myDeviationEnvelope);
   mediaMovelManipulador = iMA(_Symbol,_Period, myPeriodoMediaMovel, 0, MODE_SMA, PRICE_CLOSE);
   
//--- Retorna true(sucesso)
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

      // Crie uma matriz para vários preços(Linha Superior/ Linha Inferior)
      double UpperBandArray[];
      double LowerBandArray[];
      double MediaMovelArray[];

      // Reduz a matriz dos preços para o candlestick que esta sendo formado
      ArraySetAsSeries(UpperBandArray, true);
      ArraySetAsSeries(LowerBandArray, true);
      ArraySetAsSeries(MediaMovelArray, true);

      // Copiar informações de preço para a matriz
      CopyBuffer(envelopesManipulador, 0, 0, 3, UpperBandArray);
      CopyBuffer(envelopesManipulador, 1, 0, 3, LowerBandArray);
      CopyBuffer(mediaMovelManipulador, 0, 0, 3, MediaMovelArray);

      // Calcular os valores das matriz
      double myBandaSuperiorValue = NormalizeDouble(UpperBandArray[0], 6);
      double myBandaInferiorValue = NormalizeDouble(LowerBandArray[0], 6);
      double myMediaMovelValue = NormalizeDouble(MediaMovelArray[0], 6);

      // Sinal de Compra / Venda
      bool sinalCompra, sinalVenda = false;

      //+------------------------------------------------------------------+
      //| SINAIS DE COMPRA E VENDA                                         |
      //+------------------------------------------------------------------+
      // Se a última vela fechou abaixo da BandaInferior
      double valor = PriceInformation[1].close;
      if(myBandaSuperiorValue != 0 || myBandaInferiorValue != 0)
        {
         if(PriceInformation[1].close > myBandaSuperiorValue)
           {
            sinalVenda = true;
           }
         // Se a última vela fechou acima da BandaSuperior
         else
            if(PriceInformation[1].close <  myBandaInferiorValue)
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
            SetBuy(Ask);

         //--- sinal de venda = true
         if(sinalVenda)
            SetSell(Bid);
        }
      else
        {
         //--- estou comprado
         if(comprado)
           {
            //--- sinal de venda = true
            if(sinalVenda)
               SetSell(Bid);
           }
         //--- estou vendido
         else
            if(vendido)
              {
               //--- sinal de compra = true
               if(sinalCompra)
                  SetBuy(Ask);
              }
        }
     }
  }



//+------------------------------------------------------------------+
//| MÉTODOS                                                          |
//+------------------------------------------------------------------+
//Vender
bool SetSell(double Bid)
  {
//trade.Sell(tamanho do lote, symbol=NULL, price, stop loss, take profit, comment="")
   trade.Sell(myLote_1, NULL, Bid, (Bid + myStopLoss_1 * _Point), (Bid - myTakeProfit_1 * _Point), "Robo = venda a mercado");
   return(true);
  }

//Comprar
bool SetBuy(double Ask)
  {
//trade.Buy(tamanho do lote, symbol=NULL, price, stop loss, take profit, comment="")
   trade.Buy(myLote_1, NULL, Ask, (Ask - myStopLoss_1 * _Point), (Ask + myTakeProfit_1 * _Point), "Robo = compra a mercado");
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