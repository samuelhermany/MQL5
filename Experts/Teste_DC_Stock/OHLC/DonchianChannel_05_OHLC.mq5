//+------------------------------------------------------------------------------------+
//|                                           DonchianChannel_e_Stochastic_03_OHLC.mq5 |
//|                                          Copyright 2020, MetaQuotes Software Corp. |
//|                                                               https://www.mql5.com |
//| Robo compra a vendamercado fora do Donchian Channel (#include <_Class/Ordens.mqh>) |
//|                                                                Robo com breakeaven |
//|                                                                    Robo Stop Movel |
//+---------------------------------------------------------------------------------+
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
#property link "https://www.mql5.com"
#property version "1.00"
//+------------------------------------------------------------------+
//| INCLUDE                                                          |
//+------------------------------------------------------------------+
#include <_Class/CheckDonchianChannel.mqh> // Biblioteca para a leitura do indicador DonchianChannel para itens acima ou abaixo das bandas
#include <_Class/CheckTime.mqh>            // Biblioteca para a leitura e verificação de horários
#include <_Class/Ordens.mqh>               // Biblioteca otimizada para a operaçãoes de compra e venda
//#include <Trade/Trade.mqh>                 // Biblioteca para realizar operações de compra e venda
//#include <_Class/CheckStochastic.mqh>      // Biblioteca para a leitura do indicador Stochastic para itens sobrecomprado ou sobrevendido
//#include <_Class/Objetos.mqh>              // Biblioteca para criação de objetos(seta compra, seta de venda, linha vertical, linha horizontal)

CDonchianChannel donchianChannel;
CTime time;
COrdens ordens;

//CTrade trade;
//CStochastic stochastic;
//CObjetos objetos;

//+------------------------------------------------------------------+
//| LISTAS                                                           |
//+------------------------------------------------------------------+
enum LIST_BREAKEVEN
{
   SIM, // SIM
   NAO  // NÃO
};
//+------------------------------------------------------------------+
//| VARIÁVEIS GLOBAIS                                                |
//+------------------------------------------------------------------+
MqlTick _tick;
static int _contadorTick;
static datetime _time_last;
static datetime _time_actual;
static string _horaUltimaOrdem;
bool _sinalCompra;
bool _sinalVenda;
bool _breakevenAtivado = false;
double _ptsBreakeven = 20;
double SL, TP, BH;
int _handleDonchianChannels;

string pathIndicator = "Examples/Download/Donchian_Channels.ex5";
//+------------------------------------------------------------------+
//| INPUTS                                                           |
//+------------------------------------------------------------------+
input group "Horários" input int _startHora = 9; // Hora inicial
input int _startMinuto = 08;                     // Minuto inicial
input int _fechamentoHora = 17;                  // Hora de término
input int _fechamentoMinuto = 30;                // Minuto de término

input group "Donchian Channel"
input int periodo = 10;                          // Período
input int type = 0;                              // Tipo
input int margins = 2;                           // Margin
input int shift = 0;                             // Shift

input group "Informções lote"
input double lote = 1;                           // Lote
input double pts_TP = 0;                         // Take Profit
input double pts_SL = 35;                        // Stop Loss
input LIST_BREAKEVEN _stopMovel = SIM;           // Stop Móvel
input double pts_stopMovel = 40;               // Stop Móvel pontos
input LIST_BREAKEVEN _breakeven = SIM;           // Breakeven
input double pts_BH = 8;                         // Breakheven pontos
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{   
   _handleDonchianChannels = iCustom(_Symbol, _Period, pathIndicator, periodo, type, margins, shift);

   if (_handleDonchianChannels < 0)
   {
      Alert("Tivemos problemas ao carregar o indicador - ", GetLastError());
      return (INIT_FAILED);
   }

   // Adicioana o indicador DONCHIAN CHANNELS a janela principal do gráfico
   ChartIndicatorAdd(0, 0, _handleDonchianChannels);

   //Print("Ativo = ", _Symbol, ", Digits = ", _Digits, ", Point = ", _Point);
   // Ajusta o TAKE PROFIT e o STOP LOSS para o ativo atual
   switch (_Digits)
   {
   case 0: // Estamos no INDICE (Ativo = WIN$D, Digits = 0, Point = 1.0)
      Print("Estamos no ÍNDICE");
      SL = pts_SL * 1;
      TP = pts_TP * 1;
      break;
   case 3: // Estamos no DÓLAR (Ativo = WDO$D, Digits = 3, Point = 0.001)
      Print("Estamos no DÓLAR");
      SL = pts_SL * 1000;
      TP = pts_TP * 1000;
      break;
   case 2: // Estamos nas AÇÕESR (Ativo = BIDI4, Digits = 2, Point = 0.01)
      Print("Estamos nas AÇÕES");
      SL = pts_SL * 100;
      TP = pts_TP * 100;
      break;
   default:
      break;
   }

   return (INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   IndicatorRelease(_handleDonchianChannels);

   // Limpa o gráfico
   ChartApplyTemplate(0, "default");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Verifica se o horário atual confere com o período de operaç~eos determinado
   time.CheckHorarioAbertura(_startHora, _startMinuto);
   if (!time._horarioAbertura)
      return;

   Comment("Horário atual: ", TimeCurrent());

   // Crie uma matriz para os preços
   SymbolInfoTick(_Symbol, _tick);
   double lastTick = _tick.last;

   // Verifica se um novo candlestick foi criado
   //_time_actual = time.CheckNewCandlestick(_time_last);
   //_time_last = _time_actual;

   // Captura o horário atual
   string horaAtual = TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES);

   // Se estamos com alguma ordem aberta de compra ou de venda pro candle atual
   if (_sinalCompra == true || _sinalVenda == true)
   {
      // Se os horários forem  diferentes significa que estamos em outro candlestick
      if (horaAtual != _horaUltimaOrdem)
      {
         _sinalCompra = false;
         _sinalVenda = false;
      }
      else
         return;
   }

   // Verifica se o último preço estáq acima da banda superio ou abaixo das banda inferior
   double preco_DC_UP = donchianChannel.CheckUpperBand(lastTick);
   double preco_DC_LOW = donchianChannel.CheckLowerBand(lastTick);

   // Se o preço estiver ACIMA do canal superior no indicador DONCHIAN CHANNEL
   if (donchianChannel._upperBand)
   {
      if (_horaUltimaOrdem != horaAtual)
      {
         Print("VENDER = " + TimeCurrent());
         _sinalVenda = true;
         _horaUltimaOrdem = horaAtual;
         // objetos.CriarSetaDeVenda(PriceInformation[1].high);
      }
      else if (_horaUltimaOrdem == horaAtual)
         return;
   }
   // Se o preço estiver ABAIXO do canal superior no indicador DONCHIAN CHANNEL
   else if (donchianChannel._lowerBand)
   {
      if (_horaUltimaOrdem != horaAtual)
      {
         Print("COMPRAR = " + TimeCurrent());
         _sinalCompra = true;
         _horaUltimaOrdem = horaAtual;
         //objetos.CriarSetaDeCompra(PriceInformation[1].low);
      }
      else if (_horaUltimaOrdem == horaAtual)
         return;
   }

   // Executa compra ou venda caso exista um sinal de compra ou de venda
   if (_sinalCompra || _sinalVenda)
      RealizaCompraOuVenda();

   if (PositionsTotal() > 0)
   {
      // Verifica o BREAKEVEN
      //if (_breakeven == SIM)
      //   VerificaBreakeven();

      // Atualiza o STOP MÓVEL se ele  estiver ativo
      if (_stopMovel == SIM)
         ordens.CheckStopMovel(_tick.last, pts_stopMovel);
   }
}
//+------------------------------------------------------------------+
//|  OPERAÇÕES DE COMPRA E VENDA A MERCADO                           |
//+------------------------------------------------------------------+
void RealizaCompraOuVenda()
{
   // Calcula o preço ASK(venda) e // Calcula o preço BID(compra)
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

   // Se o _sinalCompra  for igau la true então abre ordem de compra, do contrário obrigatóriamente _sinalVenda = true abre ordem de venda
   bool result = _sinalCompra == true ? ordens.SetComprarAMercado(lote, Ask, SL, TP) : ordens.SetVenderAMercado(lote, Bid, SL, TP);
}
//+------------------------------------------------------------------+