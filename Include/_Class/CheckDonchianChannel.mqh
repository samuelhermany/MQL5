//+------------------------------------------------------------------+
//|                                         CheckDonchianChannel.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

// #include <_Class/CheckDonchianChannel.mqh> // Biblioteca para a leitura do indicador DonchianChannel para itens acima ou abaixo das bandas
// CDonchianChannel donchianChannel
//+------------------------------------------------------------------+
//| LISTAS                                                           |
//+------------------------------------------------------------------+
enum list_extreme_points //Type of extreme points
  {
   HIGH_LOW,
   HIGH_LOW_OPEN,
   HIGH_LOW_CLOSE,
   OPEN_HIGH_LOW,
   CLOSE_HIGH_LOW
  };
//+------------------------------------------------------------------+
//| DEFINICÕES                                                       |
//+------------------------------------------------------------------+
class CDonchianChannel
  {
protected:
   double            _upperBandValue;
   double            _lowerBandValue;
   int               _handleDonchianChannels;
public:
   bool              _upperBand;
   bool              _lowerBand;

                     CDonchianChannel(void);
                    ~CDonchianChannel(void);
   double            CheckUpperBand(double lastTick, int period, list_extreme_points Extremes, int margins, int shift);
   double            CheckLowerBand(double lastTick, int period, list_extreme_points Extremes, int margins, int shift);

private:
   //--- Getter
   double            GetUpperBandValue(void);
   double            GetLowerBandValue(void);
   bool              GetSobrecomprado();
   bool              GetSobrevendido();
   bool              GetInfo(int period, list_extreme_points extreme, int margins, int shift);
   //--- Setter
   void              SetUpperBandValue(double value);
   void              SetLowerBandValue(double value);
   void              SetSobrecomprado(bool value);
   void              SetSobrevendido(bool value);
  };
//---
CDonchianChannel::CDonchianChannel(void)
  {

   Print("Início! contrutor CHECK DONCHIAN CHANNEL!");

  }
//---
CDonchianChannel::~CDonchianChannel(void)
  {

   Print("Fim! destrutor CHECK DONCHIAN CHANNEL!");

  }
//+------------------------------------------------------------------+
//| GET PROPERTIES                                                   |
//+------------------------------------------------------------------+
double CDonchianChannel::GetUpperBandValue(void)
  {

   return _upperBandValue;

  }
//---
double CDonchianChannel::GetLowerBandValue(void)
  {

   return _lowerBandValue;

  }
//---
bool CDonchianChannel::GetSobrecomprado(void)
  {

   return _upperBand;

  }
//---
bool CDonchianChannel::GetSobrevendido(void)
  {

   return _lowerBand;

  }
//+------------------------------------------------------------------+
//| SET PROPERTIES                                                   |
//+------------------------------------------------------------------+
void CDonchianChannel::SetUpperBandValue(double value)
  {

   _upperBandValue = value;

  }
//---
void CDonchianChannel::SetLowerBandValue(double value)
  {

   _lowerBandValue = value;

  }
//---
void CDonchianChannel::SetSobrecomprado(bool value)
  {

   _upperBand = value;

  }
//---
void CDonchianChannel::SetSobrevendido(bool value)
  {

   _lowerBand = value;

  }
//+------------------------------------------------------------------+
//| MÉTODOS PARA A VERIFICAÇÃO DOS STOCHASTIC OSCILATOR              |
//+------------------------------------------------------------------+
bool CDonchianChannel::GetInfo(int period, list_extreme_points extreme, int margins, int shift)
  {
// Criamos uma matriz para o UPPER e LOWER band
   double bufferUpperBand[];
   double bufferLowerrBand[];

// EA manipulador do indicador DONCHIAN CHANNELS
   _handleDonchianChannels = iCustom(_Symbol, _Period, "Examples/Download/Donchian_Channels.ex5",period, extreme, margins, shift);

// Preenchemos a matriz com dados de preços de até 3 velas
   CopyBuffer(_handleDonchianChannels, 0, 0, 3, bufferUpperBand);
   CopyBuffer(_handleDonchianChannels, 2, 0, 3, bufferLowerrBand);

// Classifique a matriz do candle atual em ordem
   ArraySetAsSeries(bufferLowerrBand, true);
   ArraySetAsSeries(bufferUpperBand, true);

// Arredonda as casas decimais para a do ativo atual
   _upperBandValue = NormalizeDouble(bufferUpperBand[0], Digits());
   _lowerBandValue = NormalizeDouble(bufferLowerrBand[0], Digits());

   return true;

  }
//---
double CDonchianChannel::CheckUpperBand(double lastTick, int period = 10, list_extreme_points extreme = HIGH_LOW, int margins = 2, int shift = 0)
  {
   _upperBand = false;

// Obtem handle e parametros
   if(!GetInfo(period, extreme, margins, shift))
      return 0;


   if(lastTick!=0 && _upperBandValue!=0)
     {
      // Se o ultimo tick estiver acima da banda superior
      if(lastTick > _upperBandValue)
        {
         Print("Preço está ACIMA da Banda Superior");
         _upperBand = true;
        }
     }

   return _upperBandValue;
  }
//---
double CDonchianChannel::CheckLowerBand(double lastTick, int period = 10, list_extreme_points extreme = HIGH_LOW, int margins = 2, int shift = 0)
  {
   _lowerBand = false;

// Obtem handle e parametros
   if(!GetInfo(period, extreme, margins, shift))
      return 0;

   if(lastTick!=0 && _lowerBandValue!=0)
     {
      // Se o ultimo tick estiver abaixo da banda inferior
      if(lastTick < _lowerBandValue)
        {
         Print("Preço está ABAIXO da Banda Inferior");
         _lowerBand = true;
        }
     }

   return _lowerBandValue;
  }
//+------------------------------------------------------------------+
