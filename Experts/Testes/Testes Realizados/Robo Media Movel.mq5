//+------------------------------------------------------------------+
//|                                             Robo Media Movel.mq5 |
//| Compra quando média móvel vermelha(curta) cruza a azul de baixo para cima 
//| Venda quando média móvel vermelha(curta) cruza a azul de cima para baixo 
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"   
#property version   "1.00"
//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh> // Biblioteca padrão CTrade
//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
input int lote = 1;
input int periodoCurta = 10;
input int periodoLonga = 50;
//+------------------------------------------------------------------+
//| Globais                                                          |
//+------------------------------------------------------------------+
// -------- Manipuladores dos indicadores de média móvel
int curtaHandle = INVALID_HANDLE;
int longHandle = INVALID_HANDLE;
// -------- Vetores de dados dos indicadores das médias móveis
double mediaCurta [];
double mediaLonga [];
// -------- Declarar a variável trade
CTrade trade;
//+------------------------------------------------------------------+
//| Expert ao inicialização o robo                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Inverte as posições dos vetores
   ArraySetAsSeries(mediaCurta, true);
   ArraySetAsSeries(mediaLonga, true);
//--- Atribuir p/ os manipuladores de média móvel
//--- Definição iMA(ativo_corrente, time_frame_corrente, periodo_previamente_definido, deslocamento=0, tipo simples, tipo de preço)
   curtaHandle = iMA(_Symbol,_Period, periodoCurta,0,MODE_SMA,PRICE_CLOSE);
   longHandle = iMA(_Symbol,_Period, periodoLonga,0,MODE_SMA, PRICE_CLOSE);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert finalizar o robo function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert execução do robo                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(isNewBar() )
     {
      // execute a lógica operacional do robô
      
      //+------------------------------------------------------------------+
      //| OBTENÇÃO DOS DADOS                                               |
      //+------------------------------------------------------------------+
      int copied1 = CopyBuffer(curtaHandle,0,0,3,mediaCurta);
      int copied2 = CopyBuffer(longHandle,0,0,3,mediaLonga);
      //---
      bool sinalCompra = false;
      bool sinalVenda = false;
      //--- se os dados tiverem sido copiados corretamente
      if(copied1==3 && copied2==3)
        {
         //--- sinal de compra
         if( mediaCurta[1]>mediaLonga[1] && mediaCurta[2]<mediaLonga[2] )
           {
            sinalCompra = true;
           }
         //--- sinal de venda
         if( mediaCurta[1]<mediaLonga[1] && mediaCurta[2]>mediaLonga[2] )
           {
            sinalVenda = true;
           }
        }
      
      //+------------------------------------------------------------------+
      //| VERIFICAR SE ESTOU POSICIONADO                                   |
      //+------------------------------------------------------------------+
      bool comprado = false;
      bool vendido = false;
      if(PositionSelect(_Symbol))
        {
         //--- se a posição for comprada
         if( PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY )
           {
            comprado = true;
           }
         //--- se a posição for vendida
         if( PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL )
           {
            vendido = true;
           }
        }
      //+------------------------------------------------------------------+
      //| LÓGICA DE ROTEAMENTO                                             |
      //+------------------------------------------------------------------+
      //--- ZERADO
      if( !comprado && !vendido )
        {
         //--- sinal de compra
         if( sinalCompra )
            trade.Buy(lote,_Symbol,0,0,0.1,"Compra a mercado");           
         //--- sinal de venda
         else if( sinalVenda )
            trade.Sell(lote,_Symbol,0,0,0.1,"Venda a mercado");           
        }
      else
        {
         //--- estou comprado
         if( comprado )
           {
            if( sinalVenda )              
               trade.Sell(lote*2,_Symbol,0,0,20,"Virada de mão (compra->venda)");              
           }
         //--- estou vendido
         else if( vendido )
           {
            if( sinalCompra )              
               trade.Buy(lote*2,_Symbol,0,0,20,"Virada de mão (venda->compra)");              
           }
        }            
     }   
     
  }
  
  
//+------------------------------------------------------------------+
bool isNewBar()
  {
//--- memorize the time of opening of the last bar in the static variable
   static datetime last_time=0;
//--- current time
   datetime lastbar_time=(datetime)SeriesInfoInteger(Symbol(),Period(),SERIES_LASTBAR_DATE);

//--- if it is the first call of the function
   if(last_time==0)
     {
      //--- set the time and exit
      last_time=lastbar_time;
      return(false);
     }

//--- if the time differs
   if(last_time!=lastbar_time)
     {
      //--- memorize the time and return true
      last_time=lastbar_time;
      return(true);
     }
//--- if we passed to this line, then the bar is not new; return false
   return(false);
  }