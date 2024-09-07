#import "@typzk/zkgraph:0.1.0": *
#import "@preview/physica:0.9.2": *
#import "@preview/ctheorems:1.1.2": *

#let ii = sym.dotless.i
#let to = sym.arrow.r
#let vb(body) = $bold(upright(body))$
#let cdot = sym.dot.c
#let inv(body) = $body^(-1)$
#let conj(body) = $overline(body)$

#let mkThmNode(fn) = return (identity, desc, body, ..args) => node(identity, desc: desc, prefix: "", ..args, [#fn(desc, body)])

#let def = mkThmNode(thmbox("definition", "Definition", stroke: purple + 1pt))
#let thm = mkThmNode(thmbox("theorem", "Theorem", fill: color.lighten(orange, 70%)))
#let postl = mkThmNode(thmbox("postulate", "Postulate", stroke: red + 1pt))

#show: set math.equation(numbering: "(1.1)")
#set heading(numbering: "1.1.")
#show heading: args => [#heading_subgraph(args) #counter(heading).display(args.numbering) #args.body #label(heading_to_label()) \ ]
#show: thmrules

= Simple Examples

#figure(render_graph(), caption: [Example Graph]) <complete>

@complete is rendered by
```typst
#figure(
  render_graph(),
  caption: [Example Graph]
)
```

#pagebreak()

= Quantum Mechanics
== Postulates
#postl(
  "hilbert_space",
)[Hilbert Space][The states of quantum mechanical objects live in a Hilbert Space. The dimension
  of the Hilbert Space is determined by the complete set of commutative operators.\ ]

#postl(
  "observable", links: ("sch_eqn",),
)[Observables are Hermitian][Observables are represented by Hermitian operators with real eigenvalues.\ ]
#postl(
  "measurement",
)[Measurement][
  Measurements are represented by projecting (and renormalizing) state vectors
  onto the corresponding eigenspaces.
]
== Dynamics
#def(
  "sch_eqn", back_links: ("hilbert_space",),
)[Schrödinger equation][
  Let $ket(phi(t)): RR to cal(H)$ describes the trajectory of some system with
  Hamiltonian $op(H)$, then
  $ ii hbar pdv(ket(phi(t)), t) = op(H) ket(phi(t)) $
]
#def("prob_current", back_links: ("sch_eqn",))[Probability Current][
  $ vb(J) = hbar / m rho grad theta $
]

The thmbox can also be easily referenced just as normal: @prob_current,
@hilbert_space by using labels: ```typst @prob_current, @hilbert_space```.

#pagebreak()

#context state.final()

= Graph Generation Code
The above graph is realized by
```typst
#let mkThmNode(fn) = return (identity, desc, body, ..args) => node(identity, desc: desc, ..args, [#fn(desc, body)])

#let def = mkThmNode(thmbox("definition", "Definition", stroke: purple + 1pt))
#let postl = mkThmNode(thmbox("postulate", "Postulate", stroke: red + 1pt))
#show heading: args => [#heading_subgraph(args) #counter(heading).display(args.numbering) #args.body #label(heading_to_label()) \ ]

= Quantum Mechanics
== Postulates
#postl(
  "hilbert_space",
)[Hilbert Space][The states of quantum mechanical objects live in a Hilbert Space. The dimension
  of the Hilbert Space is determined by the complete set of commutative operators.\ ]

#postl(
  "observable", links: ("sch_eqn",),
)[Observables are Hermitian][Observables are represented by Hermitian operators with real eigenvalues.\ ]
#postl(
  "measurement",
)[Measurement][
  Measurements are represented by projecting (and renormalizing) state vectors
  onto the corresponding eigenspaces.
]
== Dynamics
#def(
  "sch_eqn", back_links: ("hilbert_space",),
)[Schrödinger equation][
  Let $ket(phi(t)): RR to cal(H)$ describes the trajectory of some system with
  Hamiltonian $op(H)$, then
  $ ii hbar pdv(ket(phi(t)), t) = op(H) ket(phi(t)) $
]
#def("prob_current", back_links: ("sch_eqn",))[Probability Current][
  $ vb(J) = hbar / m rho grad theta $
]
```
