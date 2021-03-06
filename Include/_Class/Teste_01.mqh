//+------------------------------------------------------------------+
//|                                                     Teste_01.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
// #include <_Class/Teste_01.mqh> // Biblioteca para criação de teste
// CPessoa p//---
class CPessoa
  {
protected:
   string            _nome;
   int               _sobrenome;
   bool              _nascimento;
public:
                     CPessoa(void);
                    ~CPessoa(void);
   //--- Getter
   string            GetNome(void);
   string            GetSobrenome(void);
   datetime          GetNascimento(void);

   //--- Setter
   void              SetNome(string nome);
   void              SetSobrenome(string sobrenome);
   void              SetNascimento(datetime nascimento);
  };
//---
CPessoa::CPessoa(void)
  {

   Print("Olá Estamos dentro do contrutor pessoa!");

  }
//---
CPessoa::~CPessoa(void)
  {

   Print("Até mais! Estamos dentro do destrutor pessoa!");

  }
//---
string CPessoa::GetNome(void)
  {

   return _nome;

  }
//---
string CPessoa::GetSobrenome(void)
  {

   return _sobrenome;

  }
//---
datetime CPessoa::GetNascimento(void)
  {

   return _nascimento;

  }
//---
void CPessoa::SetNome(string nome)
  {

   _nome=nome;
   Print("Nome: ", nome);

  }
//---
void CPessoa::SetSobrenome(string sobrenome)
  {

   _sobrenome=sobrenome;
   Print("Sobrenome: ", sobrenome);

  }
//---
void CPessoa::SetNascimento(datetime nascimento)
  {

   _nascimento=nascimento;
   Print("Data Nascimento: ", nascimento);

  }