--  main.adb
--  Version: 0.01
--  Description: Main procedure to demonstrate Grafalgo library usage.

with Ada.Text_IO; use Ada.Text_IO;
with Grafalgo; use Grafalgo;

procedure Main is
   G : Graph;
   E : Edge;
begin
   -- Example usage of Grafalgo library
   Add_Vertex(G, 1);
   Add_Vertex(G, 2);
   E := (From => 1, To => 2, Weight => 5);
   Add_Edge(G, E);

   -- Test algorithms
   Put_Line("Prim MST: " & Integer'Image(Prim_MST(G)));
   Put_Line("Dijkstra Shortest Path: " & Integer'Image(Dijkstra_Shortest_Path(G, 1, 2)));
   -- Additional test cases and output
end Main;
