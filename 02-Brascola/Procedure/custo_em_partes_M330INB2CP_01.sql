-- Criacao de procedure
ALTER PROCEDURE M330INB2CP_01 (
                @IN_FILIALCOR Char( 02 ) ,
                @IN_DINICIO   Char( 08 ) ,
                @IN_CUSUNIF   Char( 01 ) ,
                @IN_COD       Char( 15 ) ,
                @IN_LOCAL     Char( 2  ) ,
                @IN_RECNOSB2  Integer ) AS

-- Declaracoes de variaveis
DECLARE @nB2_VFIM1  Float
DECLARE @nB2_VFIM2  Float
DECLARE @nB2_VFIM3  Float
DECLARE @nB2_VFIM4  Float
DECLARE @nB2_VFIM5  Float
DECLARE @nB9_CP0101 Float
DECLARE @nB9_CP0201 Float
DECLARE @nB9_CP0301 Float
DECLARE @nB9_CP0401 Float
DECLARE @nB9_CP0501 Float
DECLARE @nB9_CP0601 Float
DECLARE @nB9_CP0701 Float
DECLARE @nParte     Integer
DECLARE @nQtd       Float
DECLARE @cFil_SB9   Char( 02 )
DECLARE @iRecnoTRT  Integer

BEGIN
   EXEC XFILIAL_01 'SB9' , @IN_FILIALCOR , @cFil_SB9 output

   UPDATE SB2010
     WITH (ROWLOCK)
      SET B2_CPF0101= 0, B2_CPF0201= 0, B2_CPF0301= 0, B2_CPF0401= 0, B2_CPF0501= 0, B2_CPF0601= 0, B2_CPF0701= 0, 
          B2_CP0101 = 0, B2_CP0201 = 0, B2_CP0301 = 0, B2_CP0401 = 0, B2_CP0501 = 0, B2_CP0601 = 0, B2_CP0701 = 0
   WHERE R_E_C_N_O_   = @IN_RECNOSB2

   IF SUBSTRING ( @IN_COD , 1 , 1 ) <> 'Z'
   BEGIN
      SELECT  @nB9_CP0101 = ISNULL (B9_CP0101,0), @nB9_CP0201 = ISNULL (B9_CP0201,0),
	          @nB9_CP0301 = ISNULL (B9_CP0301,0), @nB9_CP0401 = ISNULL (B9_CP0401,0),
              @nB9_CP0501 = ISNULL (B9_CP0501,0), @nB9_CP0601 = ISNULL (B9_CP0601,0),
              @nB9_CP0701 = ISNULL (B9_CP0701,0)
        FROM SB9010
        WHERE B9_FILIAL = @cFil_SB9 and B9_COD = @IN_COD and B9_LOCAL = @IN_LOCAL  and
              B9_DATA  = ( SELECT MAX ( B9_DATA )
                              FROM SB9010
                                 WHERE B9_FILIAL = @cFil_SB9   and
                                       B9_COD    = @IN_COD     and  
                                       B9_LOCAL  = @IN_LOCAL   and
                                       B9_DATA  <= @IN_DINICIO and                                            
                                       D_E_L_E_T_  <> '*'
                          ) and D_E_L_E_T_  <> '*'
   END
   ELSE
   BEGIN
      EXEC MA330CP_01 @IN_FILIALCOR , @IN_COD , @nParte output
      SELECT @nB2_VFIM1  = ISNULL ( B2_VFIM1 , 0 ),
             @nB2_VFIM2  = ISNULL ( B2_VFIM2 , 0 ),
             @nB2_VFIM3  = ISNULL ( B2_VFIM3 , 0 ),
             @nB2_VFIM4  = ISNULL ( B2_VFIM4 , 0 ),
             @nB2_VFIM5  = ISNULL ( B2_VFIM5 , 0 )
        FROM SB2010
        WHERE R_E_C_N_O_  = @IN_RECNOSB2

      SET @nB9_CP0101  = 0
      SET @nB9_CP0201  = 0
      SET @nB9_CP0301  = 0
      SET @nB9_CP0401  = 0
      SET @nB9_CP0501  = 0
      SET @nB9_CP0601  = 0
      SET @nB9_CP0701  = 0

      IF @nParte  = 1
      BEGIN
         SET @nB9_CP0101  = @nB2_VFIM1
      END
      IF @nParte  = 2
      BEGIN
         SET @nB9_CP0201  = @nB2_VFIM1
      END
      IF @nParte  = 3
      BEGIN
         SET @nB9_CP0301  = @nB2_VFIM1
      END
      IF @nParte  = 4
      BEGIN
         SET @nB9_CP0401  = @nB2_VFIM1
      END
      IF @nParte  = 5
      BEGIN
         SET @nB9_CP0501  = @nB2_VFIM1
      END
      IF @nParte  = 6
      BEGIN
         SET @nB9_CP0601  = @nB2_VFIM1
      END
      IF @nParte  = 7
      BEGIN
         SET @nB9_CP0701  = @nB2_VFIM1
      END

   END

   SET @nB9_CP0101  = ISNULL ( @nB9_CP0101 , 0 )
   SET @nB9_CP0201  = ISNULL ( @nB9_CP0201 , 0 )
   SET @nB9_CP0301  = ISNULL ( @nB9_CP0301 , 0 )
   SET @nB9_CP0401  = ISNULL ( @nB9_CP0401 , 0 )
   SET @nB9_CP0501  = ISNULL ( @nB9_CP0501 , 0 )
   SET @nB9_CP0601  = ISNULL ( @nB9_CP0601 , 0 )
   SET @nB9_CP0701  = ISNULL ( @nB9_CP0701 , 0 )
 
  IF @IN_CUSUNIF  = '1'
   BEGIN
      SELECT @iRecnoTRT  = ISNULL ( MAX ( R_E_C_N_O_ ), 0 )
        FROM TRT010_SP
        WHERE TRB_FILIAL = @IN_FILIALCOR
          AND TRB_COD  = @IN_COD
      IF @iRecnoTRT  = 0
      BEGIN
         SELECT @iRecnoTRT  = ISNULL ( MAX ( R_E_C_N_O_ ), 0 )
           FROM TRT010_SP
         SET @iRecnoTRT  = @iRecnoTRT  + 1
         INSERT INTO TRT010_SP (TRB_COD , R_E_C_N_O_ )
         VALUES (@IN_COD , @iRecnoTRT )
      END
      SELECT @nQtd  = ISNULL ( TRB_QFIM , 0 )
        FROM TRT010_SP
        WHERE R_E_C_N_O_  = @iRecnoTRT

      IF @nQtd = 0 BEGIN
         SELECT @nQtd = 1
      END

         UPDATE TRT010_SP
           WITH (ROWLOCK)
            SET TRB_VF0101  = TRB_VF0101 + @nB9_CP0101,
                TRB_VF0201  = TRB_VF0201 + @nB9_CP0201,
                TRB_VF0301  = TRB_VF0301 + @nB9_CP0301,
                TRB_VF0401  = TRB_VF0401 + @nB9_CP0401,
                TRB_VF0501  = TRB_VF0501 + @nB9_CP0501,
                TRB_VF0601  = TRB_VF0601 + @nB9_CP0601,
                TRB_VF0701  = TRB_VF0701 + @nB9_CP0701,
                TRB_CP0101  = TRB_VF0101 + @nB9_CP0101 / @nQtd ,
                TRB_CP0201  = TRB_VF0201 + @nB9_CP0201 / @nQtd ,
                TRB_CP0301  = TRB_VF0301 + @nB9_CP0301 / @nQtd ,
                TRB_CP0401  = TRB_VF0401 + @nB9_CP0401 / @nQtd ,
                TRB_CP0501  = TRB_VF0501 + @nB9_CP0501 / @nQtd ,
                TRB_CP0601  = TRB_VF0601 + @nB9_CP0601 / @nQtd ,
                TRB_CP0701  = TRB_VF0701 + @nB9_CP0701 / @nQtd 
          WHERE R_E_C_N_O_  = @iRecnoTRT
   END

   UPDATE SB2010
     WITH (ROWLOCK)
      SET B2_CPF0101  = @nB9_CP0101 , 
          B2_CPF0201  = @nB9_CP0201 , 
          B2_CPF0301  = @nB9_CP0301 , 
          B2_CPF0401  = @nB9_CP0401 , 
          B2_CPF0501  = @nB9_CP0501 , 
          B2_CPF0601  = @nB9_CP0601 , 
          B2_CPF0701  = @nB9_CP0701 

    WHERE R_E_C_N_O_  = @IN_RECNOSB2

   SELECT @nQtd  = ISNULL ( B2_QFIM , 0 )
     FROM SB2010
     WHERE R_E_C_N_O_  = @IN_RECNOSB2

   IF @nQtd = 0 BEGIN
      SELECT @nQtd = 1
   END

      UPDATE SB2010
        WITH (ROWLOCK)
         SET B2_CP0101  = @nB9_CP0101  / @nQtd ,
          B2_CP0201  = @nB9_CP0201  / @nQtd ,
          B2_CP0301  = @nB9_CP0301  / @nQtd ,
          B2_CP0401  = @nB9_CP0401  / @nQtd ,
          B2_CP0501  = @nB9_CP0501  / @nQtd ,
          B2_CP0601  = @nB9_CP0601  / @nQtd ,
          B2_CP0701  = @nB9_CP0701  / @nQtd 
        WHERE R_E_C_N_O_  = @IN_RECNOSB2

END