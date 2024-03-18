with Ada.Strings.Unbounded;

package body Ada2Json.Array_Utils is

   function Get (Value : GNATCOLL.JSON.JSON_Value)
                 return Read_Result.Read_Result_Type
   is
      use GNATCOLL.JSON;
      Data : Array_Type;
      Array_JSON : constant JSON_Array := Value.Get;
      Idx : Index_Type := Index_Type'First;
   begin
      if Length (Array_JSON) /= Array_Type'Length then
         return (Kind      => Wrong_Array_Size,
                 Error_Msg => Ada.Strings.Unbounded.To_Unbounded_String
                   ("Array with a wrong size"));
      else
         for I of Array_JSON loop
            declare
               Elm : Element_Read_Result.Read_Result_Type := Get (I);
            begin
               if Elm.Kind in Error_Kind then
                  return Read_Result.Create_Error (Elm.Kind, Elm.Error_Msg);
               else
                  Data (Idx) := Elm.Value;
               end if;
            end;

            if Idx /= Index_Type'Last then
               Idx := Index_Type'Succ (Idx);
            end if;
         end loop;
      end if;
      return (Kind => Success, Value => Data);
   end Get;

   function Create (Data : Array_Type) return GNATCOLL.JSON.JSON_Value
   is
      use GNATCOLL.JSON;
      J : constant JSON_Value := Create (Empty_Array);
   begin
      For E of Data loop
         Append (J, Create (E));
      end loop;
      return J;
   end Create;

end Ada2Json.Array_Utils;
