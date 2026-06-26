--  grafalgo.ads
--  Version: 0.12
--  Description: Specification of Grafalgo library in Ada, including graph
--  data structures and algorithm interfaces.

package Grafalgo is

   -- Basic Graph Data Structures
   type Vertex is range 0 .. 1000;
   type Edge is record
      From, To : Vertex;
      Weight   : Integer;
   end record;

   type Graph is private;

   -- Minimum Spanning Tree Algorithms
   function Prim_MST (G : Graph) return Integer;
   function Kruskal_MST (G : Graph) return Integer;
   function Cheriton_Tarjan_MST (G : Graph) return Integer;

   -- Shortest Path Algorithms
   function Dijkstra_Shortest_Path (G : Graph; Source, Target : Vertex) 
     return Integer;
   function Bellman_Moore_Shortest_Path (G : Graph; Source, Target : Vertex)
     return Integer;

   -- Maximum Flow Algorithms
   function Ford_Fulkerson_Max_Flow (G : Graph; Source, Sink : Vertex) 
     return Integer;
   function Dinic_Max_Flow (G : Graph; Source, Sink : Vertex) 
     return Integer;

   -- Graph Matching and Edge Coloring
   function Hopcroft_Karp_Matching (G : Graph) return Integer;
   function Hungarian_Algorithm_Matching (G : Graph) return Integer;
   function Gabow_Tarjan_Edge_Coloring (G : Graph) return Integer;

   -- Graph Operations
   procedure Initialize (G : out Graph);
   procedure Add_Vertex (G : in out Graph; V : Vertex);
   procedure Add_Edge (G : in out Graph; E : Edge);
   procedure Add_Directed_Edge (G : in out Graph; From, To : Vertex;
      Weight : Integer);
   function Is_Empty (G : Graph) return Boolean;

private
   -- Private implementation details
   Max_Vertices : constant := 1000;
   No_Edge : constant Integer := Integer'Last;
   
   type Adjacency_Row is array (Vertex range 0 .. Max_Vertices) of Integer;
   type Adjacency_Matrix is array (Vertex range 0 .. Max_Vertices) of
     Adjacency_Row;
   
   type Graph is record
      Vertex_Count : Vertex := 0;
      Adjacency : Adjacency_Matrix := (others => (others => No_Edge));
   end record;

end Grafalgo;
