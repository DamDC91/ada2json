with GNATCOLL.JSON;
with Ada.Containers.Vectors;
with Ada2Json.Read_Result;

generic
   type Element_Type is private;
   type Field_Names is (<>);
   type Field_JSON_Types is array (Field_Names)
     of GNATCOLL.JSON.JSON_Value_Type;
   Fields_Types : Field_JSON_Types;
   with procedure Set_Field (Data   : in out Element_Type;
                             Field  : Field_Names;
                             Value  : GNATCOLL.JSON.JSON_Value;
                             Result : out Ada2Json.Setter_Result_Type);

package Ada2Json.Deserializer is

   package Result_Type is new Ada2Json.Read_Result
     (Element_Type => Element_Type);

   function Read (Value : GNATCOLL.JSON.JSON_Value)
                  return Result_Type.Read_Result_Type
     with Pre => GNATCOLL.JSON.Kind (Value) in GNATCOLL.JSON.JSON_Object_Type;

   procedure Nullable (F : Field_Names);

end Ada2Json.Deserializer;
