with Ada.Text_IO;
with GNATCOLL.JSON;
with Ada.Strings.Unbounded;
with Test_Type;
with Test_Type.Json_Mapping;
with Ada.Exceptions;

procedure Test is

   function Get_Content (F : Ada.Text_IO.File_Type)
                         return Ada.Strings.Unbounded.Unbounded_String
   is
      use Ada.Strings.Unbounded;
      Content : Unbounded_String := Null_Unbounded_String;
   begin
      while not Ada.Text_IO.End_Of_File (F) loop
         Append (Content, Ada.Text_IO.Get_Line (F));
      end loop;
      return Content;
   end Get_Content;

   procedure Load_And_Test (File : String;
                            Exception_Expected : String)
   is
      F : Ada.Text_IO.File_Type;
      Content : Ada.Strings.Unbounded.Unbounded_String;
      Value : GNATCOLL.JSON.JSON_Value;
      D : Test_Type.My_Record;
   begin
      Ada.Text_IO.Open (F, Ada.Text_IO.In_File, File);
      Content := Get_Content (F);
      Value := GNATCOLL.JSON.Read (Strm => Content,
                                   Filename => File);
      begin
         D := Test_Type.Json_Mapping.Mapper.Read (Value);
      exception
         when e : others =>
            if Exception_Expected'Length = 0 or else
              Exception_Expected /= Ada.Exceptions.Exception_Name (e)
            then
               Ada.Text_IO.Put_Line ("Test " & File & " failed");
               raise;
            end if;
      end;
      Ada.Text_IO.Put_Line ("Test " & File & " passed");
      Ada.Text_IO.Close (F);
   end Load_And_Test;

begin
   Load_And_Test ("test1.json", "");
   Load_And_Test ("test2.json", "ADA2JSON.UNKNOWN_FIELD");
   Load_And_Test ("test3.json", "ADA2JSON.MISSING_FIELD");
   Load_And_Test ("test4.json", "ADA2JSON.UNKNOWN_FIELD");
   Load_And_Test ("test5.json", "ADA2JSON.WRONG_ARRAY_SIZE");
   Load_And_Test ("test6.json", "ADA2JSON.MISSING_FIELD");
end Test;
