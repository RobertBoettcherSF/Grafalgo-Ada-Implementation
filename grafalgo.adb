--  grafalgo.adb
--  Version: 0.09
--  Description: Implementation of Grafalgo library algorithms and data
--  structures in Ada.

package body Grafalgo is

   -- Implementation of Prim's Minimum Spanning Tree Algorithm
   function Prim_MST (G : Graph) return Integer is
      type In_MST_Array is array (Vertex range 0 .. Max_Vertices) of Boolean;
      type Key_Array is array (Vertex range 0 .. Max_Vertices) of Integer;
      
      In_MST : In_MST_Array := (others => False);
      Key : Key_Array := (others => Integer'Last);
      Parent : array (Vertex range 0 .. Max_Vertices) of Vertex;
      Total_Weight : Integer := 0;
      U, V : Vertex;
      Min_Key : Integer;
   begin
      if G.Vertex_Count = 0 then
         return 0;
      end if;
       
      -- Initialize
      Key(0) := 0;
      Parent(0) := 0;
       
      for Count in Vertex range 1 .. G.Vertex_Count loop
         -- Find vertex with minimum key not in MST
         Min_Key := Integer'Last;
         U := Vertex'First;
          
         for I in Vertex range 0 .. Max_Vertices loop
            if not In_MST(I) and then Key(I) < Min_Key then
               Min_Key := Key(I);
               U := I;
            end if;
         end loop;
          
         if Min_Key = Integer'Last then
            exit;
         end if;
          
         In_MST(U) := True;
         Total_Weight := Total_Weight + Min_Key;
          
         -- Update key values of adjacent vertices
         for V in Vertex range 0 .. Max_Vertices loop
            if G.Adjacency(U)(V) /= No_Edge and then not In_MST(V) and then
              G.Adjacency(U)(V) < Key(V) then
               Key(V) := G.Adjacency(U)(V);
               Parent(V) := U;
            end if;
         end loop;
      end loop;
       
      return Total_Weight;
   end Prim_MST;

   -- Implementation of Kruskal's Minimum Spanning Tree Algorithm
   function Kruskal_MST (G : Graph) return Integer is
      type Parent_Array is array (Vertex range 0 .. Max_Vertices) of Vertex;
      
      -- All edges
      type Edge_Array is array (Positive range <>) of Edge;
      All_Edges : Edge_Array(1 .. Max_Vertices * Max_Vertices);
      Edge_Count : Positive := 1;
      Total_Weight : Integer := 0;
      
      Parent_Arr : Parent_Array;
      
      function Find (V : Vertex) return Vertex is
      begin
         if Parent_Arr(V) /= V then
            Parent_Arr(V) := Find(Parent_Arr(V));
         end if;
         return Parent_Arr(V);
      end Find;
      
      procedure Union (U, V : Vertex) is
         Root_U : Vertex := Find(U);
         Root_V : Vertex := Find(V);
      begin
         if Root_U /= Root_V then
            Parent_Arr(Root_V) := Root_U;
         end if;
      end Union;
       
      -- Simple bubble sort
      procedure Sort_Edges is
         Temp : Edge;
      begin
         for I in 1 .. Edge_Count - 1 loop
            for J in 1 .. Edge_Count - I loop
               if All_Edges(J).Weight > All_Edges(J + 1).Weight then
                  Temp := All_Edges(J);
                  All_Edges(J) := All_Edges(J + 1);
                  All_Edges(J + 1) := Temp;
               end if;
            end loop;
         end loop;
      end Sort_Edges;
   begin
      if G.Vertex_Count = 0 then
         return 0;
      end if;
       
      -- Collect all edges
      for U in Vertex range 0 .. Max_Vertices loop
         for V in Vertex range U + 1 .. Max_Vertices loop
            if G.Adjacency(U)(V) /= No_Edge then
               Edge_Count := Edge_Count + 1;
               All_Edges(Edge_Count) := (From => U, To => V, 
                 Weight => G.Adjacency(U)(V));
            end if;
         end loop;
      end loop;
       
      -- Sort edges by weight
      Sort_Edges;
      
      -- Initialize Union-Find
      for V in Vertex range 0 .. Max_Vertices loop
         Parent_Arr(V) := V;
      end loop;
       
      -- Process edges in sorted order
      for I in Positive range 1 .. Edge_Count loop
         if Find(All_Edges(I).From) /= Find(All_Edges(I).To) then
            Union(All_Edges(I).From, All_Edges(I).To);
            Total_Weight := Total_Weight + All_Edges(I).Weight;
         end if;
      end loop;
       
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
      type Dist_Array is array (Vertex range 0 .. Max_Vertices) of Integer;
      type Visited_Array is array (Vertex range 0 .. Max_Vertices) of Boolean;
      
      Dist : Dist_Array := (others => Integer'Last);
      Visited : Visited_Array := (others => False);
      Min_Dist : Integer;
      Current : Vertex;
   begin
      if Source >= Max_Vertices or Target >= Max_Vertices then
         return Integer'Last;
      end if;
       
      Dist(Source) := 0;
       
      for Count in Vertex range 1 .. G.Vertex_Count loop
         -- Find vertex with minimum distance
         Min_Dist := Integer'Last;
         Current := Vertex'First;
          
         for V in Vertex range 0 .. Max_Vertices loop
            if not Visited(V) and then Dist(V) < Min_Dist then
               Min_Dist := Dist(V);
               Current := V;
            end if;
         end loop;
          
         if Min_Dist = Integer'Last then
            exit;
         end if;
          
         Visited(Current) := True;
          
         -- Update distances of adjacent vertices
         for V in Vertex range 0 .. Max_Vertices loop
            if G.Adjacency(Current)(V) /= No_Edge and then
              not Visited(V) and then
              Dist(Current) + G.Adjacency(Current)(V) < Dist(V) then
               Dist(V) := Dist(Current) + G.Adjacency(Current)(V);
            end if;
         end loop;
      end loop;
       
      return Dist(Target);
   end Dijkstra_Shortest_Path;

   -- Implementation of Bellman-Moore Shortest Path Algorithm
   function Bellman_Moore_Shortest_Path (G : Graph; Source, Target : Vertex)
     return Integer is
      type Dist_Array is array (Vertex range 0 .. Max_Vertices) of Integer;
      
      Dist : Dist_Array := (others => Integer'Last);
      Relaxed : Boolean;
   begin
      if Source >= Max_Vertices or Target >= Max_Vertices then
         return Integer'Last;
      end if;
       
      Dist(Source) := 0;
       
      -- Relax all edges V-1 times
      for Count in Vertex range 1 .. G.Vertex_Count - 1 loop
         Relaxed := False;
          
         for U in Vertex range 0 .. Max_Vertices loop
            for V in Vertex range 0 .. Max_Vertices loop
               if G.Adjacency(U)(V) /= No_Edge and then
                 Dist(U) /= Integer'Last and then
                 Dist(U) + G.Adjacency(U)(V) < Dist(V) then
                  Dist(V) := Dist(U) + G.Adjacency(U)(V);
                  Relaxed := True;
               end if;
            end loop;
         end loop;
          
         if not Relaxed then
            exit;
         end if;
      end loop;
       
      return Dist(Target);
   end Bellman_Moore_Shortest_Path;

   -- Implementation of Ford-Fulkerson Maximum Flow Algorithm
   function Ford_Fulkerson_Max_Flow (G : Graph; Source, Sink : Vertex) 
     return Integer is
      type Residual_Array is array (Vertex range 0 .. Max_Vertices,
        Vertex range 0 .. Max_Vertices) of Integer;
      type Parent_Array is array (Vertex range 0 .. Max_Vertices) of Vertex;
      
      Residual : Residual_Array := (others => (others => 0));
      Max_Flow : Integer := 0;
      
      -- BFS to find augmenting path
      function BFS (Parent : out Parent_Array) return Boolean is
         type Visited_Array is array (Vertex range 0 .. Max_Vertices) 
           of Boolean;
         
         Visited : Visited_Array := (others => False);
         type Queue_Array is array (Positive range 1 .. Max_Vertices * 2)
           of Vertex;
         Queue : Queue_Array;
         Queue_Head, Queue_Tail : Positive := 1;
      begin
         for V in Vertex range 0 .. Max_Vertices loop
            Visited(V) := False;
            Parent(V) := Vertex'First;
         end loop;
          
         Visited(Source) := True;
         Queue(Queue_Tail) := Source;
         Queue_Tail := Queue_Tail + 1;
          
         while Queue_Head < Queue_Tail loop
            declare
               U : Vertex := Queue(Queue_Head);
            begin
               Queue_Head := Queue_Head + 1;
                
               for V in Vertex range 0 .. Max_Vertices loop
                  if not Visited(V) and then Residual(U, V) > 0 then
                     Visited(V) := True;
                     Parent(V) := U;
                     Queue(Queue_Tail) := V;
                     Queue_Tail := Queue_Tail + 1;
                      
                     if V = Sink then
                        return True;
                     end if;
                  end if;
               end loop;
            end;
         end loop;
          
         return False;
      end BFS;
      
      Parent : Parent_Array;
      Path_Flow : Integer;
      V : Vertex;
   begin
      if Source >= Max_Vertices or Sink >= Max_Vertices then
         return 0;
      end if;
       
      -- Initialize residual graph
      for U in Vertex range 0 .. Max_Vertices loop
         for V in Vertex range 0 .. Max_Vertices loop
            Residual(U, V) := G.Adjacency(U)(V);
         end loop;
      end loop;
       
      -- Find augmenting paths
      while BFS(Parent) loop
         -- Find minimum residual capacity
         Path_Flow := Integer'Last;
         V := Sink;
         
         while V /= Source loop
            declare
               U : Vertex := Parent(V);
            begin
               if Residual(U, V) < Path_Flow then
                  Path_Flow := Residual(U, V);
               end if;
               V := U;
            end;
         end loop;
          
         -- Update residual capacities
         V := Sink;
         while V /= Source loop
            declare
               U : Vertex := Parent(V);
            begin
               Residual(U, V) := Residual(U, V) - Path_Flow;
               Residual(V, U) := Residual(V, U) + Path_Flow;
               V := U;
            end;
         end loop;
          
         Max_Flow := Max_Flow + Path_Flow;
      end loop;
       
      return Max_Flow;
   end Ford_Fulkerson_Max_Flow;

   -- Implementation of Dinic's Maximum Flow Algorithm
   function Dinic_Max_Flow (G : Graph; Source, Sink : Vertex) 
     return Integer is
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
      if V <= Max_Vertices and then V >= 0 then
         null;
      end if;
   end Add_Vertex;

   procedure Add_Edge (G : in out Graph; E : Edge) is
   begin
      if E.From <= Max_Vertices and E.To <= Max_Vertices then
         G.Adjacency(E.From)(E.To) := E.Weight;
         G.Adjacency(E.To)(E.From) := E.Weight;
         if E.From >= G.Vertex_Count then
            G.Vertex_Count := E.From + 1;
         end if;
         if E.To >= G.Vertex_Count then
            G.Vertex_Count := E.To + 1;
         end if;
      end if;
   end Add_Edge;

   function Is_Empty (G : Graph) return Boolean is
   begin
      return G.Vertex_Count = 0;
   end Is_Empty;

end Grafalgo;
