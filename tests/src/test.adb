pragma Ada_2022;
with Ada.Text_IO;
with GNATCOLL.JSON;
with Ada.Strings.Unbounded;
with Test_Type;
with Test_Type.Json_Mapping;
with Ada2Json;

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
                            Error_Expected : Ada2Json.Result_Kind
                            := Ada2Json.Success)
   is
      Value : constant GNATCOLL.JSON.JSON_Value :=
        Read_JSON_From_File (FileName);

      D : constant Test_Type.Json_Mapping.Mapper.Read_Result_Type
        := Test_Type.Json_Mapping.Mapper.Read (Value);
      use type Ada2Json.Result_Kind;
   begin
      if D.Kind /= Error_Expected then
         Ada.Text_IO.Put_Line ("Test " & FileName & " failed");
         if D.Kind in Ada2Json.Error_Kind then
            Ada.Text_IO.Put_Line
              (Ada.Strings.Unbounded.To_String (D.Error_Msg));
         end if;
         return;
      end if;

      if D.Kind = Ada2Json.Success then
         declare
            Result : constant GNATCOLL.JSON.Read_Result :=
              GNATCOLL.JSON.Read
                (Test_Type.Json_Mapping.Mapper.Write (D.Value));

         begin
            if Result.Success then
               declare
                  D2 : constant Test_Type.Json_Mapping.Mapper.Read_Result_Type
                    := Test_Type.Json_Mapping.Mapper.Read (Result.Value);
                  use type Test_Type.My_Record;
               begin
                  if D2.Kind in Ada2Json.Error_Kind
                    or else D2.Value /= D.value
                  then
                     Ada.Text_IO.Put_Line ("Test " & FileName & " failed");
                     Ada.Text_IO.Put_Line ("Failed to read Data back");
                     return;
                  end if;
               end;
            else
               Ada.Text_IO.Put_Line ("Test " & FileName & " failed");
               Ada.Text_IO.Put_Line ("Failed to write JSON: " &
                                       GNATCOLL.JSON.Format_Parsing_Error
                                       (Result.Error));
               return;
            end if;
         end;
      end if;

      Ada.Text_IO.Put_Line ("Test " & FileName & " passed");
   end Load_And_Test;

begin
   Load_And_Test ("test1.json");
   Load_And_Test ("test2.json", Ada2Json.Type_Error);
   Load_And_Test ("test3.json", Ada2Json.Missing_Field);
   Load_And_Test ("test4.json", Ada2Json.Unknown_Field);
   Load_And_Test ("test5.json", Ada2Json.Wrong_Array_Size);
   Load_And_Test ("test6.json", Ada2Json.Missing_Field);
   Load_And_Test ("test7.json", Ada2Json.Type_Error);
end Test;
