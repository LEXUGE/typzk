#import "@typzk/zkgraph:0.1.0": *
#import "@preview/physica:0.9.2": *

#let ii = sym.dotless.i
#let to = sym.arrow.r
#let vb(body) = $bold(upright(body))$
#let cdot = sym.dot.c
#let inv(body) = $body^(-1)$
#let conj(body) = $overline(body)$

#show: set math.equation(numbering: "(1.1)")

= Simple Examples

#figure(render_graph(), caption: [Example Graph]) <complete>

@complete is rendered by
```typst
#figure(
  render_graph(),
  caption: [Example Graph]
)
```

We can also create graph using a certain subgraph:
#figure(render_graph(path: ("qm", "dynamics")), caption: [Example Subgraph]) <subgraph>

@subgraph is rendered by
```typst
#figure(
  // `path`: subgraph identities
  render_graph(path: ("qm", "dynamics")),
  caption: [Example Subgraph]
)
```

#pagebreak()

#subgraph(
  "qm", desc: [Quantum Mechanics],
)[
  = Quantum Mechanics
  #subgraph(
    "postulates", desc: [Postulates],
  )[
    == Postulates
    #node(
      "hilbert_space", desc: [Hilbert Space],
    )[The states of quantum mechanical objects live in a Hilbert Space. The dimension
      of the Hilbert Space is determined by the complete set of commutative operators.\ ]
    #node(
      "observable", desc: [Observables\ are Hermitian], links: ("sch_eqn",),
    )[Observables are represented by Hermitian operators with real eigenvalues.\ ]
    #node(
      "measurement", desc: [Measurement],
    )[Measurements are represented by projecting (and renormalizing) state vectors
      onto the corresponding eigenspaces.\ ]
  ]
  #subgraph(
    "dynamics", desc: [Basic Dynamics],
  )[
    == Dynamics
    #node(
      "sch_eqn", back_links: ("hilbert_space",), desc: [Schrödinger equation],
    )[
      *Schrodinger equation:* Let $ket(phi(t)): RR to cal(H)$ describes the trajectory
      of some system with Hamiltonian $op(H)$, then
      $ ii hbar pdv(ket(phi(t)), t) = op(H) ket(phi(t)) $
    ]
    #node("prob_current", back_links: ("sch_eqn",), desc: [Probability Current])[
      *Probability Current*:
      $ vb(J) = hbar / m rho grad theta $
    ]
  ]
]

#pagebreak()

= Graph Generation Code
```typst
// Usage: subgraph(identity: string, desc: content)[body]
// `identity` must be a valid graphviz term
#subgraph("qm", desc: [Quantum Mechanics])[
// Arbitrary content is allowed here
= Quantum Mechanics
  // Subgraph can be nested
  #subgraph("postulates", desc: [Postulates])[
    == Postulates
    #node("hilbert_space", desc: [Hilbert Space])[The states of quantum mechanical objects live in a Hilbert Space. The dimension of the Hilbert Space is determined by the complete set of commutative operators.\ ]
    // Links to other nodes are supported
    #node("observable", desc: [Observables\ are Hermitian], links: ("sch_eqn",))[Observables are represented by Hermitian operators with real eigenvalues.\ ]
    #node("measurement", desc: [Measurement])[Measurements are represented by projecting (and renormalizing) state vectors onto the corresponding eigenspaces.\ ]
  ]
  #subgraph("dynamics", desc: [Basic Dynamics])[
    == Dynamics
    // Backlinks are also supported
    #node("sch_eqn", back_links:("hilbert_space", ), desc: [Schrödinger equation])[
      *Schrodinger equation:* Let $ket(phi(t)): RR to cal(H)$ describes the trajectory of some system with
      Hamiltonian $op(H)$, then
      $ ii hbar pdv(ket(phi(t)), t) = op(H) ket(phi(t)) $
    ]
    #node("prob_current", back_links: ("sch_eqn",), desc: [Probability Current])[
      *Probability Current*:
      $ vb(J) = hbar / m rho grad theta $
    ]
  ]
]
```

= Metadata Introspection
To explore the graphviz code generated and internal state, insert metadata with
```typst
#context [
  #metadata(gen_graphviz(digraphState.final().graph)) <graphviz_code>
  #metadata(digraphState.final()) <internal_state>
]
```
and run
```bash
$ typst query manual.typ "<graphviz_code>"
[
  {
    "func": "metadata",
    "value": "digraph {subgraph cluster_qm {label=\"\";subgraph cluster_postulates {label=\"\";hilbert_space;observable;measurement; };subgraph cluster_dynamics {label=\"\";sch_eqn;prob_current; }; };observable->sch_eqn;hilbert_space->sch_eqn;sch_eqn->prob_current;}",
    "label": "<graphviz_code>"
  }
]
```

and similarly for internal state
```typst
  {
    "graph": {
      "cluster_qm": {
        "cluster_postulates": {
          "hilbert_space": [],
          "observable": [
            "observable->sch_eqn"
          ],
          "measurement": []
        },
        "cluster_dynamics": {
          "sch_eqn": [
            "hilbert_space->sch_eqn"
          ],
          "prob_current": [
            "sch_eqn->prob_current"
          ]
        }
      }
    },
    "hierarchy": [],
    "labels": {
      "hilbert_space": {
        "func": "link",
        "dest": "<node_hilbert_space>",
        "body": {
          "func": "text",
          "text": "Hilbert Space"
        }
      },
      "observable": {
        "func": "link",
        "dest": "<node_observable>",
        "body": {
          "func": "sequence",
          "children": [
            {
              "func": "text",
              "text": "Observables"
            },
            {
              "func": "linebreak"
            },
            {
              "func": "space"
            },
            {
              "func": "text",
              "text": "are Hermitian"
            }
          ]
        }
      },
      "measurement": {
        "func": "link",
        "dest": "<node_measurement>",
        "body": {
          "func": "text",
          "text": "Measurement"
        }
      },
      "sch_eqn": {
        "func": "link",
        "dest": "<node_sch_eqn>",
        "body": {
          "func": "text",
          "text": "Schrödinger equation"
        }
      },
      "prob_current": {
        "func": "link",
        "dest": "<node_prob_current>",
        "body": {
          "func": "text",
          "text": "Probability Current"
        }
      }
    },
    "clusters": {
      "cluster_qm": {
        "func": "link",
        "dest": "<cluster_qm>",
        "body": {
          "func": "text",
          "text": "Quantum Mechanics"
        }
      },
      "cluster_postulates": {
        "func": "link",
        "dest": "<cluster_postulates>",
        "body": {
          "func": "text",
          "text": "Postulates"
        }
      },
      "cluster_dynamics": {
        "func": "link",
        "dest": "<cluster_dynamics>",
        "body": {
          "func": "text",
          "text": "Basic Dynamics"
        }
      }
    }
  }
```

#context [
  #metadata(gen_graphviz(digraphState.final().graph)) <graphviz_code>
  #metadata(digraphState.final()) <internal_state>
]
