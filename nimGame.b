import "io"

let help() be
{
  out("Nim is a simple game. To play, simply type the\npile you would like to take sticks from,");
  out(" hit\nreturn, then input the number of sticks you\nwould like to take from the pile. Of course,\n");
  out("you cannot take more sticks than exist and\nmust select from one of the existing piles.\n");
  out(" \nTo win the game, you must take the final turn.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");   
}

//print function for game data array
let printData(gameData) be
{
  let i;
  for i = 0 to 2 do
    {out("%d    ",gameData ! i);}
  out("\n\n");
}

let valueFromColumn(nColumnNum) be
{
  let nDecVal = 1;
  
  while nColumnNum > 1 do
  {
    nDecVal *:= 2;
    nColumnNum -:= 1;
  }
  resultis nDecVal;
}

let pickRow(gameData) be
{
  let i, biggest = 0;
  for i = 0 to 2 do
  {
    if(gameData ! i > gameData ! biggest) then
      {biggest := i;}
  }

  resultis biggest;
}

let reduce(gameData, nResult, nResultSize) be
{
  let nRow, nColumn, i, change = 0, temp, nCount = 0;

  nRow := pickRow(gameData);
  
  for i = 0 to 2 do
  {
    test gameData ! i = 0 then
    {
      nCount +:= 1;
    }
    else
    {
      temp := i;
    }
  }

  if nCount = 2 then
  {
    gameData ! temp := 0;
    return;
  }

  for nColumn = 0 to 31 do
  {
    if nResult bitand 1 then 
    {
       if nColumn = 0 then
         {nColumn := 31 - nResultSize;}
       if change = 0 then
       {
         temp := valueFromColumn(32 - nColumn);
         change := 1;
       }
    }
    nResult rotl := 1;
  }
  gameData ! nRow -:= (temp - 1);
}

//takes an array of 3 integers that represent the piles
//of sticks that NIM is played with
let artInt(gameData) be
{
  let nResult = 0, nCount = 0, nColumn, i;
  nResult := gameData ! 0 neqv gameData ! 1 neqv gameData ! 2;

  //is it zero?
  for i = 0 to 31 do
  {
    if nResult bitand 1 then 
      {nCount +:= 1;}
    nResult rotl := 1;
  }

  //take fewest possible from a non-zero pile
  //to try to force the user into a losing 
  //position
  test nCount = 0 then
  {
    for i = 0 to 2 do
    {
      if gameData ! i > 0 then
      {
        gameData ! i -:= 1;
      }
    }
  }

  //Otherwise, we are in a winning position
  //so find the easiest way to force the 
  //player into a losing position (nResult = 0)
  else
  {
     reduce(gameData, nResult, nCount);
  }
  printData(gameData);
}

//takes an array of 3 integers that represent the piles
//of sticks that NIM is played with
let game(gameData) be
{
  let nPileNumber, nSubAmt, nWhoseTurn = 0;
  
  //Main loop - while at least one index has a non-zero value, keep looping
  while (gameData ! 0 <> 0) \/ (gameData ! 1 <> 0) \/ (gameData ! 2 <> 0) do
  {
    nPileNumber := inno();
    nSubAmt := inno();
    
    gameData ! nPileNumber -:= nSubAmt;    
    printData(gameData);
    if (gameData ! 0 = 0) /\ (gameData ! 1 = 0) /\ (gameData ! 2 = 0) then
    {
      nWhoseTurn := 0;
    }
    artInt(gameData);
    nWhoseTurn := 1;    
  }

  if nWhoseTurn = 0 then
  {
    //player won!
    out("YOU WON! Play again? (type b)");  
  }
  if nWhoseTurn = 1 then 
  {
    //player lost
    out("You lost. Try again? (type b)");
  }
}

let start() be
{
  let cUserChoice, nBiggest, i;
  let gameData = vec 3;
  //seed pseudo-random number generator
  random(-1);
  out("Welcome to NIM! Type 'h' for help, 'b' to begin, or 'e' to exit.\n");
  while true do
  {
    cUserChoice := inch();
    if cUserChoice = 'e' then
    {  finish;}
    if cUserChoice = 'h' then
    {  help();}
    if cUserChoice = 'b' then
    {
      out("\nWhat size should the largest pile be?\n");
      nBiggest := inno();
  
      //fill up array with pile sizes
      for i = 0 to 2 do
        gameData ! i := random(nBiggest);

      //Print
      out("\n\n\n");
      printData(gameData);

      //start game
      game(gameData);
    }
  }
}
