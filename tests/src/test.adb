pragma Ada_2022;
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

   function Read_JSON_From_File (FileName : String)
                                 return GNATCOLL.JSON.JSON_Value
   is
      F : Ada.Text_IO.File_Type;
      Content : Ada.Strings.Unbounded.Unbounded_String;
      Value : GNATCOLL.JSON.JSON_Value;
   begin
      Ada.Text_IO.Open (F, Ada.Text_IO.In_File, FileName);
      Content := Get_Content (F);
      Value := GNATCOLL.JSON.Read (Strm => Content,
                                   Filename => FileName);
      Ada.Text_IO.Close (F);
      return Value;
   end Read_JSON_From_File;

   procedure Load_And_Test (FileName : String;
                            Exception_Expected : String := "")
   is
      Value : constant GNATCOLL.JSON.JSON_Value :=
        Read_JSON_From_File (FileName);
      D : Test_Type.My_Record;
      Data_Valid : Boolean := True;
   begin
      begin
         D := Test_Type.Json_Mapping.Mapper.Read (Value);
      exception
         when e : others =>
            Data_Valid := False;
            if Exception_Expected'Length = 0 or else
              Exception_Expected /= Ada.Exceptions.Exception_Name (e)
            then
               Ada.Text_IO.Put_Line ("Test " & FileName & " failed");
               raise;
            end if;
      end;

      if Data_Valid then
         declare
            D2 : Test_Type.My_Record;
            Result : constant GNATCOLL.JSON.Read_Result :=
              GNATCOLL.JSON.Read (Test_Type.Json_Mapping.Mapper.Write (D));
            use type Test_Type.My_Record;
         begin
            if Result.Success then
               D2 := Test_Type.Json_Mapping.Mapper.Read (Result.Value);
               if D2 /= D then
                  Ada.Text_IO.Put_Line ("Test " & FileName & " failed");
                  Ada.Text_IO.Put_Line ("Failed to read Data back");
                  return;
               end if;
            else
               Ada.Text_IO.Put_Line ("Test " & FileName & " failed");
               Ada.Text_IO.Put_Line ("Failed to write JSON: " &
                                       GNATCOLL.JSON.Format_Parsing_Error
                                       (Result.Error));
               return;
            end if;
         exception
            when others =>
               Ada.Text_IO.Put_Line ("Test " & FileName & " failed");
               raise;
         end;
      end if;

      Ada.Text_IO.Put_Line ("Test " & FileName & " passed");
   end Load_And_Test;

begin
   Load_And_Test ("test1.json");
   Load_And_Test ("test2.json", "ADA2JSON.UNKNOWN_FIELD");
   Load_And_Test ("test3.json", "ADA2JSON.MISSING_FIELD");
   Load_And_Test ("test4.json", "ADA2JSON.UNKNOWN_FIELD");
   Load_And_Test ("test5.json", "ADA2JSON.WRONG_ARRAY_SIZE");
   Load_And_Test ("test6.json", "ADA2JSON.MISSING_FIELD");
   Load_And_Test ("test7.json", "ADA2JSON.TYPE_CONSTRAINT");
end Test;
