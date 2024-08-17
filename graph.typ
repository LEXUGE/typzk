#import "@preview/diagraph:0.2.5"

#let digraphState = state("state", (graph: (:), hierarchy: (), labels: (:), clusters: (:)))

#let deep-merge-pair(dict1, dict2) = {
    let final = dict1
    for (k, v) in dict2 {
        if (k in dict1) {
            if type(v) == "dictionary" {
                final.insert(k, deep-merge-pair(dict1.at(k), v))
            } else {
                final.insert(k, dict2.at(k))
            }
        } else {
            final.insert(k, v)
        }
    }
    final
}

#let deep-merge(..args) = {
    let final = args.pos().first()
    for dict in args.pos() {
        final = deep-merge-pair(final, dict)
    }
    final
}

#let node_descend(hierarchy, identity, payload) = {
  let graph = (:)
  if hierarchy.len() != 0 {
    let h = hierarchy.remove(0)
    graph.insert(h, node_descend(hierarchy, identity, payload))
  } else {
    graph.insert(identity, payload)
  }
  graph
}

// TODO: Allow setting extra options
#let node(identity, desc: none, links: (), back_links: (), body) = {
  let prefixed_identity = "node_" + identity
  let edges = ()
  for dst in links {
    edges.push(identity + "->" + dst)
  }
  for orig in back_links {
    edges.push(orig + "->" + identity)
  }
  digraphState.update(state => {
    state.graph = deep-merge(state.graph, node_descend(state.hierarchy, identity, edges))
    let linked_desc = if type(desc) == content {
      [#link(label(prefixed_identity), desc)]
    } else {
      [#link(label(prefixed_identity), identity)]
    }
    let new_label = (:)
    new_label.insert(identity, linked_desc)
    state.labels = deep-merge(state.labels, new_label)
    state
  })
  [#body #label(prefixed_identity)]
}

// TODO: Allow setting extra options
#let subgraph(identity, desc: none, body) = {
  let prefixed_identity = "cluster_" + identity
  digraphState.update(state => {
    state.hierarchy.push(prefixed_identity);
    if type(desc) == content {
      let new_desc = (:)
      new_desc.insert(prefixed_identity, [#link(label(prefixed_identity), desc)])
      state.clusters = deep-merge(state.clusters, new_desc)
    }
    state
  })
  // This seems to work: link to the first element of the body
  [#body #label(prefixed_identity)]
  digraphState.update(state => {
    // NOTE: Weird behavior, why would colon not discard the result?
    let _ = state.hierarchy.pop();
    state
  })
}

// Assemble our graph state into DOT language
// All statements must end with colon
#let marshal(graph) = {
  let s = ""
  let e = ()
  for (k, v) in graph {
    if type(v) == "dictionary" {
      let (nodes, edges) = marshal(v)
      // This label statement would be overriden when `clusters` has matching identity.
      // NOTE: This label statement is necessary as somehow otherwise the label replacement will not take effect.
      // In addition to that, replaced label will be pushed around, so the only workaround is to set all subgraph with empty label and replace using `clusters` later.
      let label_stmt = "label=\"\";"
      s += ("subgraph " + k + " {" + label_stmt + nodes + " };")
      e += edges
    } else if type(v) == "array"  {
      s += (k + ";")
      e += v
    }
  }
  (s, e)
}

// Generate the final graphviz code
#let gen_graphviz(graph, extra: "", path: ()) = {
  let scoped_graph = if path.len() == 0 {
    graph
  } else {
    let g = graph
    for name in path {
      g = g.at("cluster_" + name)
    }
    g
  }
  let (nodes, edges) = marshal(scoped_graph)
  let s = "digraph {" + extra
  s += nodes
  s += if edges.len()!=0 { edges.join(";") + ";" }
  s += "}"
  s
}

// Use path to indicate the subgraph to render
#let render_graph(extra: "", path: ()) = context {
  let state = digraphState.final()

  let s = gen_graphviz(state.graph, extra: extra, path: path)

  diagraph.render(s, labels: state.labels, clusters: state.clusters)
}
