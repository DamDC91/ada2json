with GNATCOLL.JSON;
with Ada.Containers.Vectors;

generic
   type Element_Type is private;
   type Index_Type is range <>;
   with package Vectors is new Ada.Containers.Vectors
     (Element_Type => Element_Type,
      Index_Type   => Index_Type);
   with function Get (Value : GNATCOLL.JSON.JSON_Value)
                      return Element_Type;
   with function Create (Data : Element_Type)
                         return GNATCOLL.JSON.JSON_Value;

package Ada2Json.Vector_Utils is

   function Get (Value : GNATCOLL.JSON.JSON_Value) return Vectors.Vector
     with Pre => GNATCOLL.JSON.Kind (Value)
       in GNATCOLL.JSON.JSON_Array_Type;

   function Create (Data : Vectors.Vector) return GNATCOLL.JSON.JSON_Value
     with Post => GNATCOLL.JSON.Kind (Create'Result)
       in GNATCOLL.JSON.JSON_Array_Type;

end Ada2Json.Vector_Utils;
