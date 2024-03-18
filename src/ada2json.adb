package body Ada2Json is

   ------------------
   -- Create_Error --
   ------------------

   function Create_Error
     (Kind : Error_Kind; Error_Msg : Ada.Strings.Unbounded.Unbounded_String)
      return Setter_Result_Type
   is
   begin
      return V : Setter_Result_Type (Kind => Kind) do
         V.Error_Msg := Error_Msg;
      end return;
   end Create_Error;

end Ada2Json;
