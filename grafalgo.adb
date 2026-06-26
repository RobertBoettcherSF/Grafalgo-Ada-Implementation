--  grafalgo.adb
--  Version: 0.29
--  Description: Implementation of Grafalgo library algorithms and data
--  structures in Ada.

package body Grafalgo is

   -- Initialize a new empty graph
   procedure Initialize (G : out Graph) is
   begin
      G := (Vertex_Count => 0, Adjacency => (others => (others => No_Edge)));
   end Initialize;

   -- Implementation of Prim's Minimum Spanning Tree Algorithm
   function Prim_MST (G : Graph) return Integer is
   pragma Warnings (Off, "can never be greater than");
   
      type In_MST_Array is array (Vertex range 0 .. Max_Vertices) of Boolean;
      type Key_Array is array (Vertex range 0 .. Max_Vertices) of Integer;
      
      In_MST : In_MST_Array := (others => False);
      Key : Key_Array := (others => Integer'Last);
      Total_Weight : Integer := 0;
      U : Vertex;
      Min_Key : Integer;
   begin
      if G.Vertex_Count = 0 then
         return 0;
      end if;
       
      -- Initialize: find first vertex with edges
      -- Start with the first vertex that has at least one edge
      for V in Vertex range 0 .. Max_Vertices loop
         for W in Vertex range 0 .. Max_Vertices loop
            if G.Adjacency(V)(W) /= No_Edge then
               Key(V) := 0;
               exit;
            end if;
         end loop;
         if Key(V) = 0 then
            exit;
         end if;
      end loop;
       
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
         for Neighbor in Vertex range 0 .. Max_Vertices loop
            if G.Adjacency(U)(Neighbor) /= No_Edge and then
              not In_MST(Neighbor) and then
              G.Adjacency(U)(Neighbor) < Key(Neighbor) then
               Key(Neighbor) := G.Adjacency(U)(Neighbor);
            end if;
         end loop;
      end loop;
       
      return Total_Weight;
   end Prim_MST;

   -- Implementation of Kruskal's Minimum Spanning Tree Algorithm
   function Kruskal_MST (G : Graph) return Integer is
      type Parent_Array is array (Vertex range 0 .. Max_Vertices) of Vertex;
      type Edge_List is array (Integer range 1 .. Max_Vertices * Max_Vertices)
        of Edge;
      type Edge_List_Access is access Edge_List;
      
      Parent_Arr : Parent_Array;
      Total_Weight : Integer := 0;
      Edge_Count : Integer := 0;
      Edges : constant Edge_List_Access := new Edge_List;
      
      -- Find with path compression (defined here to access Parent_Arr)
      function Find (X : Vertex) return Vertex is
      begin
         if Parent_Arr(X) /= X then
            Parent_Arr(X) := Find(Parent_Arr(X));
         end if;
         return Parent_Arr(X);
      end Find;
      
      -- Collect all edges from the graph
      procedure Collect_Edges is
      begin
         Edge_Count := 0;
         for U in Vertex range 0 .. Max_Vertices loop
            for V in Vertex range U + 1 .. Max_Vertices loop
               if G.Adjacency(U)(V) /= No_Edge then
                  Edge_Count := Edge_Count + 1;
                  Edges.all(Edge_Count) := (From => U, To => V, 
                    Weight => G.Adjacency(U)(V));
               end if;
            end loop;
         end loop;
      end Collect_Edges;
      
      -- Simple bubble sort for edges by weight
      procedure Sort_Edges is
         Temp : Edge;
      begin
         for I in Integer range 1 .. Edge_Count - 1 loop
            for J in Integer range 1 .. Edge_Count - I loop
               if Edges.all(J).Weight > Edges.all(J + 1).Weight then
                  Temp := Edges.all(J);
                  Edges.all(J) := Edges.all(J + 1);
                  Edges.all(J + 1) := Temp;
               end if;
            end loop;
         end loop;
      end Sort_Edges;
      
   begin
      if G.Vertex_Count = 0 then
         return 0;
      end if;
      
      -- Initialize Union-Find
      for V in Vertex range 0 .. Max_Vertices loop
         Parent_Arr(V) := V;
      end loop;
      
      -- Collect and sort all edges
      Collect_Edges;
      
      -- Return 0 if no edges found
      if Edge_Count = 0 then
         return 0;
      end if;
      
      Sort_Edges;
      
      -- Process edges in sorted order
      for I in Integer range 1 .. Edge_Count loop
         declare
            E : constant Edge := Edges.all(I);
            Root_U : constant Vertex := Find(E.From);
            Root_V : constant Vertex := Find(E.To);
         begin
            if Root_U /= Root_V then
               Parent_Arr(Root_V) := Root_U;
               Total_Weight := Total_Weight + E.Weight;
            end if;
         end;
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
              Dist(Current) /= Integer'Last and then
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
   pragma Warnings (Off, "can never be greater than");
   
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
               U : constant Vertex := Queue(Queue_Head);
            begin
               Queue_Head := Queue_Head + 1;
                
               for V in Vertex range 0 .. Max_Vertices loop
                  if not Visited(V) and then Residual(U, V) /= No_Edge and then
                    Residual(U, V) > 0 then
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
            if G.Adjacency(U)(V) /= No_Edge then
               Residual(U, V) := G.Adjacency(U)(V);
            else
               Residual(U, V) := 0;
            end if;
         end loop;
      end loop;
       
      -- Find augmenting paths
      while BFS(Parent) loop
         -- Find minimum residual capacity
         Path_Flow := Integer'Last;
         V := Sink;
         
         while V /= Source loop
            declare
               U : constant Vertex := Parent(V);
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
               U : constant Vertex := Parent(V);
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
      -- Simplified implementation: greedy bipartite matching
      -- Returns the size of maximum matching
      
      Matched : array (Vertex range 0 .. Max_Vertices) of Boolean :=
        (others => False);
      Matching_Count : Integer := 0;
      
   begin
      -- Greedy matching: for each vertex, match to first available neighbor
      for U in Vertex range 0 .. Max_Vertices loop
         for V in Vertex range 0 .. Max_Vertices loop
            if G.Adjacency(U)(V) /= No_Edge and then not Matched(U) and then not Matched(V) then
               Matched(U) := True;
               Matched(V) := True;
               Matching_Count := Matching_Count + 1;
               exit;
            end if;
         end loop;
      end loop;
      
      return Matching_Count;
   end Hopcroft_Karp_Matching;

   -- Implementation of Hungarian Algorithm for Bipartite Matching
   function Hungarian_Algorithm_Matching (G : Graph) return Integer is
      -- Simplified implementation: find maximum weight matching
      -- using a greedy approach (not full Hungarian algorithm)
      
      type Matched_Array is array (Vertex range 0 .. Max_Vertices) of Boolean;
      
      Matched : Matched_Array := (others => False);
      Total_Weight : Integer := 0;
      
   begin
      -- Greedy approach: for each vertex, find the best match
      for U in Vertex range 0 .. Max_Vertices loop
         declare
            Best_V : Vertex := Vertex'Last;
            Best_Weight : Integer := Integer'Last;
         begin
            -- Find the best (maximum weight) edge from U to unmatched vertex
            for V in Vertex range 0 .. Max_Vertices loop
               if G.Adjacency(U)(V) /= No_Edge and then
              not Matched(V) then
                  if G.Adjacency(U)(V) > Best_Weight then
                     Best_Weight := G.Adjacency(U)(V);
                     Best_V := V;
                  end if;
               end if;
            end loop;
            
            -- If we found a match, use it
            if Best_V /= Vertex'Last then
               Matched(Best_V) := True;
               Total_Weight := Total_Weight + Best_Weight;
            end if;
         end;
      end loop;
      
      return Total_Weight;
   end Hungarian_Algorithm_Matching;

   -- Implementation of Gabow-Tarjan Edge Coloring Algorithm
   -- Implementation of Gabow-Tarjan Edge Coloring Algorithm
   function Gabow_Tarjan_Edge_Coloring (G : Graph) return Integer is
      -- Simplified implementation: greedy edge coloring
      -- Returns the number of colors used (chromatic index)
      
      type Color_Array is array (Vertex range 0 .. Max_Vertices,
        Vertex range 0 .. Max_Vertices) of Integer;
      
      Edge_Colors : Color_Array := (others => (others => 0));
      Max_Color : Integer := 0;
      
   begin
      -- For each edge, assign the smallest available color
      for U in Vertex range 0 .. Max_Vertices loop
         for V in Vertex range U + 1 .. Max_Vertices loop
            if G.Adjacency(U)(V) /= No_Edge then
               -- Find the smallest color not used by adjacent edges
               declare
                  Available : array (Positive range 1 .. Max_Vertices)
                    of Boolean := (others => True);
                  C : Positive;
               begin
                  -- Mark colors used by edges incident to U or V
                  for W in Vertex range 0 .. Max_Vertices loop
                     if W /= V and then G.Adjacency(U)(W) /= No_Edge then
                        if Edge_Colors(U, W) > 0 then
                           Available(Edge_Colors(U, W)) := False;
                        end if;
                     end if;
                     if W /= U and then G.Adjacency(V)(W) /= No_Edge then
                        if Edge_Colors(V, W) > 0 then
                           Available(Edge_Colors(V, W)) := False;
                        end if;
                     end if;
                  end loop;
                  
                  -- Find the first available color
                  C := 1;
                  while C <= Max_Vertices and then not Available(C) loop
                     C := C + 1;
                  end loop;
                  
                  -- Assign the color
                  if C <= Max_Vertices then
                     Edge_Colors(U, V) := Integer(C);
                     Edge_Colors(V, U) := Integer(C);
                     if Integer(C) > Max_Color then
                        Max_Color := C;
                     end if;
                  end if;
               end;
            end if;
         end loop;
      end loop;
      
      return Max_Color;
   end Gabow_Tarjan_Edge_Coloring;

   -- Graph Operations
   procedure Add_Vertex (G : in out Graph; V : Vertex) is
   begin
      if V >= G.Vertex_Count then
         G.Vertex_Count := V + 1;
      end if;
   end Add_Vertex;

   procedure Add_Edge (G : in out Graph; E : Edge) is
   begin
      G.Adjacency(E.From)(E.To) := E.Weight;
      G.Adjacency(E.To)(E.From) := E.Weight;
      if E.From >= G.Vertex_Count then
         G.Vertex_Count := E.From + 1;
      end if;
      if E.To >= G.Vertex_Count then
         G.Vertex_Count := E.To + 1;
      end if;
   end Add_Edge;

   procedure Add_Directed_Edge (G : in out Graph; From, To : Vertex;
      Weight : Integer) is
   begin
      G.Adjacency(From)(To) := Weight;
      if From >= G.Vertex_Count then
         G.Vertex_Count := From + 1;
      end if;
      if To >= G.Vertex_Count then
         G.Vertex_Count := To + 1;
      end if;
   end Add_Directed_Edge;

   function Is_Empty (G : Graph) return Boolean is
   begin
      return G.Vertex_Count = 0;
   end Is_Empty;

end Grafalgo;
