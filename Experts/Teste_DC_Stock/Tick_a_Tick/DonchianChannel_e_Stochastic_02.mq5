//+------------------------------------------------------------------+
//|                              DonchianChannel_e_Stochastic_02.mq5 |
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
#include <_Class/CheckTime.mqh>              // Biblioteca para a leitura e verificação de horários
#include <_Class/Setas.mqh>                  // Biblioteca para criação de setas

CStochastic stochastic;
CDonchianChannel donchianChannel;
CTime time;
CSetas setas;
//+------------------------------------------------------------------+
//| INPUTS                                                           |
//+------------------------------------------------------------------+
input group "Horários"
input int _startHora = 9;                 // Hora inicial      (09)
input int _startMinuto = 03;              // Minuto inicial    (01)
input int _fechamentoHora = 17;           // Hora de término   (17)
input int _fechamentoMinuto = 30;         // Minuto de término (30)
//+------------------------------------------------------------------+
//| VARIÁVEIS                                                        |
//+------------------------------------------------------------------+
MqlTick tick;
static datetime _time_last;
static datetime _time_actual;
static string _horaUltimaOrdem;
bool _sinalCompra;
bool _sinalVenda;
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
   _time_last = _time_actual;

// Verifica se o horário atual confere com o período de operaç~eos determinado
   time.CheckHorarioAbertura(_startHora, _startMinuto);
   if(!time._horarioAbertura)
      return;

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

// Alimenta os  dados da váriavel tick
   SymbolInfoTick(_Symbol, tick);
   double price01 = tick.last;

// Verifica se o último preço estáq acima da banda superio ou abaixo das banda inferior
   donchianChannel.CheckUpperBand(tick.last);
   donchianChannel.CheckLowerBand(tick.last);

// Se o preço estiver ACIMA do canal superior no indicador DONCHIAN CHANNEL
   if(donchianChannel._upperBand)
     {
      Print("DONCHIAN_CHANNEL sobrecomprado");

      // Verifica se o estocástico está sobrecomprado
      stochastic.CheckSobrecomprado();

      if(stochastic._sobrecomprado)
        {
         Print("STOCHASTIC sobrecomprado");
        }
      else
        {
         // Captura o horário atual
         string horaAtual = TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES);

         if(_horaUltimaOrdem != horaAtual)
           {
            Print("VENDER = " + TimeCurrent());
            _sinalVenda = true;
            _horaUltimaOrdem = horaAtual;
            setas.CriarSetaDeVenda(tick.last);
           }
         else
            if(_horaUltimaOrdem == horaAtual)
               return;
        }
     }
// Se o preço estiver ABAIXO do canal superior no indicador DONCHIAN CHANNEL
   else
      if(donchianChannel._lowerBand)
        {
         Print("DONCHIAN_CHANNEL sobrevendido");

         // Verifica se o estocástico está sobrevendido
         stochastic.CheckSobrevendido();

         if(stochastic._sobrevendido)
           {
            Print("STOCHASTIC sobrevendido");
           }
         else
           {
            // Captura o horário atual
            //string horaAtual = TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES);

            if(_horaUltimaOrdem != horaAtual)
              {
               Print("COMPRAR = " + TimeCurrent());
               _sinalCompra = true;
               _horaUltimaOrdem = horaAtual;
               setas.CriarSetaDeCompra(tick.last);
              }
            else
               if(_horaUltimaOrdem == horaAtual)
                  return;
           }
        }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
/*
// Verifica se um novo candlestick foi criado
   _time_actual = time.CheckNewCandlestick(_time_last);
   if(!time._newCandlestick)
      return;
      */
//+------------------------------------------------------------------+
