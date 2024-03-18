with Ada.Containers;
with Ada.Strings.Unbounded;

package body Ada2Json.Deserializer is

   Nullable_Fields : array (Field_Names) of Boolean := (others => False);
   
   function Read (Value : GNATCOLL.JSON.JSON_Value)
                  return Result_Type.Read_Result_Type
   is
      use GNATCOLL.JSON;
      Field_Initialized : array (Field_Names) of Boolean := (others => False);
      Kind : Ada2Json.Result_Kind := Success;
      Msg  : Ada.Strings.Unbounded.Unbounded_String;

      procedure Process_Fields
        (Data  : in out Element_Type;
         Name  : String;
         Value : GNATCOLL.JSON.JSON_Value)
      is
         Field  : Field_Names;
         Result : Ada2Json.Setter_Result_Type;
      begin
         if Kind /= Success then
            return;
         end if;
         begin
            Field := Field_Names'Value (Name);
         exception
            when Constraint_Error =>
               Kind := Unknown_Field;
               Ada.Strings.Unbounded.Set_Unbounded_String 
                 (Msg, "Unknown field """ & Name & """");
               return;
         end;
         if Value.Kind /= Fields_Types (Field)
           and not (Value.Kind = JSON_Null_Type and Nullable_Fields (Field))
         then
            Kind := Type_Error;
            Ada.Strings.Unbounded.Set_Unbounded_String 
              (Msg, "Wrong type in field """ & Name & """");
            return;
         end if;
         Set_Field (Data, Field,  Value, Result);
         if Result.Kind not in Ada2Json.Success then
            Kind := Result.Kind;
            Msg  := Result.Error_Msg;
         else
            Field_Initialized (Field) := True;
         end if;
      end Process_Fields;

      procedure Mapping is new GNATCOLL.JSON.Gen_Map_JSON_Object (Element_Type);
      Data : Element_Type;
   begin
      Mapping (Value, Process_Fields'Access, Data);
      
      if Kind /= Success then
         return Result_Type.Create_Error (Kind, Msg);
      end if;
      
      for Field in Field_Initialized'Range loop
         if not Field_Initialized (Field) then
            return (Kind      => Missing_Field,
                    Error_Msg => Ada.Strings.Unbounded.To_Unbounded_String 
                      ("Missing field """ & Field'Img & """"));
         end if;
      end loop;
      
      return (Kind => Success, Value => Data);
   end Read;

   procedure Nullable (F : Field_Names)
   is
   begin
      Nullable_Fields (F) := True;
   end Nullable;

end Ada2Json.Deserializer;
