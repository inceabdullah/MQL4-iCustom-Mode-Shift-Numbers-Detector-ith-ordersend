//+------------------------------------------------------------------+
//|                                                signal-count-with-trade.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com | inceabdullah@yahoo.com
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters

input string IndName1="Tipu CCI"; // Indicator Name
 string IndName="mts/"+IndName1;


input bool trade_test = false; //Trade Test

input int num_mode_sell=6; //Sell Mode 
input int num_mode_buy=7; //Buy Mode 
input int num_shift=0; //Shift
input int method_num = 6; //Method Number
input double Lots = .1;
input int SL = 2000;
input int TP = 500;





double GetInd_iCustom[101];
double GetInd_iCustom_old[101];
double GetInd_iCustom_changed[101];
double GetInd_iCustom_maxInt[101];
double GetInd_iCustom_minInt[101];
double GetInd_iCustom_Zero[101];
double GetInd_iCustom_NewNotMax[101];
double GetInd_iCustom_OldNotMax[101];

double ConsExp;
double ConsExp_old;

string GetInd_iCustom_changed_Cons;
string GetInd_iCustom_maxInt_Cons;
string GetInd_iCustom_minInt_Cons;
string GetInd_iCustom_Zero_Cons;
string GetInd_iCustom_NewNotMax_Cons;
string GetInd_iCustom_OldNotMax_Cons;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetInd()

  {
  


   for(int iiCustomFOR=0; iiCustomFOR<=7; iiCustomFOR++)
     {
      for(int jiCustomFOR=0; jiCustomFOR<=1; jiCustomFOR++)
        {

         ConsExp_old=GetInd_iCustom[(iiCustomFOR*10)+jiCustomFOR];
         GetInd_iCustom_old[(iiCustomFOR*10)+jiCustomFOR]=ConsExp_old;
         ConsExp=iCustom(NULL,0,IndName,iiCustomFOR,jiCustomFOR);
         GetInd_iCustom[(iiCustomFOR*10)+jiCustomFOR]=ConsExp;



        }


     }


  }
  
  
void trade_buy_sell(int mode_number)
   {
   
int cur_trade;   
   
   if(mode_number ==  num_mode_buy)
      {
      
      cur_trade = 1;
      
      }
      
   else if(mode_number !=  num_mode_buy)      
      {
      
      cur_trade = 0;      
      
      }
   
   
   if(cur_trade == 1) // It means that this trade for order
      {
      
      if(!OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, Bid-SL*Point, Bid+TP*Point, "buyy", 11223, 0, clrAliceBlue))
      PrintFormat("OrderSend error %d",GetLastError());     // if unable to send the request, output the error code      
      
      
      }
      
   if(cur_trade == 0) // It means that this trade for order
      {
      
      if(!OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, Ask+SL*Point, Ask-TP*Point, "sell", 11224, 0, clrRed))
      PrintFormat("OrderSend error %d",GetLastError());     // if unable to send the request, output the error code
      
      
      
      }      
   
   
   
   } 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeChanged()
  {

   for(int iiCustomFOR=0; iiCustomFOR<=7; iiCustomFOR++)
     {
      for(int jiCustomFOR=0; jiCustomFOR<=1; jiCustomFOR++)
        {
         if(GetInd_iCustom_old[(iiCustomFOR*10)+jiCustomFOR]!=GetInd_iCustom[(iiCustomFOR*10)+jiCustomFOR]) // if different before it was M 1
           {
            GetInd_iCustom_changed_Cons=GetInd_iCustom_changed[(iiCustomFOR*10)+jiCustomFOR]+1;
            GetInd_iCustom_changed[(iiCustomFOR*10)+jiCustomFOR]=GetInd_iCustom_changed_Cons;
            
            if( trade_test == true && method_num == 1 && (num_mode_sell == iiCustomFOR || num_mode_buy == iiCustomFOR) && num_shift == jiCustomFOR)
               {
               
               trade_buy_sell(iiCustomFOR); //iiCustomFOR will help decition if this trade buy or sell
               
               }

           }

         if(GetInd_iCustom[(iiCustomFOR*10)+jiCustomFOR]==2147483647) // if different before it was                     M 2
           {
            GetInd_iCustom_maxInt_Cons=GetInd_iCustom_maxInt[(iiCustomFOR*10)+jiCustomFOR]+1;
            GetInd_iCustom_maxInt[(iiCustomFOR*10)+jiCustomFOR]=GetInd_iCustom_maxInt_Cons;
            
            if( trade_test == true && method_num == 2 && (num_mode_sell == iiCustomFOR || num_mode_buy == iiCustomFOR) && num_shift == jiCustomFOR)
               {
               
               trade_buy_sell(iiCustomFOR); //iiCustomFOR will help decition if this trade buy or sell
               
               }            

           }

         if(GetInd_iCustom[(iiCustomFOR*10)+jiCustomFOR]==-2147483646) // if different before it was            M 3
           {
            GetInd_iCustom_minInt_Cons=GetInd_iCustom_minInt[(iiCustomFOR*10)+jiCustomFOR]+1;
            GetInd_iCustom_minInt[(iiCustomFOR*10)+jiCustomFOR]=GetInd_iCustom_minInt_Cons;
            
            
            
            if( trade_test == true && method_num == 3 && (num_mode_sell == iiCustomFOR || num_mode_buy == iiCustomFOR) && num_shift == jiCustomFOR)
               {
               
               trade_buy_sell(iiCustomFOR); //iiCustomFOR will help decition if this trade buy or sell
               
               }            

           }
         if(GetInd_iCustom[(iiCustomFOR*10)+jiCustomFOR]!=0 && GetInd_iCustom_old[(iiCustomFOR*10)+jiCustomFOR]==0) // if Zero but before not    M 4
           {
            GetInd_iCustom_Zero_Cons=GetInd_iCustom_Zero[(iiCustomFOR*10)+jiCustomFOR]+1;
            GetInd_iCustom_Zero[(iiCustomFOR*10)+jiCustomFOR]=GetInd_iCustom_Zero_Cons;
            
            
            if( trade_test == true && method_num == 4 && (num_mode_sell == iiCustomFOR || num_mode_buy == iiCustomFOR) && num_shift == jiCustomFOR)
               {
               
               trade_buy_sell(iiCustomFOR); //iiCustomFOR will help decition if this trade buy or sell
               
               }            

           }
         if(GetInd_iCustom[(iiCustomFOR*10)+jiCustomFOR]!=2147483647 && GetInd_iCustom_old[(iiCustomFOR*10)+jiCustomFOR]==2147483647) // if Zero     M   5
           {
            GetInd_iCustom_NewNotMax_Cons=GetInd_iCustom_NewNotMax[(iiCustomFOR*10)+jiCustomFOR]+1;
            GetInd_iCustom_NewNotMax[(iiCustomFOR*10)+jiCustomFOR]=GetInd_iCustom_NewNotMax_Cons;
            
            
            if( trade_test == true && method_num == 5 && (num_mode_sell == iiCustomFOR || num_mode_buy == iiCustomFOR) && num_shift == jiCustomFOR)
               {
               
               trade_buy_sell(iiCustomFOR); //iiCustomFOR will help decition if this trade buy or sell
               
               }            

           }
         if(GetInd_iCustom[(iiCustomFOR*10)+jiCustomFOR]==2147483647 && GetInd_iCustom_old[(iiCustomFOR*10)+jiCustomFOR]!=2147483647) // if Zero      M    6
           {
            GetInd_iCustom_OldNotMax_Cons=GetInd_iCustom_OldNotMax[(iiCustomFOR*10)+jiCustomFOR]+1;
            GetInd_iCustom_OldNotMax[(iiCustomFOR*10)+jiCustomFOR]=GetInd_iCustom_OldNotMax_Cons;


            if( trade_test == true && method_num == 6 && (num_mode_sell == iiCustomFOR || num_mode_buy == iiCustomFOR) && num_shift == jiCustomFOR)
               {

               trade_buy_sell(iiCustomFOR); //iiCustomFOR will help decition if this trade buy or sell

               
               }

           }

        }


     } //for  iiCustomFOR ends




  }

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+


string TotComments = "int, int : Mode,Shift\n";

string Comments="Indicator Name:"+IndName+"\n";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CommentArrays()
  {

   for(int iiCustomFOR=0; iiCustomFOR<=7; iiCustomFOR++)
     {
      for(int jiCustomFOR=0; jiCustomFOR<=1; jiCustomFOR++)
        {

         TotComments=TotComments+iiCustomFOR+","+jiCustomFOR+" - Old Dif New : "+GetInd_iCustom_changed[(iiCustomFOR*10)+jiCustomFOR]+" MaxInt "+GetInd_iCustom_maxInt[(iiCustomFOR*10)+jiCustomFOR]+"  MinInt "+GetInd_iCustom_minInt[(iiCustomFOR*10)+jiCustomFOR]+" Zero "+GetInd_iCustom_Zero[(iiCustomFOR*10)+jiCustomFOR]+" NewNotax "+GetInd_iCustom_NewNotMax[(iiCustomFOR*10)+jiCustomFOR]+" OldNotMax "+GetInd_iCustom_OldNotMax[(iiCustomFOR*10)+jiCustomFOR]+"\n";

        }



     }


   Comment(Comments+TotComments);

// Comment(GetInd_iCustom_changed[10]);

   TotComments="int, int : Mode,Shift\n";

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//---


   GetInd(); //Get Indicator via iCustom

   TradeChanged(); //Do Trade

   CommentArrays();



  }
//+------------------------------------------------------------------+
