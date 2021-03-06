//+------------------------------------------------------------------+
//|                                     CheckStochasticOscilator.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

// #include <_Class/CheckStochastic.mqh> // Biblioteca para a leitura do indicador Stochastic para itens sobrecomprado ou sobrevendido
// CStochastic stochastic
//+------------------------------------------------------------------+
//| DEFINICÕES                                                       |
//+------------------------------------------------------------------+
class CStochastic
  {
protected:
   double            _kValue0;
   double            _dValue0;
   double            _kValue1;
   double            _dValue1;
   int               _handleStochastic;

public:
   bool              _sobrecomprado;
   bool              _sobrevendido;

                     CStochastic(void);
                    ~CStochastic(void);
   void              CheckSobrecomprado(int sobrecomprado, int k_periodo, int d_periodo, int slowing);
   void              CheckSobrevendido(int sobrevendido, int k_periodo, int d_periodo, int slowing);
   //void              CheckCruzamento(void);

private:
   //--- Getter
   double            GetKValue0();
   double            GetDValue0();
   double            GetKValue1();
   double            GetDValue1();
   bool              GetSobrecomprado();
   bool              GetSobrevendido();
   bool              GetInfo(int k_periodo, int d_periodo, int slowing);
   //--- Setter
   void              SetKValue0(double value);
   void              SetDValue0(double value);
   void              SetKValue1(double value);
   void              SetDValue1(double value);
   void              SetSobrecomprado(bool value);
   void              SetSobrevendido(bool value);
  };
//---
CStochastic::CStochastic(void)
  {

   Print("Início! contrutor CHECK STOCHASTIC OSCILATOR!");

  }
//---
CStochastic::~CStochastic(void)
  {

   Print("Fim! destrutor CHECK STOCHASTIC OSCILATOR!");

  }
//+------------------------------------------------------------------+
//| GET PROPERTIES                                                   |
//+------------------------------------------------------------------+
double CStochastic::GetKValue0(void)
  {

   return _kValue0;

  }
//---
double CStochastic::GetDValue0(void)
  {

   return _dValue0;

  }
//---
double CStochastic::GetKValue1(void)
  {

   return _kValue1;

  }
//---
double CStochastic::GetDValue1(void)
  {

   return _dValue1;

  }
//---
bool CStochastic::GetSobrecomprado(void)
  {

   return _sobrecomprado;

  }
//---
bool CStochastic::GetSobrevendido(void)
  {

   return _sobrevendido;

  }
//+------------------------------------------------------------------+
//| SET PROPERTIES                                                   |
//+------------------------------------------------------------------+
void CStochastic::SetKValue0(double value)
  {

   _kValue0 = value;

  }
//---
void CStochastic::SetDValue0(double value)
  {

   _dValue0 = value;

  }
//---
void CStochastic::SetKValue1(double value)
  {

   _kValue1 = value;

  }
//---
void CStochastic::SetDValue1(double value)
  {

   _dValue1 = value;

  }
//---
void CStochastic::SetSobrecomprado(bool value)
  {

   _sobrecomprado = value;

  }
//---
void CStochastic::SetSobrevendido(bool value)
  {

   _sobrevendido = value;

  }
//+------------------------------------------------------------------+
//| MÉTODOS PARA A VERIFICAÇÃO DOS STOCHASTIC OSCILATOR              |
//+------------------------------------------------------------------+
bool CStochastic::GetInfo(int k_periodo, int d_periodo, int slowing)
  {
// Criamos uma matriz para o K-line e D-line
   double bufferK[];
   double bufferD[];

// EA manipulador do indicador STOCHASTIC
   int handleStochastic = iStochastic(_Symbol, _Period, k_periodo, d_periodo, slowing, MODE_SMA, STO_LOWHIGH);

// Preenchemos a matriz com dados de preços de até 3 velas
   CopyBuffer(handleStochastic, 0, 0, 3, bufferK);
   CopyBuffer(handleStochastic, 1, 0, 3, bufferD);

// Classifique a matriz do candle atual em ordem
   ArraySetAsSeries(bufferK, true);
   ArraySetAsSeries(bufferD, true);
   
// Calculamos o valor do candle atual e arredonda as casas decimais para a do ativo atual
   _kValue0 = NormalizeDouble(bufferK[0], Digits());
   _dValue0 = NormalizeDouble(bufferD[0], Digits());

// Calculamos o valor do último candle e arredonda as casas decimais para a do ativo atual
   _kValue1 = NormalizeDouble(bufferK[1], Digits());
   _dValue1 = NormalizeDouble(bufferD[1], Digits());

   return true;
  }
//---
void CStochastic::CheckSobrecomprado(int sobrecomprado = 80, int k_periodo = 5, int d_periodo = 3, int slowing = 3)
  {
   _sobrecomprado = false;
   
// Obtem handle e parametros
   if(!GetInfo(k_periodo, d_periodo, slowing))
      return;

   if(_kValue0!=0 && _dValue0!=0)
     {
      // Se os dois valores estiverem acima de 80 = SOBRECOMPRADO
      if(_kValue0>sobrecomprado && _dValue0>sobrecomprado)
        {
         Print("Preço está SOBRECOMPRADO");
         _sobrecomprado = true;
        }
     }
  }
//---
void CStochastic::CheckSobrevendido(int sobrevendido = 20, int k_periodo = 5, int d_periodo = 3, int slowing = 3)
  {
   _sobrevendido = false;

// Caso o retorno não seja verdadeiro(true)
   if(!GetInfo(k_periodo, d_periodo, slowing))
      return;

   if(_kValue0!=0 && _dValue0!=0)
     {
      // Se os dois valores estiverem abaixo de 20 = SOBREVENDIDO
      if(_kValue0<sobrevendido && _dValue0<sobrevendido)
        {
         Print("Preço está SOBREVENDIDO");
         _sobrevendido = true;
        }
     }
  }
//+------------------------------------------------------------------+
