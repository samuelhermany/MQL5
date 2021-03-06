//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh> // Biblioteca padrão CTrade
CTrade trade;

input int myLote_1 = 1;
input int myTakeProfit_1 = 10;
input int myStopLoss_1 = 5;
input int myTrallingStop_1 = 3;

//+------------------------------------------------------------------+
//| EXPERT TICK FUNCTION                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
// Calcula o preço ASK(venda)
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

   if(IsNewBar())
     {
      // Verifica se não existe nenhuma posição em aberto
      if(PositionsTotal()==0)
         trade.Buy(myLote_1, NULL, Ask, Ask - myStopLoss_1, 0, "Robo Buy Tralling Stop");
     }

// Atualiza o Tralling Stop
   CheckTrallingStop(Ask);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| CRIA E ATULIAZA O TRALLING STOP                                  |
//+------------------------------------------------------------------+
void CheckTrallingStop(double Ask)
  {
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      string symbol = PositionGetSymbol(i);

      // Verifica se o Ativo atual é igual ao da ordem limita que está sendo lida
      if(_Symbol==symbol)
        {
         // Obtem o Ticket(index) da ordem que esta sendo lida
         ulong PositionTicket = PositionGetInteger(POSITION_TICKET);

         // Calcula o Stop Loss atual
         double StopLossAtual = PositionGetDouble(POSITION_SL);

         // Defiine o Stop Loss em 10 pontos
         double StopLossNovo = NormalizeDouble(Ask-myTrallingStop_1, _Digits);

         // Modifica o Stop Loss
         if(StopLossNovo > StopLossAtual)
            trade.PositionModify(PositionTicket, StopLossNovo, 0);
        }
     }
  }
//+------------------------------------------------------------------+


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
