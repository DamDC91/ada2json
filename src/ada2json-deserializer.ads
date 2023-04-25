with GNATCOLL.JSON;
with Ada.Containers.Vectors;

generic
   type T is private;
   type Field_Names is (<>);
   type Field_JSON_Types is array (Field_Names)
     of GNATCOLL.JSON.JSON_Value_Type;
   Fields_Types : Field_JSON_Types;
   with procedure Set_Field (Data  : in out T;
                             Field : Field_Names;
                             Value : GNATCOLL.JSON.JSON_Value);

package Ada2Json.Deserializer is

   package Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => T);

   function Read (Value : GNATCOLL.JSON.JSON_Value)
                  return T
     with Pre => GNATCOLL.JSON.Kind (Value) in GNATCOLL.JSON.JSON_Object_Type;

   function Read_Array (Value : GNATCOLL.JSON.JSON_Value)
                        return Vectors.Vector
     with Pre => GNATCOLL.JSON.Kind (Value) in GNATCOLL.JSON.JSON_Array_Type;

end Ada2Json.Deserializer;