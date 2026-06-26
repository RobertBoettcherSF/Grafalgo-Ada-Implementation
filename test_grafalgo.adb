--  test_grafalgo.adb
--  Version: 0.04
--  Description: Comprehensive test suite for Grafalgo library

with Ada.Text_IO; use Ada.Text_IO;
with Grafalgo; use Grafalgo;

procedure Test_Grafalgo is

   -- Test helper procedures
   procedure Assert (Condition : Boolean; Message : String) is
   begin
      if not Condition then
         Put_Line("FAIL: " & Message);
         raise Constraint_Error with "Test assertion failed: " & Message;
      else
         Put_Line("PASS: " & Message);
      end if;
   end Assert;

   procedure Assert_Equal (Actual, Expected : Integer; Message : String) is
   begin
      if Actual /= Expected then
         Put_Line("FAIL: " & Message & " (Expected: " & 
                  Integer'Image(Expected) & ", Actual: " & 
                  Integer'Image(Actual) & ")");
         raise Constraint_Error with "Test assertion failed";
      else
         Put_Line("PASS: " & Message);
      end if;
   end Assert_Equal;

   -- Test cases
   G : Graph;

begin
   Put_Line("=== Grafalgo Test Suite ===");
   New_Line;

   -- Test 1: Empty graph
   Put_Line("--- Test 1: Empty Graph ---");
   Initialize(G);
   Assert(Is_Empty(G), "Empty graph is empty");
   Assert_Equal(Prim_MST(G), 0, "MST of empty graph is 0");
   Assert_Equal(Kruskal_MST(G), 0, "Kruskal MST of empty graph is 0");
   Assert_Equal(Cheriton_Tarjan_MST(G), 0, 
     "Cheriton-Tarjan MST of empty graph is 0");
   New_Line;

   -- Test 2: Single vertex graph
   Put_Line("--- Test 2: Single Vertex Graph ---");
   Initialize(G);
   Add_Vertex(G, 0);
   Assert(not Is_Empty(G), "Graph with one vertex is not empty");
   Assert_Equal(Prim_MST(G), 0, "MST of single vertex graph is 0");
   Assert_Equal(Dijkstra_Shortest_Path(G, 0, 0), 0, 
     "Shortest path from vertex to itself is 0");
   New_Line;

   -- Test 3: Two vertices, one edge
   Put_Line("--- Test 3: Two Vertices, One Edge ---");
   Initialize(G);
   Add_Vertex(G, 0);
   Add_Vertex(G, 1);
   Add_Edge(G, (From => 0, To => 1, Weight => 5));
   Assert_Equal(Prim_MST(G), 5, "MST of two vertices with one edge is 5");
   Assert_Equal(Kruskal_MST(G), 5, 
     "Kruskal MST of two vertices with one edge is 5");
   Assert_Equal(Dijkstra_Shortest_Path(G, 0, 1), 5, 
     "Shortest path from 0 to 1 is 5");
   Assert_Equal(Dijkstra_Shortest_Path(G, 1, 0), 5, 
     "Shortest path from 1 to 0 is 5");
   New_Line;

   -- Test 4: Triangle graph (3 vertices, all connected)
   Put_Line("--- Test 4: Triangle Graph ---");
   Initialize(G);
   Add_Vertex(G, 0);
   Add_Vertex(G, 1);
   Add_Vertex(G, 2);
   Add_Edge(G, (From => 0, To => 1, Weight => 3));
   Add_Edge(G, (From => 1, To => 2, Weight => 4));
   Add_Edge(G, (From => 0, To => 2, Weight => 5));
   Assert_Equal(Prim_MST(G), 7, "MST of triangle graph is 7");
   Assert_Equal(Kruskal_MST(G), 7, "Kruskal MST of triangle graph is 7");
   Assert_Equal(Dijkstra_Shortest_Path(G, 0, 2), 5, 
     "Shortest path from 0 to 2 is 5");
   Assert_Equal(Dijkstra_Shortest_Path(G, 0, 1), 3, 
     "Shortest path from 0 to 1 is 3");
   New_Line;

   -- Test 5: Square graph (4 vertices in a square)
   Put_Line("--- Test 5: Square Graph ---");
   Initialize(G);
   Add_Vertex(G, 0);
   Add_Vertex(G, 1);
   Add_Vertex(G, 2);
   Add_Vertex(G, 3);
   Add_Edge(G, (From => 0, To => 1, Weight => 1));
   Add_Edge(G, (From => 1, To => 2, Weight => 2));
   Add_Edge(G, (From => 2, To => 3, Weight => 1));
   Add_Edge(G, (From => 3, To => 0, Weight => 2));
   Add_Edge(G, (From => 0, To => 2, Weight => 3));
   Assert_Equal(Prim_MST(G), 4, "MST of square graph is 4");
   Assert_Equal(Kruskal_MST(G), 4, "Kruskal MST of square graph is 4");
   Assert_Equal(Dijkstra_Shortest_Path(G, 0, 3), 2, 
     "Shortest path from 0 to 3 is 3");
   New_Line;

   -- Test 6: Disconnected graph
   Put_Line("--- Test 6: Disconnected Graph ---");
   Initialize(G);
   Add_Vertex(G, 0);
   Add_Vertex(G, 1);
   Add_Vertex(G, 2);
   Add_Edge(G, (From => 0, To => 1, Weight => 5));
   Assert_Equal(Prim_MST(G), 5, 
     "MST of disconnected graph (2 connected, 1 isolated) is 5");
   Assert_Equal(Dijkstra_Shortest_Path(G, 0, 2), Integer'Last, 
     "No path from 0 to 2 in disconnected graph");
   New_Line;

   -- Test 7: Bellman-Moore with negative weights
   Put_Line("--- Test 7: Bellman-Moore with Negative Weights ---");
   Initialize(G);
   Add_Vertex(G, 0);
   Add_Vertex(G, 1);
   Add_Vertex(G, 2);
   Add_Edge(G, (From => 0, To => 1, Weight => -1));
   Add_Edge(G, (From => 1, To => 2, Weight => -2));
   Add_Edge(G, (From => 0, To => 2, Weight => 4));
   Assert_Equal(Bellman_Moore_Shortest_Path(G, 0, 2), -3, 
     "Bellman-Moore handles negative weights: 0->1->2 = -3");
   New_Line;

   -- Test 8: Maximum Flow - simple graph
   Put_Line("--- Test 8: Maximum Flow (Ford-Fulkerson) ---");
   Initialize(G);
   Add_Vertex(G, 0);
   Add_Vertex(G, 1);
   Add_Vertex(G, 2);
   Add_Vertex(G, 3);
   Add_Edge(G, (From => 0, To => 1, Weight => 10));
   Add_Edge(G, (From => 0, To => 2, Weight => 5));
   Add_Edge(G, (From => 1, To => 2, Weight => 15));
   Add_Edge(G, (From => 1, To => 3, Weight => 10));
   Add_Edge(G, (From => 2, To => 3, Weight => 10));
   Assert_Equal(Ford_Fulkerson_Max_Flow(G, 0, 3), 15, 
     "Max flow from 0 to 3 is 15");
   Assert_Equal(Dinic_Max_Flow(G, 0, 3), 15, 
     "Dinic max flow from 0 to 3 is 15");
   New_Line;

   -- Test 9: Graph operations
   Put_Line("--- Test 9: Graph Operations ---");
   Initialize(G);
   Assert(Is_Empty(G), "New graph is empty");
   Add_Vertex(G, 0);
   Assert(not Is_Empty(G), "Graph with vertex is not empty");
   Add_Edge(G, (From => 0, To => 1, Weight => 7));
   Assert(not Is_Empty(G), "Graph with edge is not empty");
   New_Line;

   -- Test 10: Placeholder algorithms (should return 0)
   Put_Line("--- Test 10: Placeholder Algorithms ---");
   Initialize(G);
   Add_Vertex(G, 0);
   Add_Vertex(G, 1);
   Add_Edge(G, (From => 0, To => 1, Weight => 1));
   Assert_Equal(Hopcroft_Karp_Matching(G), 0, 
     "Hopcroft-Karp returns 0 (placeholder)");
   Assert_Equal(Hungarian_Algorithm_Matching(G), 0, 
     "Hungarian algorithm returns 0 (placeholder)");
   Assert_Equal(Gabow_Tarjan_Edge_Coloring(G), 0, 
     "Gabow-Tarjan edge coloring returns 0 (placeholder)");
   New_Line;

   -- Test 11: Larger graph for MST
   Put_Line("--- Test 11: Larger Graph for MST Algorithms ---");
   Initialize(G);
   Add_Vertex(G, 0);
   Add_Vertex(G, 1);
   Add_Vertex(G, 2);
   Add_Vertex(G, 3);
   Add_Vertex(G, 4);
   Add_Edge(G, (From => 0, To => 1, Weight => 2));
   Add_Edge(G, (From => 0, To => 2, Weight => 3));
   Add_Edge(G, (From => 1, To => 2, Weight => 1));
   Add_Edge(G, (From => 1, To => 3, Weight => 5));
   Add_Edge(G, (From => 2, To => 3, Weight => 4));
   Add_Edge(G, (From => 2, To => 4, Weight => 2));
   Add_Edge(G, (From => 3, To => 4, Weight => 1));
   Assert_Equal(Prim_MST(G), 8, "Prim MST of larger graph is 8");
   Assert_Equal(Kruskal_MST(G), 8, "Kruskal MST of larger graph is 8");
   Assert_Equal(Cheriton_Tarjan_MST(G), 8, 
     "Cheriton-Tarjan MST of larger graph is 8");
   New_Line;

   -- Test 12: Dijkstra with multiple paths
   Put_Line("--- Test 12: Dijkstra with Multiple Paths ---");
   Initialize(G);
   Add_Vertex(G, 0);
   Add_Vertex(G, 1);
   Add_Vertex(G, 2);
   Add_Vertex(G, 3);
   Add_Edge(G, (From => 0, To => 1, Weight => 1));
   Add_Edge(G, (From => 0, To => 2, Weight => 4));
   Add_Edge(G, (From => 1, To => 2, Weight => 2));
   Add_Edge(G, (From => 1, To => 3, Weight => 6));
   Add_Edge(G, (From => 2, To => 3, Weight => 3));
   Assert_Equal(Dijkstra_Shortest_Path(G, 0, 3), 6, 
     "Shortest path 0->1->2->3 is 6");
   New_Line;

   Put_Line("=== All Tests Passed ===");

   exception
      when Constraint_Error =>
         Put_Line("TESTS FAILED!");
         raise;

end Test_Grafalgo;
