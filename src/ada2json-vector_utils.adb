package body Ada2Json.Vector_Utils is

   function Get (Value : GNATCOLL.JSON.JSON_Value)
                 return Read_Result.Read_Result_Type
   is
      use GNATCOLL.JSON;
      Data : Vectors.Vector;
      Array_JSON : constant JSON_Array := Value.Get;
   begin
      for I of Array_JSON loop
         declare
            Elem : Element_Read_Result.Read_Result_Type renames Get (I);
         begin
            if Elem.Kind in Success then
               Vectors.Append (Data, Elem.Value);
            else
               return Read_Result.Create_Error (Elem.Kind, Elem.Error_Msg);
            end if;
         end;
      end loop;
      return (Kind => Success, Value => Data);
   end Get;

   function Create (Data : Vectors.Vector) return GNATCOLL.JSON.JSON_Value
   is
      use GNATCOLL.JSON;
      J : constant JSON_Value := Create (Empty_Array);
   begin
      For E of Data loop
         Append (J, Create (E));
      end loop;
      return J;
   end Create;

end Ada2Json.Vector_Utils;
