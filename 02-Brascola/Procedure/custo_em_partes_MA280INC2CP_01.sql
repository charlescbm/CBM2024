-- Criacao de procedure
ALTER PROCEDURE MA280INC2CP_01 (
                 @IN_RECNOSC2 Integer ) AS
BEGIN
   UPDATE SC2010
     WITH (ROWLOCK)
      SET C2_CPI0101  = C2_CPF0101 ,
          C2_CPI0201  = C2_CPF0201 ,
          C2_CPI0301  = C2_CPF0301 ,
          C2_CPI0401  = C2_CPF0401 ,
          C2_CPI0501  = C2_CPF0501 ,
          C2_CPI0601  = C2_CPF0601 ,
          C2_CPI0701  = C2_CPF0701 ,
          C2_API0101  = C2_APF0101 ,
          C2_API0201  = C2_APF0201 ,
          C2_API0301  = C2_APF0301 ,
          C2_API0401  = C2_APF0401 ,
          C2_API0501  = C2_APF0501 ,
          C2_API0601  = C2_APF0601 ,
          C2_API0701  = C2_APF0701 
    WHERE R_E_C_N_O_  = @IN_RECNOSC2
END