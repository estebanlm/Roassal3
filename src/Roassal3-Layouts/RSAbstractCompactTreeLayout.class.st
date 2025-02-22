"
TODO
"
Class {
	#name : #RSAbstractCompactTreeLayout,
	#superclass : #RSAbstractGraphLayout,
	#instVars : [
		'sonsDictionary',
		'root',
		'initialLayout',
		'margin'
	],
	#category : #'Roassal3-Layouts-Core'
}

{ #category : #testing }
RSAbstractCompactTreeLayout class >> horizontalGap: anInteger [
	^ self new horizontalGap: anInteger; yourself
]

{ #category : #testing }
RSAbstractCompactTreeLayout class >> horizontalGap: anInt verticalGap: another [

	| new |
	
	new := self new.
	new horizontalGap: anInt.
	new verticalGap: another.
	
	
	^ new 
]

{ #category : #testing }
RSAbstractCompactTreeLayout class >> isAbstract [
	^ self name = #RSAbstractCompactTreeLayout


]

{ #category : #testing }
RSAbstractCompactTreeLayout class >> verticalGap: anInteger [
	^ self new verticalGap: anInteger; yourself
]

{ #category : #private }
RSAbstractCompactTreeLayout >> childrenFor: aNode [ 
	^ sonsDictionary isEmpty 
		ifTrue: [ super childrenFor: aNode ] 
		ifFalse: [ sonsDictionary at: aNode ifAbsent: [ ^ OrderedCollection new ] ]
]

{ #category : #algorithm }
RSAbstractCompactTreeLayout >> compareContourOf: aNode with: another [
	"return the number of radians the subtree induced by aNode must be displaced to be separated by a predefined distance (horizontalGap) from the one induced by anotherNode"
	self subclassResponsibility
]

{ #category : #algorithm }
RSAbstractCompactTreeLayout >> computePosition: aNode [
"compute the position of the given node and of his sons recursively"
	self subclassResponsibility.
]

{ #category : #algorithm }
RSAbstractCompactTreeLayout >> followLeftContour: aNode toLayer: anInteger [
	"return the last node in the left contour begining at anode"
	
	((self layerOf: aNode) = anInteger ) ifTrue: [^ aNode  ].
	((self layerOf: aNode) > anInteger ) ifTrue: [^ nil  ].
	
	(self leftContourOf: aNode) isNil ifTrue: [ (self pointerOf: aNode)  isNil ifTrue: [ ^ nil ] 
														 ifFalse: [ ^ ( self followLeftContour: (self pointerOf: aNode) toLayer: anInteger ) ] ]
	
			  				ifFalse: [ ^ (self followLeftContour: (self leftContourOf: aNode) toLayer: anInteger ) ]
]

{ #category : #algorithm }
RSAbstractCompactTreeLayout >> followRightContour: aNode toLayer: anInteger [
	"return the node in the right contour begining at anode in layer anInteger"

	((self layerOf: aNode) = anInteger ) ifTrue: [^ aNode  ].
	((self layerOf: aNode) > anInteger ) ifTrue: [^ nil  ].

	(self rightContourOf: aNode) isNil ifTrue: [ (self pointerOf: aNode) isNil ifTrue: [ ^ nil ] 
														 ifFalse: [ ^ ( self followRightContour: (self pointerOf: aNode) toLayer: anInteger ) ] ]
	
			  				ifFalse: [ ^ (self followRightContour: (self rightContourOf: aNode) toLayer: anInteger ) ]
]

{ #category : #algorithm }
RSAbstractCompactTreeLayout >> getAbcissaOf: aNode inSubtreeFromLayer: anInteger [
	| node x |
	
	(anInteger < 0) ifTrue: [^ self getAbcissaOf: aNode inSubtreeFromLayer: 0 ].
	
	((self layerOf: aNode) = anInteger ) ifTrue: [ ^ self xOf: aNode ].
	((self layerOf: aNode) < anInteger ) ifTrue: [ ^ nil ].
	
	x := (self xOf: aNode) + (self modOf: aNode).
	
	node := self fatherOf: aNode.
	
	[(self layerOf: node) = anInteger  ] whileFalse: [ x := x + (self modOf: node).
									node := self fatherOf: node ].
								
	^ x
]

{ #category : #'initialize-release' }
RSAbstractCompactTreeLayout >> greedyCycleRemoval: aGraph [
]

{ #category : #'initialize-release' }
RSAbstractCompactTreeLayout >> initialLayout: aLayout [
	initialLayout := aLayout 
]

{ #category : #initialization }
RSAbstractCompactTreeLayout >> initialize [ 
	super initialize.
	verticalGap := 20.
	horizontalGap := 30.
	margin := 40. 
	sonsDictionary := Dictionary new
]

{ #category : #'initialize-release' }
RSAbstractCompactTreeLayout >> initialize: aNode whoseFatherIs: another [ 
	self fatherOf: aNode put: another.
	
	another isNil ifTrue: [ self layerOf: aNode put: 0 ] ifFalse: [ self layerOf: aNode put: (self layerOf: another) + 1 ] .
	
	( self childrenFor: aNode ) do: [ :e | self initialize: e whoseFatherIs: aNode ]
]

{ #category : #algorithm }
RSAbstractCompactTreeLayout >> leftSiblingOf: aNode [
	"return the left sibling of the given node "
	| children |

	(self fatherOf: aNode) isNil ifTrue: ["has no sibling" ^ nil]
					    ifFalse: [ children := self childrenFor: (self fatherOf: aNode).
								(children first) = aNode ifTrue: ["as no left sibling" ^ nil ]
																    ifFalse: [^ children at: ((children indexOf: aNode) - 1) ] ]
]

{ #category : #'initialize-release' }
RSAbstractCompactTreeLayout >> root: aNode [ 
	root := aNode 
]
