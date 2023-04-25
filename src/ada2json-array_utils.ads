with GNATCOLL.JSON;

generic
   type Element_Type is private;
   type Index_Type is (<>);
   type Array_Type is array (Index_Type) of Element_Type;
   with function Get (Value : GNATCOLL.JSON.JSON_Value)
                      return Element_Type;
   with function Create (Data : Element_Type)
                         return GNATCOLL.JSON.JSON_Value;

package Ada2Json.Array_Utils is

   function Get (Value : GNATCOLL.JSON.JSON_Value) return Array_Type
     with Pre => GNATCOLL.JSON.Kind (Value) in GNATCOLL.JSON.JSON_Array_Type;

   function Create (Data : Array_Type) return GNATCOLL.JSON.JSON_Value
     with Post => GNATCOLL.JSON.Kind (Create'Result)
       in GNATCOLL.JSON.JSON_Array_Type;

end Ada2Json.Array_Utils;
