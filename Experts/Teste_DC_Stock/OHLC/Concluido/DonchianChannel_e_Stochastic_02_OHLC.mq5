//+------------------------------------------------------------------+
//|                         DonchianChannel_e_Stochastic_02_OHLC.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//|            *** Robo compra a mercado fora do Donchian Channel ***|
//|            *** Robo venda a mercado fora do Donchian Channel  ***|
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| INCLUDE                                                          |
//+------------------------------------------------------------------+
#include <_Class/CheckStochastic.mqh>        // Biblioteca para a leitura do indicador Stochastic para itens sobrecomprado ou sobrevendido
#include <_Class/CheckDonchianChannel.mqh>   // Biblioteca para a leitura do indicador DonchianChannel para itens acima ou abaixo das bandas
#include <_Class/CheckTime.mqh>              // Biblioteca para a leitura e verificação de horários
#include <Trade/Trade.mqh>                   // Biblioteca para realizar operações de compra e venda
#include <_Class/Setas.mqh>                  // Biblioteca para criação de setas

CStochastic stochastic;
CDonchianChannel donchianChannel;
CTime time;
CTrade trade;
CSetas setas;
//+------------------------------------------------------------------+
//| INPUTS                                                           |
//+------------------------------------------------------------------+
input group "Horários"
input int _startHora = 9;                    // Hora inicial      (09)
input int _startMinuto = 01;                 // Minuto inicial    (01)
input int _fechamentoHora = 17;              // Hora de término   (17)
input int _fechamentoMinuto = 30;            // Minuto de término (30)

input group "Informções Lote"
input double Lote = 1;                          // Tamanho do LOTE
input double pts_SL = 100;                          // Tamanho do STOP LOSS
input double pts_TK = 50;                           // Tamanho do TAKE PROFIT
input double pts_BH = 8;                            // Tamanho do BREAK HEAVEN

//+------------------------------------------------------------------+
//| VARIÁVEIS GLOBAIS                                                |
//+------------------------------------------------------------------+
MqlTick tick;
static datetime _time_last;
static datetime _time_actual;
static string _horaUltimaOrdem;
bool _sinalCompra;
bool _sinalVenda;
double SL, TK, BH;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("Ativo = ", _Symbol, ", Digits = ", _Digits, ", Point = ", _Point);


// Ajusta o TAKE PROFIT e o STOP LOSS para o ativo atual
   switch(_Digits)
     {
      case  0:                      // Estamos no INDICE (Ativo = WIN$D, Digits = 0, Point = 1.0)
         Print("Estamos no ÍNDICE");
         SL = pts_SL * 1;
         TK = pts_TK * 1;
         break;
      case  3:                      // Estamos no DÓLAR (Ativo = WDO$D, Digits = 3, Point = 0.001)
         Print("Estamos no DÓLAR");
         SL = pts_SL * 1000;
         TK = pts_TK * 1000;
         break;
      case  2:                      // Estamos nas AÇÕESR (Ativo = BIDI4, Digits = 2, Point = 0.01)
         Print("Estamos nas AÇÕES");
         SL = pts_SL * 100;
         TK = pts_TK * 100;
         break;
      default:
         break;
     }


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
// Verifica se um novo candlestick foi criado
   _time_actual = time.CheckNewCandlestick(_time_last);
   if(!time._newCandlestick)
     {
      _time_last = _time_actual;
      return;
     }
   else
      _time_last = _time_actual;

// Verifica se o horário atual confere com o período de operaç~eos determinado
   time.CheckHorarioAbertura(_startHora, _startMinuto);
   if(!time._horarioAbertura)
      return;

// Captura o horário atual
   string horaAtual = TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES);

// Se estamos com alguma ordem aberta de compra ou de venda pro candle atual
   if(_sinalCompra==true || _sinalVenda==true)
     {
      // Se os horários forem  diferentes significa que estamos em outro candlestick
      if(horaAtual != _horaUltimaOrdem)
        {
         _sinalCompra=false;
         _sinalVenda=false;
        }
      else
         return;
     }


// Crie uma matriz para os preços
   MqlRates PriceInformation[];
   ArraySetAsSeries(PriceInformation, true);
   CopyRates(Symbol(), Period(), 0, Bars(Symbol(), Period()), PriceInformation);

// Verifica se o último preço estáq acima da banda superio ou abaixo das banda inferior
   donchianChannel.CheckUpperBand(PriceInformation[1].high);
   donchianChannel.CheckLowerBand(PriceInformation[1].low);

// Se o preço estiver ACIMA do canal superior no indicador DONCHIAN CHANNEL
   if(donchianChannel._upperBand)
     {
      if(_horaUltimaOrdem != horaAtual)
        {
         Print("VENDER = " + TimeCurrent());
         _sinalVenda = true;
         _horaUltimaOrdem = horaAtual;
         // setas.CriarSetaDeVenda(PriceInformation[1].high);
        }
      else
         if(_horaUltimaOrdem == horaAtual)
            return;
     }
// Se o preço estiver ABAIXO do canal superior no indicador DONCHIAN CHANNEL
   else
      if(donchianChannel._lowerBand)
        {
         if(_horaUltimaOrdem != horaAtual)
           {
            Print("COMPRAR = " + TimeCurrent());
            _sinalCompra = true;
            _horaUltimaOrdem = horaAtual;
            //setas.CriarSetaDeCompra(PriceInformation[1].low);
           }
         else
            if(_horaUltimaOrdem == horaAtual)
               return;
        }

// Executa compra ou venda caso exista um sinal de compra ou de venda
   RealizaCompraOuVenda();

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RealizaCompraOuVenda()
  {
   if(_sinalCompra)
     {
      // Calcula o preço ASK(venda)
      double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

      SetBuy(Ask);
     }
   else
      if(_sinalVenda)
        {
         // Calcula o preço BID(compra)
         double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

         SetSell(Bid);
        }
  }
//+------------------------------------------------------------------+
//|  OPERAÇÕES DE COMPRA E VENDA A MERCADO                           |
//+------------------------------------------------------------------+
//Comprar
bool SetBuy(double Ask)
  {
//trade.Buy(tamanho do lote, symbol=NULL, price, stop loss, take profit, comment="")
   trade.Buy(Lote, _Symbol, Ask, NormalizeDouble((Ask - SL * _Point),_Digits),
             NormalizeDouble((Ask + TK * _Point),_Digits), "Robo = compra a mercado");
   return(true);
  }
// Vender -----------------------------------------------------------+
bool SetSell(double Bid)
  {
//trade.Sell(tamanho do lote, symbol=NULL, price, stop loss, take profit, comment="")
   trade.Sell(Lote, _Symbol, Bid, NormalizeDouble((Bid + SL * _Point),_Digits),
              NormalizeDouble((Bid - TK * _Point),_Digits), "Robo = venda a mercado");
   return(true);
  }


//+------------------------------------------------------------------+
