-- Criacao de procedure
ALTER PROCEDURE M330INC2CP_01 (
                 @IN_FILIALCOR Char( 02 ) ) AS

-- Declaracoes de variaveis
DECLARE @cFil_SC2     Char( 02 )
DECLARE @nMaxRecnoSC2 Integer
DECLARE @nRec         Integer

BEGIN
   EXEC XFILIAL_01 'SC2' , @IN_FILIALCOR , @cFil_SC2 output

   SELECT @nMaxRecnoSC2  = ISNULL ( MAX ( R_E_C_N_O_ ), 0 )
     FROM SC2010
     WHERE C2_FILIAL  = @cFil_SC2  and D_E_L_E_T_  <> '*'

   SELECT @nRec  = ISNULL ( MIN ( R_E_C_N_O_ ), 0 )
     FROM SC2010
     WHERE C2_FILIAL  = @cFil_SC2  and D_E_L_E_T_  <> '*'

   WHILE (@nRec  <= @nMaxRecnoSC2 )
   BEGIN
      UPDATE SC2010
        WITH (ROWLOCK)
         SET C2_CPF0101  = C2_CPI0101 ,
             C2_CPF0201  = C2_CPI0201 ,
             C2_CPF0301  = C2_CPI0301 ,
             C2_CPF0401  = C2_CPI0401 ,
             C2_CPF0501  = C2_CPI0501 ,
             C2_CPF0601  = C2_CPI0601 ,
             C2_CPF0701  = C2_CPI0701 ,
             C2_APF0101  = C2_API0101 ,
             C2_APF0201  = C2_API0201 ,
             C2_APF0301  = C2_API0301 ,
             C2_APF0401  = C2_API0401 ,
             C2_APF0501  = C2_API0501 ,
             C2_APF0601  = C2_API0601 ,
             C2_APF0701  = C2_API0701 
       WHERE R_E_C_N_O_  >= @nRec  and R_E_C_N_O_  < @nRec  + 1024  and
             C2_FILIAL  = @cFil_SC2  and D_E_L_E_T_  <> '*'
      SET @nRec  = @nRec  + 1024
   END
END