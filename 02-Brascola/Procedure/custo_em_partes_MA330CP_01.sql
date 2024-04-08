CREATE  PROCEDURE MA330CP_01 (
    @IN_FILIALCOR Char(02),
    @IN_COD Char(15),
    @OUT_RESULTADO Integer  output ) AS
-- Declaracoes de variaveis
DECLARE @cFil_SB1 Char(2)
DECLARE @cB1_TIPO Char(2)
BEGIN
   EXEC XFILIAL_01 'SB1' , @IN_FILIALCOR , @cFil_SB1 output
   SELECT @cB1_TIPO = B1_TIPO
     FROM SB1010
     WHERE B1_FILIAL = @cFil_SB1  and B1_COD = @IN_COD and D_E_L_E_T_ = ' '
   SET @OUT_RESULTADO = 7
   IF @cB1_TIPO = '1'
   BEGIN
      SET @OUT_RESULTADO = 1
   END
   IF @cB1_TIPO = '2'
   BEGIN
      SET @OUT_RESULTADO = 2
   END
   IF @cB1_TIPO = '3'
   BEGIN
      SET @OUT_RESULTADO = 3
   END
   IF @cB1_TIPO = '4'
   BEGIN
      SET @OUT_RESULTADO = 4
   END
   IF @cB1_TIPO = '5'
   BEGIN
      SET @OUT_RESULTADO = 5
   END
   IF @cB1_TIPO = '6'
   BEGIN
      SET @OUT_RESULTADO = 6
   END
END
