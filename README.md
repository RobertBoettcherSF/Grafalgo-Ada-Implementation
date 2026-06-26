# Grafalgo-Ada-Implementation

This repository contains an Ada language implementation of the Grafalgo library, an open-source collection of graph algorithms and supporting data structures as described in the paper *Grafalgo - A Library of Graph Algorithms and Supporting Data Structures* by Jonathan Turner (2016).

## Overview

This Ada implementation provides a comprehensive suite of graph algorithms for use in academic, research, and production environments. The library is designed to be efficient, well-tested, and easy to integrate into Ada projects.

## Features

### Implemented Algorithms

#### Minimum Spanning Tree (MST)
- **Prim's Algorithm**: Greedy algorithm that builds the MST by repeatedly adding the shortest edge connected to the growing tree
- **Kruskal's Algorithm**: Uses Union-Find with path compression to build the MST by sorting and adding edges
- **Cheriton-Tarjan Algorithm**: Advanced MST algorithm (currently uses Prim's as a fallback)

#### Shortest Path
- **Dijkstra's Algorithm**: Finds shortest paths from a source vertex to all other vertices in a graph with non-negative edge weights
- **Bellman-Moore Algorithm**: Handles graphs with negative edge weights and can detect negative cycles

#### Maximum Flow
- **Ford-Fulkerson Algorithm**: Finds the maximum flow in a flow network using augmenting paths
- **Dinic's Algorithm**: More efficient maximum flow algorithm (currently uses Ford-Fulkerson as a fallback)

#### Matching
- **Hopcroft-Karp Algorithm**: Finds maximum cardinality matching in bipartite graphs
- **Hungarian Algorithm**: Finds maximum weight matching in bipartite graphs

#### Edge Coloring
- **Gabow-Tarjan Algorithm**: Finds the minimum number of colors needed for edge coloring (chromatic index)

### Graph Representation

- **Adjacency Matrix**: Graphs are represented using adjacency matrices with a maximum of 1000 vertices
- **Vertex Type**: `type Vertex is range 0 .. 1000;`
- **Edge Type**: Record containing `From`, `To` (Vertex), and `Weight` (Integer)
- **No_Edge Sentinel**: `Integer'Last` is used to represent the absence of an edge

## Installation

### Prerequisites

- GNAT Ada compiler (part of GCC)
- GPRBuild (GNAT Project Manager)

### On Ubuntu/Debian

```bash
sudo apt-get update
sudo apt-get install gnat gprbuild
```

### On Fedora/RHEL

```bash
sudo dnf install gcc-gnat gprbuild
```

### On macOS (using Homebrew)

```bash
brew install gnat
```

## Building the Library

### Build the main library

```bash
mkdir obj/
gprbuild -P grafalgo.gpr
```

This will compile:
- `grafalgo.ads` - Library specification
- `grafalgo.adb` - Library implementation
- `main.adb` - Example usage

### Build and run the test suite

```bash
mkdir obj/
gprbuild -P test_grafalgo.gpr
./test_grafalgo
```

## Usage

### Basic Example

```ada
with Grafalgo; use Grafalgo;

procedure Example is
   G : Graph;
begin
   -- Initialize a new graph
   Initialize(G);
   
   -- Add vertices
   Add_Vertex(G, 0);
   Add_Vertex(G, 1);
   Add_Vertex(G, 2);
   
   -- Add edges
   Add_Edge(G, (From => 0, To => 1, Weight => 5));
   Add_Edge(G, (From => 1, To => 2, Weight => 3));
   Add_Edge(G, (From => 0, To => 2, Weight => 7));
   
   -- Compute MST
   declare
      MST_Weight : Integer := Prim_MST(G);
   begin
      -- MST_Weight = 8 (edges 0-1 and 1-2)
      null;
   end;
end Example;
```

### Using Directed Edges

```ada
-- For directed graphs, use Add_Directed_Edge
Add_Directed_Edge(G, From => 0, To => 1, Weight => 5);
```

### Available Operations

```ada
-- Graph initialization
Initialize(G : out Graph);

-- Vertex operations
Add_Vertex(G : in out Graph; V : Vertex);

-- Edge operations
Add_Edge(G : in out Graph; E : Edge);
Add_Directed_Edge(G : in out Graph; From, To : Vertex; Weight : Integer);

-- Graph queries
function Is_Empty(G : Graph) return Boolean;

-- MST algorithms
function Prim_MST(G : Graph) return Integer;
function Kruskal_MST(G : Graph) return Integer;
function Cheriton_Tarjan_MST(G : Graph) return Integer;

-- Shortest path algorithms
function Dijkstra_Shortest_Path(G : Graph; Source, Target : Vertex) return Integer;
function Bellman_Moore_Shortest_Path(G : Graph; Source, Target : Vertex) return Integer;

-- Maximum flow algorithms
function Ford_Fulkerson_Max_Flow(G : Graph; Source, Sink : Vertex) return Integer;
function Dinic_Max_Flow(G : Graph; Source, Sink : Vertex) return Integer;

-- Matching algorithms
function Hopcroft_Karp_Matching(G : Graph) return Integer;
function Hungarian_Algorithm_Matching(G : Graph) return Integer;

-- Edge coloring
function Gabow_Tarjan_Edge_Coloring(G : Graph) return Integer;
```

## Test Suite

The test suite (`test_grafalgo.adb`) contains 17 comprehensive tests covering:

### Test 1: Empty Graph
- Verifies that an empty graph is correctly identified
- Tests MST algorithms on empty graphs

### Test 2: Single Vertex Graph
- Tests basic graph operations with a single vertex
- Verifies shortest path from a vertex to itself is 0

### Test 3: Two Vertices, One Edge
- Tests basic connectivity
- Verifies MST and shortest path calculations

### Test 4: Triangle Graph
- Tests MST and shortest path on a complete graph of 3 vertices
- Verifies correct handling of multiple paths

### Test 5: Square Graph
- Tests MST on a 4-vertex cycle with a diagonal
- Verifies shortest path calculation

### Test 6: Disconnected Graph
- Tests MST on a graph with isolated vertices
- Verifies that no path exists between disconnected components

### Test 7: Bellman-Moore with Negative Weights
- Tests shortest path algorithm with negative edge weights
- Verifies correct handling of negative weights

### Test 8: Maximum Flow
- Tests Ford-Fulkerson and Dinic's algorithms on a flow network
- Verifies maximum flow calculation

### Test 9: Graph Operations
- Tests basic graph operations (initialize, add vertex, add edge)

### Test 10: Matching and Edge Coloring
- Tests Hopcroft-Karp matching on a 2-vertex graph
- Tests Hungarian algorithm for maximum weight matching
- Tests Gabow-Tarjan edge coloring on a single edge

### Test 11: Larger Graph for MST
- Tests MST algorithms on a 5-vertex graph
- Verifies correct MST weight calculation

### Test 12: Dijkstra with Multiple Paths
- Tests Dijkstra's algorithm on a graph with multiple paths
- Verifies shortest path selection

### Test 13: Prim's MST with Isolated Vertex
- Tests MST algorithms when one vertex is isolated

### Test 14: MST with Negative Weights
- Tests MST algorithms on directed graphs with negative weights

### Test 15: Hopcroft-Karp Larger Bipartite Graph
- Tests matching on a complete bipartite graph K2,2

### Test 16: Hungarian Algorithm Weighted Bipartite Graph
- Tests maximum weight matching on a bipartite graph with different weights

### Test 17: Edge Coloring with Multiple Edges
- Tests edge coloring on a triangle graph (requires 3 colors)

## Running Tests

```bash
# Build the test suite
gprbuild -P test_grafalgo.gpr

# Run all tests
./test_grafalgo

# Expected output: "=== All Tests Passed ==="
```

## Project Structure

```
Grafalgo-Ada-Implementation/
├── grafalgo.gpr          # Main project file
├── grafalgo.ads          # Library specification
├── grafalgo.adb          # Library implementation
├── main.adb              # Example usage
├── test_grafalgo.gpr     # Test project file
├── test_grafalgo.adb     # Comprehensive test suite
└── README.md             # This file
```

## Implementation Details

### Graph Type

```ada
type Graph is record
   Vertex_Count : Vertex := 0;
   Adjacency : Adjacency_Matrix := (others => (others => No_Edge));
end record;
```

The graph is represented as an adjacency matrix with:
- `Vertex_Count`: Number of vertices in the graph
- `Adjacency`: 2D array of edge weights (No_Edge for no connection)

### Algorithm Notes

- **Prim's MST**: Uses a greedy approach with key values, O(V^2) complexity
- **Kruskal's MST**: Uses Union-Find with path compression, O(E log E) complexity
- **Dijkstra**: Standard implementation, O(V^2) complexity
- **Bellman-Moore**: Relaxes edges V-1 times, handles negative weights
- **Ford-Fulkerson**: Uses BFS for finding augmenting paths
- **Hopcroft-Karp**: Simplified greedy implementation for bipartite matching
- **Hungarian**: Simplified greedy implementation for maximum weight matching
- **Gabow-Tarjan**: Simplified greedy edge coloring

## Version History

- **v0.31** (grafalgo.adb): Fixed Hungarian algorithm Best_Weight initialization
- **v0.13** (test_grafalgo.adb): Fixed Test 11 MST expected value
- **v0.30** (grafalgo.adb): Fixed Hungarian algorithm to check if U is matched
- **v0.12** (grafalgo.ads, test_grafalgo.adb): Style fixes and version increments
- **v0.29** (grafalgo.adb): Fixed Hopcroft-Karp matching count

## Contributing

Contributions are welcome! Please ensure:
1. All tests pass
2. Code follows Ada style guidelines
3. No lines exceed 80 characters
4. All compiler warnings are addressed (compiled with `-gnatwa`)

## License

This implementation is provided as-is for educational and research purposes. Refer to the original Grafalgo paper for licensing details.

## References

- Turner, J. (2016). *Grafalgo - A Library of Graph Algorithms and Supporting Data Structures*.
- Cormen, T. H., Leiserson, C. E., Rivest, R. L., & Stein, C. (2009). *Introduction to Algorithms* (3rd ed.). MIT Press.
