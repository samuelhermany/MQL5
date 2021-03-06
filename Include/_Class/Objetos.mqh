//+------------------------------------------------------------------+
//|                                                     Teste_01.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
// #include <_Class/Objetos.mqh> // Biblioteca para criação de objetos(seta compra, seta de venda, linha vertical, linha horizontal)
// CObjetos objetos
//+------------------------------------------------------------------+
//| DEFINICÕES                                                       |
//+------------------------------------------------------------------+
class CObjetos
  {
protected:
   double            _preco;
   bool              _seta;
public:
                     CObjetos(void);
                    ~CObjetos(void);
   bool              CriarSetaDeCompra(double preco);
   bool              CriarSetaDeVenda(double preco);
   bool              DesenhaLinhaHorizontal(string nome, double price, color cor);
   bool              DesenhaLinhaVertical(string nome, datetime time, color cor);
   
private:
   //--- Getter
   double            GetPreco(void);
   //--- Setter
   void              SetPreco(double preco);
  };
//---
CObjetos::CObjetos(void)
  {

   Print("Início! contrutor SETAS!");

  }
//---
CObjetos::~CObjetos(void)
  {

   Print("Fim! destrutor SETAS!");

  }
//---
double CObjetos::GetPreco(void)
  {

   return _preco;

  }
//---
void CObjetos::SetPreco(double preco)
  {

   _preco = preco;

  }
//+------------------------------------------------------------------+
//| MÉTODOS PARA A CRIAÇÃO DAS LINHAS HORIZONTAL E VERTICAL          |
//+------------------------------------------------------------------+
bool DesenhaLinhaHorizontal(string nome, double price, color cor = clrAliceBlue)
  {
   ObjectDelete(0, nome);
   ObjectCreate(0, nome, OBJ_HLINE, 0, 0, price);
   ObjectSetInteger(0, nome, OBJPROP_COLOR, nome);

   return true;
   /*
      if(nome == "compra" || nome == "compra"  || nome == "COMPRA")
         ObjectSetInteger(0, nome, OBJPROP_COLOR, clrAliceBluecor);
      else
         if(nome == "Venda" || nome == "venda"  || nome == "VENDA")
            ObjectSetInteger(0, nome, OBJPROP_COLOR, clrYellow);
   */
  }
//---
bool DesenhaLinhaVertical(string nome, datetime time = "hora atual", color cor = clrYellow)
  {
   ObjectDelete(0, nome);
   ObjectCreate(0, nome, OBJ_VLINE, 0, TimeCurrent(), 0);
   ObjectSetInteger(0, nome, OBJPROP_COLOR, cor);

   return true;
   /*
      if(nome == "compra" || nome == "compra"  || nome == "COMPRA")
         ObjectSetInteger(0, nome, OBJPROP_COLOR, clrAliceBluecor);
      else
         if(nome == "Venda" || nome == "venda"  || nome == "VENDA")
            ObjectSetInteger(0, nome, OBJPROP_COLOR, clrYellow);
   */
  }
//+------------------------------------------------------------------+
//| MÉTODOS PARA A CRIAÇÃO DAS SETAS                                 |
//+------------------------------------------------------------------+
bool CObjetos::CriarSetaDeCompra(double preco)
  {
   string numeroDeCandles = GetInfo();

   if(numeroDeCandles != NULL)
      ObjectCreate(_Symbol, numeroDeCandles, OBJ_ARROW_BUY, 0, TimeCurrent() - 60, (preco - 10));

   Print("Seta de COMPRA criada");

   return true;
  }
//---
bool CObjetos::CriarSetaDeVenda(double preco)
  {
   string numeroDeCandles = GetInfo();

   if(numeroDeCandles != NULL)
      ObjectCreate(_Symbol, numeroDeCandles, OBJ_ARROW_SELL, 0, TimeCurrent(), (preco + 10));

   Print("Seta de VENDA criada");

   return true;
  }
//+------------------------------------------------------------------+
//| Obtem informações para posicionar a seta                         |
//+------------------------------------------------------------------+
string GetInfo()
  {
// Converter número de candles em string
   string numeroDeCandles = IntegerToString(Bars(Symbol(), Period()));

   return numeroDeCandles;
  }
//+------------------------------------------------------------------+
