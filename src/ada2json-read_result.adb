package body Ada2Json.Read_Result is

   ------------------
   -- Create_Error --
   ------------------

   function Create_Error
     (Kind : Error_Kind; Error_Msg : Ada.Strings.Unbounded.Unbounded_String)
      return Read_Result_Type
   is
   begin
      return V : Read_Result_Type (Kind) do
         V.Error_Msg := Error_Msg;
      end return;
   end Create_Error;

end Ada2Json.Read_Result;
