package body Ada2Json.Vector_Utils is

   function Get (Value : GNATCOLL.JSON.JSON_Value) return Vectors.Vector
   is
      use GNATCOLL.JSON;
      Data : Vectors.Vector;
      Array_JSON : constant JSON_Array := Value.Get;
   begin
      for I of Array_JSON loop
         declare
            Elem : Element_Type renames Get (I);
         begin
            Vectors.Append (Data, Elem);
         end;
      end loop;
      return Data;
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
