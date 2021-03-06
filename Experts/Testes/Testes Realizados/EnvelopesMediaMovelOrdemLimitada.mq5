//+------------------------------------------------------------------+
//|                                         EvelopesMediaMovel02.mq5 |
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
*/
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
// Listas
enum ENUM_ATIVOS {WINQ20=0, WDOQ20=1, INDQ20=2, DOLQ20=3, ISPFUT=4, DIFUT=5, FOREX=6};
// Inputs
input group "Horários"
input string myHoraStart = " 09:30:00";                        // Início  (09:00)
input string myHoraEnd = " 16:00:00";                          // Término (18:00)

input group "Parâmetros da Ordem"
input ENUM_ATIVOS myAtivo = 0;                                 // Ativo
input double myLote_3 = 1;                                     // Lotes / Contratos
input const int myTakeProfit_3 = 150;                            // TakeProfit
input const int myStopLoss_3 = 50;                              // StopLoss
input int myOrderLimit_3 = 10;                                  // Offset Order Limit

input group "Parâmetros dos Indicadores"
input int myPeriodoMediaMovel_2 = 5;                           // Média Móvel Período
input int myPeriodoEnvelope_2 = 5;                             // Envelope Período
input double myDeviationEnvelope_2 = 0.1;                      // Envelope Deviation
input ENUM_MA_METHOD myMethod = MODE_SMA;                      // Método
input ENUM_APPLIED_PRICE myPrecoAplicavel  =PRICE_CLOSE;       // Aplica-se
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
//--- Hora deinício e Término do Robo
datetime roboStart;
datetime roboEnd;
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
   envelopesManipulador = iEnvelopes(_Symbol, _Period, myPeriodoEnvelope_2, 0, myMethod, myPrecoAplicavel, myDeviationEnvelope_2);
   mediaMovelManipulador = iMA(_Symbol,_Period, myPeriodoMediaMovel_2, 0, myMethod, myPrecoAplicavel);

   roboStart = StartTime();
   roboEnd = EndTime();

//--- Retorna true(sucesso)
   return(INIT_SUCCEEDED);
  }



//+------------------------------------------------------------------+
//| Expert execução do robo                                          |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(IsNewBar())
     {
      string currentdatestr1=TimeToString(TimeCurrent(),TIME_MINUTES);

      // Verifica se o horário atual esta dentro do horário de funcionamento do Robo
      // Se o resultado igual = false sai do método
      if(!VerificarHorario())
         return ;

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
            sinalVenda = true;
         // Se a última vela fechou acima da BandaSuperior
         else
            if(PriceInformation[1].close <  myBandaInferiorValue)
               sinalCompra = true;
        }

      //+------------------------------------------------------------------+
      //| VERIFICAR SE ESTOU POSICIONADO                                   |
      //+------------------------------------------------------------------+
      bool comprado = false;
      bool vendido = false;

      if(OrdersTotal()!=0 && PositionsTotal()!=0)
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
            SetBuyLimit(myBandaInferiorValue);

         //--- sinal de venda = true
         if(sinalVenda)
            SetSellLimit(myBandaSuperiorValue);
        }
      else
        {
         //--- estou comprado
         if(comprado)
           {
            //--- sinal de venda = true
            if(sinalVenda)
               SetSellLimit(myBandaSuperiorValue);
           }
         //--- estou vendido
         else
            if(vendido)
              {
               //--- sinal de compra = true
               if(sinalCompra)
                  SetBuyLimit(myBandaInferiorValue);
              }
        }
     }
  }
//+------------------------------------------------------------------+
//| MÉTODO GET INFORMAçõES DOS HORáRIOS DEFINIDOS DO ROBO            |
//+------------------------------------------------------------------+
bool VerificarHorario()
  {
   datetime horaAtual=TimeCurrent();

// current time
   if(roboStart < roboEnd)
      if(horaAtual >= roboStart && horaAtual < roboEnd)
         return(true); // check if we are in the range

   return(false);
  }
//--- Get Horário Inicial -------------------------------------------+
datetime StartTime()
  {
   string currentdatestr=TimeToString(TimeCurrent(),TIME_DATE);
   string datetimenow=currentdatestr + myHoraStart;
   return StringToTime(datetimenow);
  }
//--- Get  Horário Final --------------------------------------------+
datetime EndTime()
  {
   string currentdatestr=TimeToString(TimeCurrent(),TIME_DATE);
   string datetimenow=currentdatestr + myHoraEnd;
   return StringToTime(datetimenow);
  }
//+------------------------------------------------------------------+
//| MÉTODOS ORDEM A MERCADO                                          |
//+------------------------------------------------------------------+
//Vender
bool SetSell(double Bid)
  {
//trade.Sell(tamanho do lote, symbol=NULL, price, stop loss, take profit, comment="")
   trade.Sell(myLote_3, NULL, Bid, (Bid + myStopLoss_3 * _Point), (Bid - myTakeProfit_3 * _Point), "Robo = venda a mercado");
   return(true);
  }

//Comprar
bool SetBuy(double Ask)
  {
//trade.Buy(tamanho do lote, symbol=NULL, price, stop loss, take profit, comment="")
   trade.Buy(myLote_3, NULL, Ask, (Ask - myStopLoss_3 * _Point), (Ask + myTakeProfit_3 * _Point), "Robo = compra a mercado");
   return(true);
  }

//+------------------------------------------------------------------+
//| MÉTODOS ORDEM LIMITADA                                           |
//+------------------------------------------------------------------+
bool SetSellLimit(double myBandaSuperiorValue)
  {
// Número 6 é o index do nome FOREX 'Olhar cabeçalho do código'
   if(myAtivo == 6)
     {
      trade.SellLimit(myLote_3,
                      myBandaSuperiorValue + (myOrderLimit_3 * _Point), NULL,
                      myBandaSuperiorValue + ((myOrderLimit_3 + myStopLoss_3)* _Point),
                      myBandaSuperiorValue - ((myOrderLimit_3 + myTakeProfit_3)* _Point), ORDER_TIME_GTC, 0, "Robo Sell Limit");
     }
   else
      if(myAtivo == 0)
        {
         //(compra, stop loss, take profit) Calcular o número  multiplo de 5 mais proximo
         double preco = myBandaSuperiorValue + myOrderLimit_3;    // Soma o valor atual da Banda Superior com o Offset da Ordem Limitada
         double resto = MathMod(preco, 5);                        // Obtem o resto da divisão por 5
         myBandaSuperiorValue = preco - resto;                    // Remove o resto do preço de compra
         
         trade.SellLimit(myLote_3,
                         myBandaSuperiorValue, NULL,
                         myBandaSuperiorValue + myStopLoss_3,
                         myBandaSuperiorValue - myTakeProfit_3, ORDER_TIME_GTC, 0, "Robo Sell Limit");
        }
      else
        {         
         trade.SellLimit(myLote_3,
                         myBandaSuperiorValue + myOrderLimit_3, NULL,
                         myBandaSuperiorValue + (myOrderLimit_3 + myStopLoss_3),
                         myBandaSuperiorValue + myOrderLimit_3 - myTakeProfit_3, ORDER_TIME_GTC, 0, "Robo Sell Limit");
        }

   return(true);
  }

//Comprar
bool SetBuyLimit(double myBandaInferiorValue)
  {
// Número 6 é o index do nome FOREX 'Olhar cabeçalho do código'
   if(myAtivo == 6)
     {
      trade.BuyLimit(myLote_3,
                     myBandaInferiorValue - (myOrderLimit_3 * _Point), NULL,
                     myBandaInferiorValue - ((myOrderLimit_3 + myStopLoss_3)* _Point),
                     myBandaInferiorValue + ((myTakeProfit_3 - myOrderLimit_3)* _Point), ORDER_TIME_GTC, 0, "Robo Buy Limit");
     }
   else
      if(myAtivo == 0)
        {
         //(compra, stop loss, take profit) Calcular o número  multiplo de 5 mais proximo
         double preco = myBandaInferiorValue - myOrderLimit_3;    // Soma o valor atual da Banda Superior com o Offset da Ordem Limitada
         double resto = MathMod(preco, 5);                        // Obtem o resto da divisão por 5
         myBandaInferiorValue = preco - resto;                    // Remove o resto do preço de compra
                  
          trade.BuyLimit(myLote_3,
                         myBandaInferiorValue, NULL,
                         myBandaInferiorValue - myStopLoss_3,
                         myBandaInferiorValue + myTakeProfit_3, ORDER_TIME_GTC, 0, "Robo Sell Limit");         
        }
      else
        {
         trade.BuyLimit(myLote_3,
                        myBandaInferiorValue - myOrderLimit_3, NULL,
                        myBandaInferiorValue - (myOrderLimit_3 + myStopLoss_3),
                        myBandaInferiorValue - myOrderLimit_3 + myTakeProfit_3, ORDER_TIME_GTC, 0, "Robo Sell Limit");
        }
   return(true);
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
