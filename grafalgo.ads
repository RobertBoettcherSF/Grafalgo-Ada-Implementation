--  grafalgo.ads
--  Version: 0.04
--  Description: Specification of Grafalgo library in Ada, including graph data structures and algorithm interfaces.

with Ada.Containers.Doubly_Linked_Lists;

package Grafalgo is

   -- Basic Graph Data Structures
   type Vertex is range 0 .. Integer'Last;
   type Edge is record
      From, To : Vertex;
      Weight   : Integer;
   end record;

   type Graph is limited private;

   -- Minimum Spanning Tree Algorithms
   function Prim_MST (G : Graph) return Integer;
   function Kruskal_MST (G : Graph) return Integer;
   function Cheriton_Tarjan_MST (G : Graph) return Integer;

   -- Shortest Path Algorithms
   function Dijkstra_Shortest_Path (G : Graph; Source, Target : Vertex) return Integer;
   function Bellman_Moore_Shortest_Path (G : Graph; Source, Target : Vertex) return Integer;

   -- Maximum Flow Algorithms
   function Ford_Fulkerson_Max_Flow (G : Graph; Source, Sink : Vertex) return Integer;
   function Dinic_Max_Flow (G : Graph; Source, Sink : Vertex) return Integer;

   -- Graph Matching and Edge Coloring
   function Hopcroft_Karp_Matching (G : Graph) return Integer;
   function Hungarian_Algorithm_Matching (G : Graph) return Integer;
   function Gabow_Tarjan_Edge_Coloring (G : Graph) return Integer;

   -- Graph Operations
   procedure Add_Vertex (G : in out Graph; V : Vertex);
   procedure Add_Edge (G : in out Graph; E : Edge);
   function Is_Empty (G : Graph) return Boolean;

private
   -- Private implementation details, including data structures and internal functions
   package Vertex_Lists is new Ada.Containers.Doubly_Linked_Lists(Vertex);
   use Vertex_Lists;
   
   type Edge_Record is record
      To : Vertex;
      Weight : Integer;
   end record;
   
   package Edge_Lists is new Ada.Containers.Doubly_Linked_Lists(Edge_Record);
   use Edge_Lists;
   
   type Adjacency_Map is array (Vertex range <>) of Edge_Lists.List;
   type Adjacency_Map_Access is access Adjacency_Map;
   
   type Graph is record
      Vertices : Vertex_Lists.List;
      Adjacency : Adjacency_Map_Access;
      Max_Vertex : Vertex := 0;
   end record;

end Grafalgo;
