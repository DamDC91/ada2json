package body Ada2Json.Array_Utils is

   function Get (Value : GNATCOLL.JSON.JSON_Value) return Array_Type
   is
      use GNATCOLL.JSON;
      Data : Array_Type;
      Array_JSON : constant JSON_Array := Value.Get;
      Idx : Index_Type := Index_Type'First;
   begin
      if Length (Array_JSON) /= Array_Type'Length then
         raise Ada2Json.Wrong_Array_Size;
      else
         for I of Array_JSON loop
            Data (Idx) := Get (I);
            if Idx /= Index_Type'Last then
               Idx := Index_Type'Succ (Idx);
            end if;
         end loop;
      end if;
      return Data;
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
