with GNATCOLL.JSON;
with Ada.Containers.Vectors;
with Ada2Json.Read_Result;

generic
   type Element_Type is private;
   type Index_Type is range <>;
   with package Element_Read_Result is new Ada2Json.Read_Result (Element_Type);
   with package Vectors is new Ada.Containers.Vectors
     (Element_Type => Element_Type,
      Index_Type   => Index_Type);
   with function Get (Value : GNATCOLL.JSON.JSON_Value)
                      return Element_Read_Result.Read_Result_Type;
   with function Create (Data : Element_Type)
                         return GNATCOLL.JSON.JSON_Value;

package Ada2Json.Vector_Utils is

   package Read_Result is new Ada2Json.Read_Result (Vectors.Vector);

   function Get (Value : GNATCOLL.JSON.JSON_Value) return Read_Result.Read_Result_Type
     with Pre => GNATCOLL.JSON.Kind (Value)
       in GNATCOLL.JSON.JSON_Array_Type;

   function Create (Data : Vectors.Vector) return GNATCOLL.JSON.JSON_Value
     with Post => GNATCOLL.JSON.Kind (Create'Result)
       in GNATCOLL.JSON.JSON_Array_Type;

end Ada2Json.Vector_Utils;
