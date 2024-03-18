with GNATCOLL.JSON;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;
with Ada2Json.Deserializer;
with Ada2Json.Serializer;

generic
   type Element_Type is private;
   type Field_Names is (<>);
   type Field_JSON_Types is array (Field_Names)
     of GNATCOLL.JSON.JSON_Value_Type;
   Fields_Types : Field_JSON_Types;

   with function Get_Field (Data  : Element_Type;
                            Field : Field_Names)
                            return GNATCOLL.JSON.JSON_Value;

   with procedure Set_Field (Data   : in out Element_Type;
                             Field  : Field_Names;
                             Value  : GNATCOLL.JSON.JSON_Value;
                             Result : out Ada2Json.Setter_Result_Type);

package Ada2Json.Mapper is

   package Serialize is new Ada2Json.Serializer
     (Element_Type => Element_Type,
      Field_Names  => Field_Names,
      Get_Field    => Get_Field);

   package Deserialize is new Ada2Json.Deserializer
     (Element_Type     => Element_Type,
      Field_Names      => Field_Names,
      Fields_Types     => Fields_Types,
      Field_JSON_Types => Field_JSON_Types,
      Set_Field        => Set_Field);

   subtype Read_Result_Type is Deserialize.Result_Type.Read_Result_Type;

   function Read (Value : GNATCOLL.JSON.JSON_Value)
                  return Read_Result_Type
                  renames Deserialize.Read;


   function Write (Data : Element_Type;
                   Compact : Boolean := False)
                   return Ada.Strings.Unbounded.Unbounded_String
                   renames Serialize.Write;

end Ada2Json.Mapper;
