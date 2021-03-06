//+------------------------------------------------------------------+
//|                                                    CheckTime.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"

// #include <_Class/CheckTime.mqh> // Biblioteca para a leitura e verificãção de horários
// CTime time

MqlDateTime horaAtual;
//+------------------------------------------------------------------+
//| DEFINICÕES                                                       |
//+------------------------------------------------------------------+
class CTime
  {
protected:

public:
   bool              _horarioAbertura;
   bool              _newCandlestick;
                     CTime(void);
                    ~CTime(void);
   void              CheckHorarioAbertura(int aberturaHora, int aberturaMinuto, int fechamentoHora, int fechamentoMinuto);
   datetime          CheckNewCandlestick(datetime time_last);
private:
   //--- Getter
   bool              GetHorarioAbertura();
   bool              GetNewCandlestick();
   //--- Setter
   void              SetHorarioAbertura(bool value);
   void              SetNewCandlestick(bool value);
  };
//---
CTime::CTime(void)
  {

   Print("Início! contrutor CHECK TIME!");

  }
//---
CTime::~CTime(void)
  {

   Print("Fim! destrutor CHECK TIME!");

  }
//+------------------------------------------------------------------+
//| GET PROPERTIES                                                   |
//+------------------------------------------------------------------+
bool CTime::GetHorarioAbertura(void)
  {

   return _horarioAbertura;

  }
//---
bool CTime::GetNewCandlestick(void)
  {

   return _newCandlestick;

  }
//+------------------------------------------------------------------+
//| SET PROPERTIES                                                   |
//+------------------------------------------------------------------+
void CTime::SetHorarioAbertura(bool value)
  {

   _horarioAbertura = value;

  }
//---
void CTime::SetNewCandlestick(bool value)
  {

   _newCandlestick = value;

  }
//+------------------------------------------------------------------+
//| VERIFICA SE O HORÁRIO ATUAL ESTÁ DENTRO DO HORÁRIO DE ABERTURA   |
//+------------------------------------------------------------------+
void CTime::CheckHorarioAbertura(int aberturaHora = 9, int aberturaMinuto = 15, int fechamentoHora = 17, int fechamentoMinuto = 30)
  {
   _horarioAbertura = false;

   TimeToStruct(TimeCurrent(), horaAtual);

//Se hora atual >= hora de abertura e atual <= hora de fechamento
   if(horaAtual.hour >= aberturaHora && horaAtual.hour <= fechamentoHora)
     {
      //Se hora atual > hora de abertura e hora atual < hora fechamento
      if(horaAtual.hour > aberturaHora && horaAtual.hour < fechamentoHora)
        {
         _horarioAbertura = true;
        }
      //Se hora atual = hora de abertura
      else
         if(horaAtual.hour == aberturaHora)
           {
            //Se minuto atual = minuto de abertura
            if(horaAtual.min >= aberturaMinuto)
               _horarioAbertura = true;
           }
         else
            if(horaAtual.hour == fechamentoHora)
              {
               //Se minuto atual = minuto de fechamento
               if(horaAtual.min <= fechamentoMinuto)
                  _horarioAbertura = true;
              }
     }
  }
//+------------------------------------------------------------------+
//| VERIFICA CADA NOVO CANDLESTICK QUE FOR FORMADO                   |
//+------------------------------------------------------------------+
datetime CTime::CheckNewCandlestick(datetime time_last)
  {
   _newCandlestick = false;

// Memoriza o tempo de abertura do último candelstick na variável
   datetime time_actual = (datetime)SeriesInfoInteger(Symbol(), Period(), SERIES_LASTBAR_DATE);

// Se for a primeira chamada da função
   if(time_last == 0)
     {
      return time_actual;
     }
// Se os tempos forem diferentes
   else
      if(time_last != time_actual)
        {
         _newCandlestick = true;
         return time_actual;
        }

// Retorna o tempo atual
   return time_last;
  }
//+------------------------------------------------------------------+
