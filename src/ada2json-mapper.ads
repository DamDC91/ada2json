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

   with procedure Set_Field (Data  : in out Element_Type;
                             Field : Field_Names;
                             Value : GNATCOLL.JSON.JSON_Value);

package Ada2Json.Mapper is

   package Vectors is new Ada.Containers.Vectors (Index_Type => Positive,
                                                  Element_Type => Element_Type);

   function Read (Value : GNATCOLL.JSON.JSON_Value)
                  return Element_Type
     with Pre => GNATCOLL.JSON.Kind (Value) in GNATCOLL.JSON.JSON_Object_Type;

   function Read_Array (Value : GNATCOLL.JSON.JSON_Value)
                        return Vectors.Vector
     with Pre => GNATCOLL.JSON.Kind (Value) in GNATCOLL.JSON.JSON_Array_Type;

   function Write (Data : Element_Type;
                   Compact : Boolean := False)
                   return Ada.Strings.Unbounded.Unbounded_String;

   function Write_Array (Data : Vectors.Vector;
                         Compact : Boolean := False)
                         return Ada.Strings.Unbounded.Unbounded_String;

   function Create_JSON_Value (Data : Element_Type)
                               return GNATCOLL.JSON.JSON_Value
        with Post => GNATCOLL.JSON.Kind (Create_JSON_Value'Result)
       in GNATCOLL.JSON.JSON_Object_Type;

   function Create_JSON_Array (Data : Vectors.Vector)
                               return GNATCOLL.JSON.JSON_Value
     with Post => GNATCOLL.JSON.Kind (Create_JSON_Array'Result)
       in GNATCOLL.JSON.JSON_Array_Type;

private
   package Serialize is new Ada2Json.Serializer
     (Element_Type           => Element_Type,
      Field_Names => Field_Names,
      Get_Field   => Get_Field);

   package Deserialize is new Ada2Json.Deserializer
     (Element_Type                => Element_Type,
      Field_Names      => Field_Names,
      Fields_Types     => Fields_Types,
      Field_JSON_Types => Field_JSON_Types,
      Set_Field        => Set_Field);

end Ada2Json.Mapper;
