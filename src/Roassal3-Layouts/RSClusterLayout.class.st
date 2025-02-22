"
TODO
"
Class {
	#name : #RSClusterLayout,
	#superclass : #RSAbstractGraphLayout,
	#instVars : [
		'externalLayer',
		'maxLayer',
		'maxAbcissa'
	],
	#category : #'Roassal3-Layouts-Core'
}

{ #category : #algorithm }
RSClusterLayout >> computePosition: aNode [
	| children previous |
	children := self childrenFor: aNode.
	children do: [ :e | self computePosition: e ].
	children isEmpty
		ifTrue: [ externalLayer first = aNode
				ifFalse: [ previous := externalLayer at: (externalLayer indexOf: aNode) - 1.
					(self fatherOf: previous) = (self fatherOf: aNode)
						ifTrue: [ self xOf: aNode put: (self xOf: previous) + (horizontalGap / 2) ]
						ifFalse: [ self xOf: aNode put: (self xOf: previous) + horizontalGap ] ] ]
		ifFalse: [ self
				xOf: aNode
				put:
					((self xOf: (self leftContourOf: aNode))
						+ (self xOf: (self rightContourOf: aNode))) / 2 ]
]

{ #category : #hook }
RSClusterLayout >> doExecute: nodeElements [ 
	| rootNodes gap |
	"Not much to do if there is only one element"
	nodeElements size = 1 ifTrue: [ ^ self ].
	
	rootNodes := self rootNodesFor: nodeElements.
	self validateCachedParents.
	rootNodes do: [ :e | self initializeNode: e ].
	rootNodes do: [ :e | self computePosition: e ].
	
	maxLayer := (rootNodes collect: [ :e | self layerOf: e ]) max.
	
	(rootNodes size > 1) ifTrue: [ maxLayer := maxLayer + 1 ].
	
	maxAbcissa := (self xOf: externalLayer last) + horizontalGap .
	
	gap := maxAbcissa "+ horizontalGap "/ 2 / Float pi / maxLayer.
	
	verticalGap := verticalGap max: gap.
	
	rootNodes do: [ :e | self draw: e. self step ].
	
	
]

{ #category : #'drawing - general' }
RSClusterLayout >> draw: aNode [
	(self childrenFor: aNode) do: [ :e | self draw: e ].
	translator 
		translateTopLeftOf: aNode 
		to: (Point r: (maxLayer - (self layerOf: aNode)) * verticalGap theta: (maxAbcissa - (self xOf: aNode) / maxAbcissa) * 2 * Float pi )
]

{ #category : #initialization }
RSClusterLayout >> initialize [ 
	super initialize.
	verticalGap := 30.
	horizontalGap := 20.
	externalLayer := OrderedCollection new
]

{ #category : #'initialize-release' }
RSClusterLayout >> initializeNode: aNode [
	|children|
	children := self childrenFor: aNode.
	
	children do: [ :e | self initializeNode: e.
						self fatherOf: e put: aNode ].
	
	children isEmpty ifTrue: [ self layerOf: aNode put: 0.
							externalLayer add: aNode ] 
					ifFalse: [ self layerOf: aNode put: ((children collect: [ :e | (self layerOf: e) ]) max + 1).
							self leftContourOf: aNode put: children first.
							self rightContourOf: aNode put: children last ].
					
]
