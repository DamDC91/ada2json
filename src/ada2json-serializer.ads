with GNATCOLL.JSON;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;

generic
   type Element_Type is private;
   type Field_Names is (<>);
   with function Get_Field (Data  : Element_Type;
                            Field : Field_Names)
                            return GNATCOLL.JSON.JSON_Value;

package Ada2Json.Serializer is

   package Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Element_Type);

   function Create_JSON_Value (Data : Element_Type)
                               return GNATCOLL.JSON.JSON_Value
     with Post => GNATCOLL.JSON.Kind (Create_JSON_Value'Result)
       in GNATCOLL.JSON.JSON_Object_Type;

   function Create_JSON_Array (Data : Vectors.Vector)
                               return GNATCOLL.JSON.JSON_Value
     with Post => GNATCOLL.JSON.Kind (Create_JSON_Array'Result)
       in GNATCOLL.JSON.JSON_Array_Type;

   function Write (Data   : Element_Type;
                   Compact : Boolean := False)
                   return Ada.Strings.Unbounded.Unbounded_String;

   function Write_Array (Data    : Vectors.Vector;
                         Compact : Boolean := False)
                         return Ada.Strings.Unbounded.Unbounded_String;

end Ada2Json.Serializer;
