//+------------------------------------------------------------------+
//|                                 DonchianChannel_e_Stochastic.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| INCLUDE                                                          |
//+------------------------------------------------------------------+
#include <_Class/CheckStochastic.mqh>        // Biblioteca para a leitura do indicador Stochastic para itens sobrecomprado ou sobrevendido
#include <_Class/CheckDonchianChannel.mqh>   // Biblioteca para a leitura do indicador DonchianChannel para itens acima ou abaixo das bandas

CStochastic stochastic;
CDonchianChannel donchianChannel;
//+------------------------------------------------------------------+
//| INPUTS                                                           |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| VARIÁVEIS                                                        |
//+------------------------------------------------------------------+
MqlTick tick;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
// Alimenta os  dados da váriavel tick
   SymbolInfoTick(_Symbol, tick);

// Verifica se o último preço estáq acima da banda superio ou abaixo das banda inferior
   donchianChannel.CheckUpperBand(tick.last);
   donchianChannel.CheckLowerBand(tick.last);

   if(donchianChannel._upperBand)
     {
      Print("Fucionou DonchianChannel sobrecomprado");
     }
   else
      if(donchianChannel._lowerBand)
        {
         Print("Fucionou DonchianChannel sobrecomprado");
        }

   if(!IsNewBar())
      return;

// Verifica se o estocástico está sobrecomprado ou sobrevendido
   stochastic.CheckSobrecomprado();
   stochastic.CheckSobrevendido();

   if(stochastic._sobrecomprado)
     {
      Print("Fucionou Stochastic sobrecomprado");
     }
   else
      if(stochastic._sobrevendido)
        {
         Print("Fucionou Stochastic sobrevendido");
        }
  }
//+------------------------------------------------------------------+
//| CADA NOVO CANDLESTICK QUE FOR FORMADO                            |
//+------------------------------------------------------------------+
bool IsNewBar()
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
