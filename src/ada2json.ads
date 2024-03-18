with Ada.Strings.Unbounded;

package Ada2Json is

   type Result_Kind is (Success,
                        Missing_Field,
                        Unknown_Field,
                        Wrong_Array_Size,
                        Type_Error);

   subtype Error_Kind is Result_Kind range
     Missing_Field .. Type_Error;

   type Setter_Result_Type (Kind : Result_Kind := Success) is record
      case Kind is
         when Success =>
            null;
         when Error_Kind =>
            Error_Msg : Ada.Strings.Unbounded.Unbounded_String;
      end case;
   end record;

   function Create_Error (Kind : Error_Kind;
                          Error_Msg : Ada.Strings.Unbounded.Unbounded_String)
                          return Setter_Result_Type;

end Ada2Json;
