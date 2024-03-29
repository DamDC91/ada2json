with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package Test_Type is

   type My_Mod is mod 256;
   type My_Float is digits 6 range 0.0 .. 1.0;

   type My_Small_Record is record
      D1 : My_Mod;
      D2 : My_Float;
   end record;

   type My_Index is range 0 .. 9;
   type My_Array is array (My_Index) of Integer;

   package My_Vec is new Ada.Containers.Vectors
     (Index_Type => Positive,
      Element_Type => Float);

   type My_Record is record
      F1 : Integer;
      F2 : Float;
      F3 : Ada.Strings.Unbounded.Unbounded_String;
      F4 : My_Array;
      F5 : My_Small_Record;
      F6 : My_Vec.Vector;
   end record;

end Test_Type;
