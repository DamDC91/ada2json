with Ada.Unchecked_Conversion;

package body Ada2Json.Mapper is

   function Read (Value : GNATCOLL.JSON.JSON_Value)
                  return Element_Type
   is
   begin
      return Deserialize.Read (Value);
   end Read;

   function Read_Array (Value : GNATCOLL.JSON.JSON_Value)
                        return Vectors.Vector
   is
      function Conversion is new Ada.Unchecked_Conversion
        (Source => Deserialize.Vectors.Vector,
         Target => Vectors.Vector);
   begin
      return Conversion (Deserialize.Read_Array (Value));
   end Read_Array;

   function Write (Data : Element_Type;
                   Compact : Boolean := False)
                   return Ada.Strings.Unbounded.Unbounded_String
   is
   begin
      return Serialize.Write (Data, Compact);
   end Write;

   function Write_Array (Data : Vectors.Vector;
                         Compact : Boolean := False)
                         return Ada.Strings.Unbounded.Unbounded_String
   is
      function Conversion is new Ada.Unchecked_Conversion
        (Source => Vectors.Vector,
         Target => Serialize.Vectors.Vector);
   begin
      return Serialize.Write_Array (Conversion (Data), Compact);
   end Write_Array;

   function Create_JSON_Value (Data : Element_Type)
                               return GNATCOLL.JSON.JSON_Value
   is
   begin
      return Serialize.Create_JSON_Value (Data);
   end Create_JSON_Value;

   function Create_JSON_Array (Data : Vectors.Vector)
                               return GNATCOLL.JSON.JSON_Value
   is
      function Conversion is new Ada.Unchecked_Conversion
        (Source => Vectors.Vector,
         Target => Serialize.Vectors.Vector);
   begin
      return Serialize.Create_JSON_Array (Conversion (Data));
   end Create_JSON_Array;

end Ada2Json.Mapper;
