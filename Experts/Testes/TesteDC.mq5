//+------------------------------------------------------------------+
//|                                                      TesteDC.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
/*
 (MiniIndice) só multiplo de 5 (myTakeProfit_3, myStopLoss_3, myOrderLimit_3)
   MÊS VENCIMENTO    LETRA
   Janeiro           F
   Fevereiro         G
   Março             H
   Abril             J
   Maio              K
   Junho             M
   Julho             N
   Agosto            Q
   Setembro          U
   Outubro           V
   Novembro          X
   Dezembro          Z

   Ativo      | WIN(MiniÍndice) | WDO(MiniDólar) | IND(Índice) | DOL(Dólar) | ISPFUT(S&P 500) | DIFUT(Juros DI) |
   Contratos  |       1         |     1          |     5       |     5      |        1        |         5       |
   TakeProfit |       200       |     5          |     10      |     5      |        5        |         10      |
   StopLoss   |       50        |     2          |     4       |     2      |        2        |         4       |
   OrderLimit |       10        |     3          |     2       |     2      |        2        |         2       |
   TralingStop|       10        |     3          |     4       |     2      |        2        |         2       |
*/
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh> // Biblioteca padrão CTrade
// Cria uma instancia para CTrade
CTrade trade;
//+------------------------------------------------------------------+
//| INPUTS                                                           |
//+------------------------------------------------------------------+
input group "Horários"
input int myAberturaHora = 9;          // Início  (09:00)
input int myAberturaMinuto = 30;       // Início  (09:00)
input int myFechamentoHora = 17;           // Término (18:00)
input int myFechamentoMinuto = 30;         // Término (18:00)

input group "Ordem"                             // Ativo
input double myLote_3 = 1;                      // Lotes / Contratos
input const int myTakeProfit_3 = 150;           // TakeProfit
input const int myStopLoss_3 = 50;              // StopLoss
input int myTrallingStop_3 = 50;                 // Pontos de Offset do Tralling Stop

input group "Indicador"
input int periodo =10;                          // Período Donchian Channel
input int type =0;                              // Tipo
input int margins =2;                           // Margin
input int shift =0;                             // Shift

int dc_Handle;                                  // Manipulador Donchian Channel
double   VendaBuffer[];

MqlDateTime horaAtual;
MqlDateTime horaCandelstickAtual;
MqlDateTime horaHistoricoOrdem;
MqlTick tick;

int myUltimaOrdemHora;
int myUltimaOrdemMinuto;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(1,VendaBuffer,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(1,PLOT_ARROW,234);
//---
   dc_Handle = iCustom(_Symbol, _Period, "Examples/Download/Donchian_Channels.ex5",periodo, type, margins, shift);

   if(dc_Handle < 0)
     {
      Alert("Tivemos problemas ao carregar o indicador - ", GetLastError());
      return(INIT_FAILED);
     }

   ChartIndicatorAdd(0, 0, dc_Handle);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert execução do robo                                          |
//+------------------------------------------------------------------+
void OnTick()
  {
//if(!IsNewBar())
//   return;

   string currentdatestr1=TimeToString(TimeCurrent(),TIME_MINUTES);

   /* Verifica se o horário atual esta dentro do horário de funcionamento do Robo
      Se o resultado igual = false sai do método*/
   if(!VerificarHorario())
      return ;

// Calcula o preço ASK(venda)
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);//+ Spread;

// Calcula o preço BID(compra)
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);//;- Spread;

// Crie uma matriz para os preços
   MqlRates PriceInformation[];

// Organiza a matriz do candlestick atual que está sendo formado
   ArraySetAsSeries(PriceInformation, true);

// Create an array for several prices
   double dc_Buffer_BandaSuperior[];
   double dc_Buffer_BandaInferior[];

// Organiza a matriz do candlestick atual que está sendo formado
   int Data = CopyRates(Symbol(), Period(), 0, Bars(Symbol(), Period()), PriceInformation);

//Copy price info into the array
   CopyBuffer(dc_Handle, 0, 0, 3, dc_Buffer_BandaSuperior);
   CopyBuffer(dc_Handle, 2, 0, 3, dc_Buffer_BandaInferior);

// Short the price array from the current candle downwards
   ArraySetAsSeries(dc_Buffer_BandaInferior, true);
   ArraySetAsSeries(dc_Buffer_BandaSuperior, true);

// Calculate EA for the current candle
   double myUpperBandValue = NormalizeDouble(dc_Buffer_BandaSuperior[0], 2);
   double myLowerBandValue = NormalizeDouble(dc_Buffer_BandaInferior[0], 2);

// Sinal de Compra / Venda
   bool sinalCompra = false;
   bool sinalVenda = false;
//+------------------------------------------------------------------+
//| SINAIS DE COMPRA E VENDA/ CRIAÇÃO DAS SETAS                      |
//+------------------------------------------------------------------+
   double t00 = PriceInformation[0].high;
   double t01 = PriceInformation[1].high;
// Alimenta os  dados da váriavel tick
   SymbolInfoTick(_Symbol, tick);
   double a01 = tick.last ;
   double a02 = tick.bid ;
   double a03 = tick.ask ;

// Se o preço máximo está acima da banda superior
//if(PriceInformation[0].high >myUpperBandValue)
   if(tick.last >myUpperBandValue)
     {
      if(!VerificaSeExisteOrdemNaVelaAtual())
        {
         // Cria a seta
         Comment("SINAL DE VENDA");
         sinalVenda = true;
        }
     }
   else
      if(tick.last <myLowerBandValue)      //if(PriceInformation[0].low <myLowerBandValue)
        {
         if(!VerificaSeExisteOrdemNaVelaAtual())
           {
            // Cria a seta
            Comment("SINAL DE COMPRA");
            sinalCompra = true;
           }
        }
//+------------------------------------------------------------------+
//| VERIFICAR SE ESTOU POSICIONADO                                   |
//+------------------------------------------------------------------+
   bool comprado = false;
   bool vendido = false;

//--- sinal de venda = true
   if(sinalVenda)
     {
      SetSell(Bid);
      //CriarSeta("vender", PriceInformation[1].high);
     }
//--- sinal de compra = true
   else
      if(sinalCompra)
        {
         SetBuy(Ask);
         //CriarSeta("comprar", PriceInformation[1].low);
        }

// Atualiza o Tralling Stop
   if(PositionsTotal()>0)
      UpdateTrallingStop(Ask, Bid, tick.last);
  } // End If void
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
//|    VERIFICA SE ALGUMA ORDEM JÁ FOI ABERTA NA VELA ATUAL          |
//+------------------------------------------------------------------+
bool VerificaSeExisteOrdemNaVelaAtual()
  {
   TimeToStruct(TimeCurrent(), horaCandelstickAtual);

   int t00 = horaCandelstickAtual.hour;
   int t01 = horaCandelstickAtual.min;
   int t02 = horaAtual.hour;
   int t03 = horaAtual.min;
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if(horaAtual.hour == horaCandelstickAtual.hour && horaAtual.min == horaCandelstickAtual.min)
         return true;
     }

      if(horaAtual.hour == myUltimaOrdemHora && horaAtual.min == myUltimaOrdemMinuto)
         return true;

   return false;
  }
//+------------------------------------------------------------------+
//| MÉTODOS ORDEM A MERCADO                                          |
//+------------------------------------------------------------------+
//Vender
bool SetSell(double Bid)
  {
   myUltimaOrdemHora = horaAtual.hour;
   myUltimaOrdemMinuto = horaAtual.min;
   trade.Sell(myLote_3, NULL, Bid, (Bid + myStopLoss_3 * _Point), 0, "Robo = venda a mercado");
   return(true);
  }

//Comprar
bool SetBuy(double Ask)
  {
   myUltimaOrdemHora = horaAtual.hour;
   myUltimaOrdemMinuto =horaAtual.min;
   trade.Buy(myLote_3, NULL, Ask, (Ask - myStopLoss_3 * _Point), 0, "Robo = compra a mercado");
   return(true);
  }
//+------------------------------------------------------------------+
//| CRIA E ATULIZA O TRALLING STOP                                   |
//+------------------------------------------------------------------+
void UpdateTrallingStop(double Ask, double Bid, double ultimoTick)
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

         // Preço de abertura de uma posição
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);

         // Venda ou Compra
         int tipoDeOrdem = PositionGetInteger(POSITION_TYPE);

         // Modifica o Stop Loss
         if(tipoDeOrdem ==0 && openPrice<ultimoTick)   // Compra
           {
            // Defiine o Stop Loss em 10 pontos
            double StopLossNovo = NormalizeDouble(ultimoTick-myTrallingStop_3, _Digits);

            if(StopLossNovo > StopLossAtual)
               trade.PositionModify(PositionTicket, StopLossNovo, 0);
           }
         else
            if(tipoDeOrdem==1 && openPrice>ultimoTick)  // Venda
              {
               // Defiine o Stop Loss em 10 pontos
               double StopLossNovo = NormalizeDouble(ultimoTick+myTrallingStop_3, _Digits);

               if(StopLossNovo < StopLossAtual)
                  trade.PositionModify(PositionTicket, StopLossNovo, 0);
              }
        }
     }
  }
//+------------------------------------------------------------------+
//| CRIA AS SETAS DE COMPRA E VENDA                                  |
//+------------------------------------------------------------------+
bool CriarSeta(string acao, double preco)
  {
// Converter número de candles em string
   string NumberOfCandlesText = IntegerToString(Bars(Symbol(), Period()));

// Cria a seta
   if(acao == "vender")
      ObjectCreate(_Symbol, NumberOfCandlesText, OBJ_ARROW_SELL, 0, TimeCurrent()-60, (preco+10));
   else
      if
      (acao == "comprar")
         ObjectCreate(_Symbol, NumberOfCandlesText, OBJ_ARROW_BUY, 0, TimeCurrent()-60, (preco-10));

   return true;
  }
//+------------------------------------------------------------------+
//| MÉTODO GET INFORMAÇÕES DOS HORÁRIOS DEFINIDOS DO ROBO            |
//+------------------------------------------------------------------+
bool VerificarHorario()
  {
   TimeToStruct(TimeCurrent(), horaAtual);
   int t01 = horaAtual.hour;
   int t02 = horaAtual.min;
// current time
   if(horaAtual.hour >= myAberturaHora && horaAtual.hour <= myFechamentoHora)
     {
      if(horaAtual.hour == myAberturaHora)
        {
         if(horaAtual.min >= myAberturaMinuto)
            return(true);
         else
            return(false);
        }
      else
         if(horaAtual.hour == myFechamentoHora)
            if(horaAtual.min <= myFechamentoMinuto)
               return(true);
            else
               return(false);

      return(true);
     }

   return(false);
  }
//+------------------------------------------------------------------+
