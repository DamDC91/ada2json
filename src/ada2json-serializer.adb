with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

package body Ada2Json.Serializer is

   function Create_JSON_Value (Data : Element_Type)
                               return GNATCOLL.JSON.JSON_Value
   is
      use GNATCOLL.JSON;
      J : constant JSON_Value := Create_Object;
   begin
      for Field in Field_Names'First .. Field_Names'Last loop
         J.Set_Field (Field'Image, Get_Field (Data, Field));
      end loop;
      return J;
   end Create_JSON_Value;

   function Write (Data : Element_Type;
                   Compact : Boolean := False)
                   return Ada.Strings.Unbounded.Unbounded_String
   is
   begin
      return GNATCOLL.JSON.Write (Create_JSON_Value (Data), Compact);
   end Write;

   function Create_JSON_Array (Data : Vectors.Vector)
                               return GNATCOLL.JSON.JSON_Value
   is
      use GNATCOLL.JSON;
      J : constant JSON_Value := Create (Empty_Array);
   begin
      for V of Data loop
         Append (J, Create_JSON_Value (V));
      end loop;
      return J;
   end Create_JSON_Array;

   function Write_Array (Data : Vectors.Vector;
                         Compact : Boolean := False)
                         return Ada.Strings.Unbounded.Unbounded_String
   is

   begin
      return GNATCOLL.JSON.Write (Create_JSON_Array (Data), Compact);
   end Write_Array;

end Ada2Json.Serializer;
