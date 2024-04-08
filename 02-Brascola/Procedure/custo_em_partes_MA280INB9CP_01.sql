-- Criacao de procedure
ALTER PROCEDURE MA280INB9CP_01 (
                 @IN_FILIALCOR  Char( 02 ) ,
                 @IN_COD        Char( 15 ) ,
                 @IN_MV_CUSZERO Char( 01 ) ,
                 @IN_RECNOSB9   Integer    ,
                 @IN_RECNOSB2   Integer    ,
                 @IN_NDIVISOR   Float      ,
                 @IN_B9_VINI1   Float      ,
                 @IN_B9_VINI2   Float      ,
                 @IN_B9_VINI3   Float      ,
                 @IN_B9_VINI4   Float      ,
                 @IN_B9_VINI5   Float ) AS

-- Declaracoes de variaveis
DECLARE @nB2_CPF0101 Float
DECLARE @nB2_CPF0201 Float
DECLARE @nB2_CPF0301 Float
DECLARE @nB2_CPF0401 Float
DECLARE @nB2_CPF0501 Float
DECLARE @nB2_CPF0601 Float
DECLARE @nB2_CPF0701 Float 

BEGIN
   IF @IN_MV_CUSZERO  = 'S'
   BEGIN
      SET @nB2_CPF0101  = 0
      SET @nB2_CPF0201  = 0
      SET @nB2_CPF0301  = 0
      SET @nB2_CPF0401  = 0
      SET @nB2_CPF0501  = 0
      SET @nB2_CPF0601  = 0
      SET @nB2_CPF0701  = 0
   END
   ELSE
   BEGIN
      SELECT @nB2_CPF0101 = ISNULL(B2_CPF0101,0), @nB2_CPF0201 = ISNULL(B2_CPF0201,0),
             @nB2_CPF0301 = ISNULL(B2_CPF0301,0), @nB2_CPF0401 = ISNULL(B2_CPF0401,0), 
             @nB2_CPF0501 = ISNULL(B2_CPF0501,0), @nB2_CPF0601 = ISNULL(B2_CPF0601,0), 
             @nB2_CPF0701 = ISNULL(B2_CPF0701,0)
        FROM SB2010
        WHERE R_E_C_N_O_  = @IN_RECNOSB2
   END
   UPDATE SB9010
     WITH (ROWLOCK)
      SET B9_CP0101 = @nB2_CPF0101, B9_CP0201 = @nB2_CPF0201, B9_CP0301 = @nB2_CPF0301, 
		  B9_CP0401 = @nB2_CPF0401, B9_CP0501 = @nB2_CPF0501, B9_CP0601 = @nB2_CPF0601, 
		  B9_CP0701 = @nB2_CPF0701
    WHERE R_E_C_N_O_  = @IN_RECNOSB9
END