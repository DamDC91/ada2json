with Ada2Json.Array_Utils;
with Ada2Json.Vector_Utils;
with Ada.Strings.Unbounded;
with Ada2Json.Read_Result;

package body Test_Type.Json_Mapping is

   procedure Set (Data : in out My_Small_Record;
                  Field : My_Small_Record_Fields;
                  Value : GNATCOLL.JSON.JSON_Value;
                  Result : out Ada2Json.Setter_Result_Type)
   is
      function Get_Int (Val : GNATCOLL.JSON.JSON_Value)
                        return Integer
                        renames GNATCOLL.JSON.Get;
      function Get_Float (Val : GNATCOLL.JSON.JSON_Value)
                        return Float
                        renames GNATCOLL.JSON.Get;
   begin
      Result := (Kind => Ada2Json.Success);
      case Field is
         when D1 =>
            if Get_Int (Value) >= Integer (My_Mod'First) and then
              Get_Int (Value) <= Integer (My_Mod'Last)
            then
               Data.D1 := My_Mod (Get_Int (Value));
            else
               Result := (Kind => Ada2Json.Type_Error,
                          Error_Msg =>
                            Ada.Strings.Unbounded.To_Unbounded_String
                              ("Type constraint error on field """ &
                                 Field'Img & """"));
            end if;
         when D2 =>
            if Get_Float (Value) >= Float (My_Float'First) and then
              Get_Float (Value) <= Float (My_Float'Last)
            then
               Data.D2 := My_Float (Get_Float (Value));
            else
               Result := (Kind => Ada2Json.Type_Error,
                          Error_Msg =>
                            Ada.Strings.Unbounded.To_Unbounded_String
                              ("Type constraint error on field """ &
                                 Field'Img & """"));
            end if;
      end case;
   end Set;

   function Get (Data : My_Small_Record;
                 Field : My_Small_Record_Fields)
                 return GNATCOLL.JSON.JSON_Value
   is
   begin
      return (case Field is
                 when D1 => GNATCOLL.JSON.Create (Integer (Data.D1)),
                 when D2 => GNATCOLL.JSON.Create (Float (Data.D2)));
   end Get;

   package Read_Result_Integer is new Ada2Json.Read_Result (Integer);
   function Get_Int (Val : GNATCOLL.JSON.JSON_Value)
                     return Read_Result_Integer.Read_Result_Type
   is
      use GNATCOLL.JSON;
   begin
      if Val.Kind = JSON_Int_Type then
         return (Ada2Json.Success, Value => Val.Get);
      else
         return (Kind => Ada2Json.Type_Error,
                 Error_Msg =>
                   Ada.Strings.Unbounded.To_Unbounded_String
                     ("Expected Integer Type got " & Val.Kind'Img));
      end if;
   end Get_Int;

   package My_Array_Mapper is new Ada2Json.Array_Utils
     (Element_Type        => Integer,
      Element_Read_Result => Read_Result_Integer,
      Index_Type          => My_Index,
      Array_Type          => My_Array,
      Get                 => Get_Int,
      Create              => GNATCOLL.JSON.Create);

   package Read_Result_Float is new Ada2Json.Read_Result (Float);
   function Get_Float (Val : GNATCOLL.JSON.JSON_Value)
                     return Read_Result_Float.Read_Result_Type
   is
      use GNATCOLL.JSON;
   begin
      if Val.Kind = JSON_Float_Type then
         return (Ada2Json.Success, Value => Val.Get);
      else
         return (Kind => Ada2Json.Type_Error,
                 Error_Msg =>
                   Ada.Strings.Unbounded.To_Unbounded_String
                     ("Expected Float Type got " & Val.Kind'Img));
      end if;
   end Get_Float;
   package My_Vec_Mapper is new Ada2Json.Vector_Utils
     (Element_Type        => Float,
      Index_Type          => Positive,
      Element_Read_Result => Read_Result_Float,
      Vectors             => My_Vec,
      Get                 => Get_Float,
      Create              => GNATCOLL.JSON.Create);

   procedure Set (Data  : in out My_Record;
                  Field : My_Record_Fields;
                  Value : GNATCOLL.JSON.JSON_Value;
                  Result : out Ada2Json.Setter_Result_Type)
   is
      use GNATCOLL.JSON;
      function Create (Kind : Ada2Json.Error_Kind;
                       Msg : Ada.Strings.Unbounded.Unbounded_String)
                       return Ada2Json.Setter_Result_Type
      is
      begin
         return V : Ada2Json.Setter_Result_Type (Kind => Kind) do
            V.Error_Msg := Msg;
         end return;
      end Create;

   begin
      Result := (Kind => Ada2Json.Success);
      case Field is
         when F1 => Data.F1 := Value.Get;
         when F2 => Data.F2 := Value.Get;
         when F3 => Data.F3 := Value.Get;
         when F4 =>
            declare
               Tmp : constant My_Array_Mapper.Read_Result.Read_Result_Type
                 := My_Array_Mapper.Get (Value);
            begin
               if Tmp.Kind not in Ada2Json.Error_Kind then
                  Data.F4 := Tmp.Value;
               else
                  Result := Create (Tmp.Kind, Tmp.Error_Msg);
               end if;
            end;
         when F5 =>
            declare
               Tmp : constant Small_Mapper.Read_Result_Type :=
                 Small_Mapper.Read (Value);
            begin
               if Tmp.Kind not in Ada2Json.Error_Kind then
                  Data.F5 := Tmp.Value;
               else
                  Result := Create (Tmp.Kind, Tmp.Error_Msg);
               end if;
            end;
         when F6 =>
            declare
               Tmp : constant My_Vec_Mapper.Read_Result.Read_Result_Type :=
                 My_Vec_Mapper.Get (Value);
            begin
               if Tmp.Kind not in Ada2Json.Error_Kind then
                  Data.F6 := Tmp.Value;
               else
                  Result := Create (Tmp.Kind, Tmp.Error_Msg);
               end if;
            end;
      end case;

   end Set;

   function Get (Data : My_Record;
                 Field : My_Record_Fields)
                 return GNATCOLL.JSON.JSON_Value
   is
      use GNATCOLL.JSON;
   begin
      return (case Field is
                 when F1 => Create (Data.F1),
                 when F2 => Create (Data.F2),
                 when F3 => Create (Data.F3),
                 when F4 => My_Array_Mapper.Create (Data.F4),
                 when F5 => Small_Mapper.Serialize.Create_JSON_Value (Data.F5),
                 when F6 => My_Vec_Mapper.Create (Data.F6));
   end Get;

end Test_Type.Json_Mapping;
