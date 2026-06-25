--  grafalgo.adb
--  Version: 0.03
--  Description: Implementation of Grafalgo library algorithms and data
--  structures in Ada.

with Ada.Containers.Doubly_Linked_Lists;
with Ada.Containers.Vectors;

package body Grafalgo is

   -- Helper function to initialize adjacency map
   procedure Initialize_Adjacency (G : in out Graph; Size : Vertex) is
   begin
      if G.Adjacency = null then
         G.Adjacency := new Adjacency_Map(0 .. Size);
      end if;
   end Initialize_Adjacency;

   -- Implementation of Prim's Minimum Spanning Tree Algorithm
   function Prim_MST (G : Graph) return Integer is
      package Vertex_Vectors is new Ada.Containers.Vectors
        (Index_Type => Positive, Element_Type => Vertex);
      use Vertex_Vectors;
      
      package Int_Vectors is new Ada.Containers.Vectors
        (Index_Type => Positive, Element_Type => Integer);
      use Int_Vectors;
      
      Key : Integer;
      Total_Weight : Integer := 0;
      In_MST : Vector;
      Min_Weight : Int_Vectors.Vector;
      Parent : Vertex_Vectors.Vector;
   begin
      if G.Adjacency = null or G.Vertices.Length = 0 then
         return 0;
      end if;
      
      -- Initialize data structures
      In_MST.Set_Length(G.Vertices.Length);
      Min_Weight.Set_Length(G.Vertices.Length);
      Parent.Set_Length(G.Vertices.Length);
      
      -- Start with first vertex
      declare
         First : Vertex := G.Vertices.First_Element;
      begin
         for V of G.Vertices loop
            Min_Weight.Replace_Element(V, Integer'Last);
            Parent.Replace_Element(V, Vertex'First);
         end loop;
         
         Min_Weight.Replace_Element(First, 0);
         Parent.Replace_Element(First, First);
         
         for I in 1 .. G.Vertices.Length loop
            -- Find vertex with minimum weight not in MST
            Key := Integer'Last;
            for V of G.Vertices loop
               if not In_MST.Element(V) and then Min_Weight.Element(V) < Key then
                  Key := Min_Weight.Element(V);
               end if;
            end loop;
            
            if Key = Integer'Last then
               exit;
            end if;
            
            Total_Weight := Total_Weight + Key;
            
            -- Update adjacent vertices
            for V of G.Vertices loop
               if not In_MST.Element(V) and then 
                 G.Adjacency(V).Length > 0 then
                  for E of G.Adjacency(V) loop
                     if E.Weight < Min_Weight.Element(E.To) then
                        Min_Weight.Replace_Element(E.To, E.Weight);
                        Parent.Replace_Element(E.To, V);
                     end if;
                  end loop;
               end if;
            end loop;
         end loop;
      end;
      
      return Total_Weight;
   end Prim_MST;

   -- Implementation of Kruskal's Minimum Spanning Tree Algorithm
   function Kruskal_MST (G : Graph) return Integer is
      package Edge_Vectors is new Ada.Containers.Vectors
        (Index_Type => Positive, Element_Type => Edge);
      use Edge_Vectors;
      
      All_Edges : Edge_Vectors.Vector;
      Total_Weight : Integer := 0;
      
      -- Union-Find data structure
      type Parent_Array is array (Vertex range <>) of Vertex;
      Parent_Array_Access : access Parent_Array;
      
      function Find (P : access Parent_Array; V : Vertex) return Vertex is
      begin
         if P(V) /= V then
            P(V) := Find(P, P(V));
         end if;
         return P(V);
      end Find;
      
      procedure Union (P : access Parent_Array; U, V : Vertex) is
         Root_U : Vertex := Find(P, U);
         Root_V : Vertex := Find(P, V);
      begin
         if Root_U /= Root_V then
            P(Root_V) := Root_U;
         end if;
      end Union;
   begin
      if G.Adjacency = null or G.Vertices.Length = 0 then
         return 0;
      end if;
      
      -- Collect all edges
      for V of G.Vertices loop
         for E of G.Adjacency(V) loop
            All_Edges.Append((From => V, To => E.To, Weight => E.Weight));
         end loop;
      end loop;
      
      -- Sort edges by weight (simple bubble sort for now)
      for I in 1 .. All_Edges.Length - 1 loop
         for J in 1 .. All_Edges.Length - I loop
            if All_Edges.Element(J).Weight > All_Edges.Element(J + 1).Weight then
               declare
                  Temp : Edge := All_Edges.Element(J);
               begin
                  All_Edges.Replace_Element(J, All_Edges.Element(J + 1));
                  All_Edges.Replace_Element(J + 1, Temp);
               end;
            end if;
         end loop;
      end loop;
      
      -- Initialize Union-Find
      Parent_Array_Access := new Parent_Array(0 .. G.Max_Vertex);
      for V in 0 .. G.Max_Vertex loop
         Parent_Array_Access(V) := V;
      end loop;
      
      -- Process edges in sorted order
      for E of All_Edges loop
         if Find(Parent_Array_Access, E.From) /=
           Find(Parent_Array_Access, E.To) then
            Union(Parent_Array_Access, E.From, E.To);
            Total_Weight := Total_Weight + E.Weight;
         end if;
      end loop;
      
      Free(Parent_Array_Access);
      return Total_Weight;
   end Kruskal_MST;

   -- Implementation of Cheriton-Tarjan Minimum Spanning Tree Algorithm
   function Cheriton_Tarjan_MST (G : Graph) return Integer is
   begin
      -- Simplified implementation - uses Prim's for now
      return Prim_MST(G);
   end Cheriton_Tarjan_MST;

   -- Implementation of Dijkstra's Shortest Path Algorithm
   function Dijkstra_Shortest_Path (G : Graph; Source, Target : Vertex) 
     return Integer is
      package Int_Arrays is new Ada.Containers.Vectors
        (Index_Type => Positive, Element_Type => Integer);
      use Int_Arrays;
      
      package Bool_Arrays is new Ada.Containers.Vectors
        (Index_Type => Positive, Element_Type => Boolean);
      use Bool_Arrays;
      
      Dist : Int_Arrays.Vector;
      Visited : Bool_Arrays.Vector;
      Min_Dist : Integer;
      Current : Vertex;
   begin
      if G.Adjacency = null then
         return Integer'Last;
      end if;
      
      Dist.Set_Length(G.Vertices.Length);
      Visited.Set_Length(G.Vertices.Length);
      
      for V of G.Vertices loop
         Dist.Replace_Element(V, Integer'Last);
         Visited.Replace_Element(V, False);
      end loop;
      
      Dist.Replace_Element(Source, 0);
      
      for I in 1 .. G.Vertices.Length loop
         Min_Dist := Integer'Last;
         Current := Vertex'First;
         
         for V of G.Vertices loop
            if not Visited.Element(V) and then Dist.Element(V) < Min_Dist then
               Min_Dist := Dist.Element(V);
               Current := V;
            end if;
         end loop;
         
         if Min_Dist = Integer'Last then
            exit;
         end if;
         
         Visited.Replace_Element(Current, True);
         
         if G.Adjacency(Current).Length > 0 then
            for E of G.Adjacency(Current) loop
               if not Visited.Element(E.To) and then 
                 Dist.Element(Current) + E.Weight < Dist.Element(E.To) then
                  Dist.Replace_Element(E.To, Dist.Element(Current) + E.Weight);
               end if;
            end loop;
         end if;
      end loop;
      
      return Dist.Element(Target);
   end Dijkstra_Shortest_Path;

   -- Implementation of Bellman-Moore Shortest Path Algorithm
   function Bellman_Moore_Shortest_Path (G : Graph; Source, Target : Vertex)
     return Integer is
      package Int_Arrays is new Ada.Containers.Vectors
        (Index_Type => Positive, Element_Type => Integer);
      use Int_Arrays;
      
      Dist : Int_Arrays.Vector;
      Relaxed : Boolean;
   begin
      if G.Adjacency = null then
         return Integer'Last;
      end if;
      
      Dist.Set_Length(G.Vertices.Length);
      
      for V of G.Vertices loop
         Dist.Replace_Element(V, Integer'Last);
      end loop;
      
      Dist.Replace_Element(Source, 0);
      
      -- Relax all edges V-1 times
      for I in 1 .. G.Vertices.Length - 1 loop
         Relaxed := False;
         for V of G.Vertices loop
            if G.Adjacency(V).Length > 0 then
               for E of G.Adjacency(V) loop
                  if Dist.Element(V) /= Integer'Last and then
                    Dist.Element(V) + E.Weight < Dist.Element(E.To) then
                     Dist.Replace_Element(E.To, Dist.Element(V) + E.Weight);
                     Relaxed := True;
                  end if;
               end loop;
            end if;
         end loop;
         
         if not Relaxed then
            exit;
         end if;
      end loop;
      
      return Dist.Element(Target);
   end Bellman_Moore_Shortest_Path;

   -- Implementation of Ford-Fulkerson Maximum Flow Algorithm
   function Ford_Fulkerson_Max_Flow (G : Graph; Source, Sink : Vertex)
     return Integer is
      package Int_2D_Vectors is new Ada.Containers.Vectors
        (Index_Type => Positive, Element_Type => Integer);
      use Int_2D_Vectors;
      
      -- Create residual graph
      Residual : Int_2D_Vectors.Vector;
      Max_Flow : Integer := 0;
      
      -- BFS to find augmenting path
      function BFS (Residual : Int_2D_Vectors.Vector; Source, Sink : Vertex;
                    Parent : out Int_2D_Vectors.Vector) return Boolean is
         package Bool_Vectors is new Ada.Containers.Vectors
           (Index_Type => Positive, Element_Type => Boolean);
         use Bool_Vectors;
         
         Visited : Bool_Vectors.Vector;
         Queue : Vertex_Vectors.Vector;
      begin
         Visited.Set_Length(G.Vertices.Length);
         Parent.Set_Length(G.Vertices.Length);
         Queue.Set_Length(G.Vertices.Length);
         
         for V of G.Vertices loop
            Visited.Replace_Element(V, False);
            Parent.Replace_Element(V, Vertex'First);
         end loop;
         
         Visited.Replace_Element(Source, True);
         Queue.Append(Source);
         
         while Queue.Length > 0 loop
            declare
               U : Vertex := Queue.First_Element;
            begin
               Queue.Delete_First;
               
               for V of G.Vertices loop
                  if not Visited.Element(V) and then 
                    Residual.Element(U * G.Max_Vertex + V) > 0 then
                     Visited.Replace_Element(V, True);
                     Parent.Replace_Element(V, U);
                     Queue.Append(V);
                     
                     if V = Sink then
                        return True;
                     end if;
                  end if;
               end loop;
            end;
         end loop;
         
         return False;
      end BFS;
      
      Parent : Int_2D_Vectors.Vector;
   begin
      if G.Adjacency = null then
         return 0;
      end if;
      
      -- Initialize residual graph
      Residual.Set_Length(G.Max_Vertex * G.Max_Vertex);
      for V of G.Vertices loop
         if G.Adjacency(V).Length > 0 then
            for E of G.Adjacency(V) loop
               Residual.Replace_Element(V * G.Max_Vertex + E.To, E.Weight);
            end loop;
         end if;
      end loop;
      
      -- Find augmenting paths
      while BFS(Residual, Source, Sink, Parent) loop
         declare
            Path_Flow : Integer := Integer'Last;
            V : Vertex := Sink;
         begin
            -- Find minimum residual capacity
            while V /= Source loop
               declare
                  U : Vertex := Parent.Element(V);
               begin
                  if Residual.Element(U * G.Max_Vertex + V) < Path_Flow then
                     Path_Flow := Residual.Element(U * G.Max_Vertex + V);
                  end if;
                  V := U;
               end;
            end loop;
            
            -- Update residual capacities
            V := Sink;
            while V /= Source loop
               declare
                  U : Vertex := Parent.Element(V);
               begin
                  Residual.Replace_Element(U * G.Max_Vertex + V,
                    Residual.Element(U * G.Max_Vertex + V) - Path_Flow);
                  Residual.Replace_Element(V * G.Max_Vertex + U,
                    Residual.Element(V * G.Max_Vertex + U) + Path_Flow);
                  V := U;
               end;
            end loop;
            
            Max_Flow := Max_Flow + Path_Flow;
         end;
      end loop;
      
      return Max_Flow;
   end Ford_Fulkerson_Max_Flow;

   -- Implementation of Dinic's Maximum Flow Algorithm
   function Dinic_Max_Flow (G : Graph; Source, Sink : Vertex) return Integer is
   begin
      -- Simplified implementation - uses Ford-Fulkerson for now
      return Ford_Fulkerson_Max_Flow(G, Source, Sink);
   end Dinic_Max_Flow;

   -- Implementation of Hopcroft-Karp Bipartite Matching Algorithm
   function Hopcroft_Karp_Matching (G : Graph) return Integer is
   begin
      -- Placeholder implementation
      return 0;
   end Hopcroft_Karp_Matching;

   -- Implementation of Hungarian Algorithm for Bipartite Matching
   function Hungarian_Algorithm_Matching (G : Graph) return Integer is
   begin
      -- Placeholder implementation
      return 0;
   end Hungarian_Algorithm_Matching;

   -- Implementation of Gabow-Tarjan Edge Coloring Algorithm
   function Gabow_Tarjan_Edge_Coloring (G : Graph) return Integer is
   begin
      -- Placeholder implementation
      return 0;
   end Gabow_Tarjan_Edge_Coloring;

   -- Graph Operations
   procedure Add_Vertex (G : in out Graph; V : Vertex) is
   begin
      if not G.Vertices.Contains(V) then
         G.Vertices.Append(V);
         if V > G.Max_Vertex then
            G.Max_Vertex := V;
         end if;
         Initialize_Adjacency(G, G.Max_Vertex);
      end if;
   end Add_Vertex;

   procedure Add_Edge (G : in out Graph; E : Edge) is
   begin
      Add_Vertex(G, E.From);
      Add_Vertex(G, E.To);
      Initialize_Adjacency(G, G.Max_Vertex);
      G.Adjacency(E.From).Append((To => E.To, Weight => E.Weight));
      -- For undirected graph, add reverse edge
      G.Adjacency(E.To).Append((To => E.From, Weight => E.Weight));
   end Add_Edge;

   function Is_Empty (G : Graph) return Boolean is
   begin
      return G.Vertices.Length = 0;
   end Is_Empty;

end Grafalgo;
