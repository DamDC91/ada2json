with Ada2Json.Array_Utils;

package body Test_Type.Json_Mapping is

   procedure Set (Data : in out My_Small_Record;
                  Field : My_Small_Record_Fields;
                  Value : GNATCOLL.JSON.JSON_Value)
   is
      function Get_Int (Val : GNATCOLL.JSON.JSON_Value)
                        return Integer
                        renames GNATCOLL.JSON.Get;
      function Get_Float (Val : GNATCOLL.JSON.JSON_Value)
                        return Float
                        renames GNATCOLL.JSON.Get;
   begin
      case Field is
         when D1 =>
            if Get_Int (Value) >= Integer (My_Mod'First) and then
              Get_Int (Value) <= Integer (My_Mod'Last)
            then
               Data.D1 := My_Mod (Get_Int (Value));
            else
               raise Ada2Json.Type_Constraint;
            end if;
         when D2 =>
            if Get_Float (Value) >= Float (My_Float'First) and then
              Get_Float (Value) <= Float (My_Float'Last)
            then
               Data.D2 := My_Float (Get_Float (Value));
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

   package My_Array_Mapper is new Ada2Json.Array_Utils
     (Element_Type => Integer,
      Index_Type   => My_Index,
      Array_Type   => My_Array,
      Get          => GNATCOLL.JSON.Get,
      Create       => GNATCOLL.JSON.Create);

   procedure Set (Data  : in out My_Record;
                  Field : My_Record_Fields;
                  Value : GNATCOLL.JSON.JSON_Value)
   is
      use GNATCOLL.JSON;
   begin
      case Field is
         when F1 => Data.F1 := Value.Get;
         when F2 => Data.F2 := Value.Get;
         when F3 => Data.F3 := Value.Get;
         when F4 => Data.F4 := My_Array_Mapper.Get (Value);
         when F5 => Data.F5 := Small_Mapper.Read (Value);
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
                 when F5 => Small_Mapper.Create_JSON_Value (Data.F5));
   end Get;

end Test_Type.Json_Mapping;
