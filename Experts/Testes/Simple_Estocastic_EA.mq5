//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   //if(!IsNewBar())
    //return;  

// Crie uma matriz para os preços
   MqlRates PriceInformation[];

// Organiza a matriz do candlestick atual que está sendo formado
   ArraySetAsSeries(PriceInformation, true);

// Organiza a matriz do candlestick atual que está sendo formado
   int Data = CopyRates(Symbol(), Period(), 0, Bars(Symbol(), Period()), PriceInformation);

//We create an empty string for the signal
   string signal = "";

// We create an array for the K-line und D-line
   double KArray[];
   double DArray[];

// Sort the array from the current candle downwards
   ArraySetAsSeries(KArray, true);
   ArraySetAsSeries(KArray, true);

// Defined EA, current candle, 3 candles, save result
   int StochasticDefinition = iStochastic(_Symbol, _Period, 5, 3, 3, MODE_SMA, STO_LOWHIGH);

// We fill the array with price data
   CopyBuffer(StochasticDefinition, 0, 0, 3, KArray);
   CopyBuffer(StochasticDefinition, 1, 0, 3, DArray);

// We calculate the value for the current candle
   double KValue0 = KArray[0];
   double DValue0 = DArray[0];

// We calculate the value for the last candle
   double KValue1 = KArray[1];
   double DValue1 = DArray[1];

// Se os dois valores estiverem acima de 80
   if(KValue0>80 && DValue0>80)
     {
      // If the K value has crossed the D value from above
      if(KValue0<DValue0 && KValue1>DValue1)
        {
         signal = "sell";
         Comment("sell");
         printf("sell");
         CriarSeta("vender", PriceInformation[0].high);
        }
     }
   else
      if(KValue0<20 && DValue0<20)
        {
         // If the K value has crossed the D value from above
         if(KValue0>DValue0 && KValue1<DValue1)
           {
            signal = "buy";
            Comment("buy");
            printf("buy");
            CriarSeta("comprar", PriceInformation[0].low);
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

// Calculate highest e Lowest candle price
   int HighestCandleNumber = iHighest(NULL, 0, MODE_HIGH, 100, 1);
   int LowestCandleNumber = iLowest(NULL, 0, MODE_LOW, 100, 1);

// Cria a seta
   if(acao == "vender")
      ObjectCreate(_Symbol, NumberOfCandlesText, OBJ_ARROW_SELL, 0, TimeCurrent()-60, (preco+10));
   else
      if
      (acao == "comprar")
         ObjectCreate(_Symbol, NumberOfCandlesText, OBJ_ARROW_BUY, 0, TimeCurrent()-60, (preco-10));

   MqlDateTime horaAtual;
   datetime hora = TimeToStruct(TimeCurrent(), horaAtual);
   
   printf (horaAtual.hour + ":" + horaAtual.min);
   return true;
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
