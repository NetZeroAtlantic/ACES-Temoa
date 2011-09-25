__all__ = ('CreateModelDiagram',)

import os

from subprocess import call
from sys import stderr as SE


def _getLen ( key ):
	def wrapped ( obj ):
		return len(obj[ key ])
	return wrapped


def create_text_nodes ( nodes, indent=1 ):
	"""\
Return a set of text nodes in Graphviz DOT format, optimally padded for easier
reading and debugging.

nodes: iterable of (id, attribute) node tuples
       e.g. [(node1, attr1), (node2, attr2), ...]

indent: integer, number of tabs with which to indent all Dot node lines
"""
	if not nodes: return '// no nodes in this section'

	# guarantee basic structure of nodes arg
	assert( len(nodes) == sum( 1 for a, b in nodes ) )

	# Step 1: for alignment, get max item length in node list
	maxl = max(map(_getLen(0), nodes)) + 2 # account for two extra quotes

	# Step 2: prepare a text format based on max node size that pads all
	#         lines with attributes
	nfmt_attr = '{0:<%d} [ {1} ] ;' % maxl      # node text format
	nfmt_noa  = '{0} ;'

	# Step 3: create each node, and place string representation in a set to
	#         guarantee uniqueness
	q = '"%s"' # enforce quoting for all nodes
	gviz = set( nfmt_attr.format( q % n, a ) for n, a in nodes if a )
	gviz.update( nfmt_noa.format( q % n ) for n, a in nodes if not a )

	# Step 4: return a sorted version of nodes, as a single string
	indent = '\n' + '\t' *indent
	return indent.join(sorted( gviz ))


def create_text_edges ( edges, indent=1 ):
	"""\
Return a set of text edge definitions in Graphviz DOT format, optimally padded
for easier reading and debugging.

edges: iterable of (from, to, attribute) edge tuples
       e.g. [(inp1, tech1, attr1), (inp2, tech2, attr2), ...]

indent: integer, number of tabs with which to indent all Dot edge lines
"""
	if not edges: return '// no edges in this section'

	# guarantee basic structure of edges arg
	assert( len(edges) == sum( 1 for a, b, c in edges ) )

	# Step 1: for alignment, get max length of items on left and right side of
	# graph operator token ('->')
	maxl, maxr = max(map(_getLen(0), edges)), max(map(_getLen(1), edges))
	maxl += 2  # account for additional two quotes
	maxr += 2  # account for additional two quotes

	# Step 2: prepare format to be "\n\tinp+PADDING -> out+PADDING [..."
	efmt_attr = '{0:<%d} -> {1:<%d} [ {2} ] ;' % (maxl, maxr) # with attributes
	efmt_noa  = '{0:<%d} -> {1} ;' % maxl                     # no attributes

	# Step 3: add each edge to a set (to guarantee unique entries only)
	q = '"%s"' # enforce quoting for all tokens
	gviz = set( efmt_attr.format( q % i, q % t, a ) for i, t, a in edges if a )
	gviz.update( efmt_noa.format( q % i, q % t ) for i, t, a in edges if not a )

	# Step 4: return a sorted version of the edges, as a single string
	indent = '\n' + '\t' *indent
	return indent.join(sorted( gviz ))


def CreateModelDiagram ( pyomo_instance, fileformat ):
	"""\
These first couple versions of CreateModelDiagram do not fully work, and should
be thought of merely as "proof of concept" code.  They create Graphviz DOT files
and equivalent PDFs, but the graphics are not "correct" representations of the
model.  Specifically, there are currently a few artifacts and missing pieces:

Artifacts:
 * Though the graph is "roughly" a left-right DAG, certain pieces currently a
   swapped around, especially on the left-hand side of the image.  This makes
   the graph a bit harder to visually follow.
 * Especially with the birth of energy, there are a few cycles.  For example,
   with the way the model currently creates energy, the graph makes it seem as
   if 'imp_coal' also receives coal, when it should only export coal.

Initially known missing pieces:
 * How should the graph represent the notion of periods?
 * How should the graph represent the vintages?
 * Should the graph include time slices? (e.g. day, season)

Notes:
* For _any_ decently sized system, displaying this type of graph of the entire
  model will be infeasible, or effectively unusable.  We need a way to
  dynamically look at only subsections of the graph, while still giving a 10k'
  foot view of the overall system.

* We need to create a system that puts results into a database, or common result
  format, such that we can archive them for later.  In this manner, directly
  creating graphs at the point of model instantiation and running is not the
  right place.  Creating graphs needs to be a post processing action, and less
  tightly coupled (not coupled at all!) to the internal Pyomo data structure.
"""

	from temoa_lib import g_activeActivityIndices, ProcessInputs, ProcessOutputs

	data = """\
// This file is generated by the --graph_format option of the Temoa model.  It
// is a Graphviz DOT language text description of a Temoa model instance.  For
// the curious, Graphviz will read this file to create an equivalent image in
// a number of formats, including SVG, PNG, GIF, and PDF.  For example, here
// is how one might invoke Graphviz to create an SVG image from the dot file.
//
// dot -Tsvg -o model.svg model.dot
//
// For more information, see the Graphviz homepage: http://graphviz.org/

strict digraph TemoaModel {
	rankdir = "LR";       // The direction of the graph goes from Left to Right

	node [ style="filled" ] ;
	edge [ arrowhead="vee", label="   " ] ;


	subgraph technologies {
		node [ color="%(tech_color)s", shape="box" ] ;

		%(techs)s
	}

	subgraph energy_carriers {
		node [ color="%(carrier_color)s", shape="circle" ] ;

		%(carriers)s
	}

	subgraph inputs {
		edge [ color="%(input_color)s" ] ;

		%(inputs)s
	}

	subgraph outputs {
		edge [ color="%(output_color)s" ];

		%(outputs)s
	}
}
"""
	M = pyomo_instance     # short for 'the generic model'

	carriers, techs = set(), set()
	inputs, outputs = set(), set()

	p_fmt = '%s, %s, %s'   # "Process format"

	for l_per, l_tech, l_vin in g_activeActivityIndices:
		techs.add( (p_fmt % (l_per, l_tech, l_vin), None) )
		for l_inp in ProcessInputs( l_per, l_tech, l_vin ):
			carriers.add( (l_inp, None) )
			inputs.add( (l_inp, p_fmt % (l_per, l_tech, l_vin), None) )
		for l_out in ProcessOutputs( l_per, l_tech, l_vin ):
			carriers.add( (l_out, None) )
			outputs.add( (p_fmt % (l_per, l_tech, l_vin), l_out, None) )

	techs    = create_text_nodes( techs,    indent=2 )
	carriers = create_text_nodes( carriers, indent=2 )
	inputs   = create_text_edges( inputs,   indent=2 )
	outputs  = create_text_edges( outputs,  indent=2 )

	with open( 'model.dot', 'w' ) as f:
		f.write( data % dict(
		  input_color   = 'forestgreen',
		  output_color  = 'firebrick',
		  carrier_color =  'lightsteelblue',
		  tech_color    = 'darkseagreen',
		  techs    = techs,
		  carriers = carriers,
		  inputs   = inputs,
		  outputs  = outputs,
		))

	# Outsource to Graphviz via the old Unix standby: temporary files
	ffmt = fileformat.lower()
	cmd = ('dot', '-T%s' % ffmt, '-omodel.%s' % ffmt, 'model.dot')
	call( cmd )
