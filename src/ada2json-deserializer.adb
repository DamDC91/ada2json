with Ada.Containers;

package body Ada2Json.Deserializer is

   function Read (Value : GNATCOLL.JSON.JSON_Value)
                  return Element_Type
   is
      use GNATCOLL.JSON;
      Field_Initialized : array (Field_Names) of Boolean := (others => False);

      procedure Process_Fields
        (Data  : in out Element_Type;
         Name  : String;
         Value : GNATCOLL.JSON.JSON_Value)
      is
         Fied : Field_Names;
      begin
         begin
            Fied := Field_Names'Value (Name);
         exception
            when Constraint_Error =>
               raise Unknown_Field with Name;
         end;
         if Value.Kind /= Fields_Types (Fied) then
            raise Unknown_Field with Name;
         end if;
         Set_Field (Data, Fied,  Value);
         Field_Initialized (Fied) := True;
      end Process_Fields;

      procedure Mapping is new GNATCOLL.JSON.Gen_Map_JSON_Object (Element_Type);
      Data : Element_Type;
   begin
      Mapping (Value, Process_Fields'Access, Data);
      if (for some Initialized of Field_Initialized => not Initialized) then
         raise Missing_Field;
      else
         return Data;
      end if;
   end Read;

   function Read_Array (Value : GNATCOLL.JSON.JSON_Value)
                        return Vectors.Vector
   is
      use GNATCOLL.JSON;
      Array_JSON : constant JSON_Array := Value.Get;
      Res : Vectors.Vector := Vectors.Empty_Vector;
   begin
      Res.Reserve_Capacity 
        (Ada.Containers.Count_Type (Length (Array_JSON)));
      for D of Array_JSON loop
         Vectors.Append (Res, Read (D));
      end loop;
      return Res;
   end Read_Array;

end Ada2Json.Deserializer;
