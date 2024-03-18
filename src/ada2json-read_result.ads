with Ada.Strings.Unbounded;

generic
   type Element_Type is private;
package Ada2Json.Read_Result is

   type Read_Result_Type (Kind : Ada2Json.Result_Kind) is
      record
         case Kind is
            when Ada2Json.Success =>
               Value : Element_Type; 
            when Ada2Json.Error_Kind =>
               Error_Msg : Ada.Strings.Unbounded.Unbounded_String;
         end case;
      end record;

   function Create_Error (Kind : Error_Kind;
                          Error_Msg : Ada.Strings.Unbounded.Unbounded_String)
                          return Read_Result_Type;

end Ada2Json.Read_Result;
