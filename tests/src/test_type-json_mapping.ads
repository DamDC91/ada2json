with GNATCOLL.JSON;
with Ada2Json.Deserializer;
with Ada2Json.Serializer;
with Ada2Json.Mapper;
with Ada2Json;

package Test_Type.Json_Mapping is

   type My_Small_Record_Fields is (D1, D2);
   type My_Small_Record_Field_Types is array (My_Small_Record_Fields)
     of GNATCOLL.JSON.JSON_Value_Type;

   Small_Field_Types : constant My_Small_Record_Field_Types :=
     (D1 => GNATCOLL.JSON.JSON_Int_Type,
      D2 => GNATCOLL.JSON.JSON_Float_Type);

   procedure Set (Data   : in out My_Small_Record;
                  Field  : My_Small_Record_Fields;
                  Value  : GNATCOLL.JSON.JSON_Value;
                  Result : out Ada2Json.Setter_Result_Type);

   function Get (Data : My_Small_Record;
                 Field : My_Small_Record_Fields)
                 return GNATCOLL.JSON.JSON_Value;

   package Small_Mapper is new Ada2Json.Mapper
     (Element_Type     => My_Small_Record,
      Field_Names      => My_Small_Record_Fields,
      Field_JSON_Types => My_Small_Record_Field_Types,
      Fields_Types     => Small_Field_Types,
      Get_Field        => Get,
      Set_Field        => Set);

   type My_Record_Fields is (F1, F2, F3, F4, F5, F6);
   type My_Record_Field_Types is array (My_Record_Fields)
     of GNATCOLL.JSON.JSON_Value_Type;

   Field_Types : constant My_Record_Field_Types :=
     (F1 => GNATCOLL.JSON.JSON_Int_Type,
      F2 => GNATCOLL.JSON.JSON_Float_Type,
      F3 => GNATCOLL.JSON.JSON_String_Type,
      F4 => GNATCOLL.JSON.JSON_Array_Type,
      F5 => GNATCOLL.JSON.JSON_Object_Type,
      F6 => GNATCOLL.JSON.JSON_Array_Type);

   procedure Set (Data   : in out My_Record;
                  Field  : My_Record_Fields;
                  Value  : GNATCOLL.JSON.JSON_Value;
                  Result : out Ada2Json.Setter_Result_Type);

   function Get (Data : My_Record;
                 Field : My_Record_Fields)
                 return GNATCOLL.JSON.JSON_Value;

   package Mapper is new Ada2Json.Mapper
     (Element_Type     => My_Record,
      Field_Names      => My_Record_Fields,
      Field_JSON_Types => My_Record_Field_Types,
      Fields_Types     => Field_Types,
      Get_Field        => Get,
      Set_Field        => Set);

end Test_Type.Json_Mapping;
