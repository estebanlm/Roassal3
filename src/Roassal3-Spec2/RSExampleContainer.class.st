Class {
	#name : #RSExampleContainer,
	#superclass : #RSExampleNode,
	#instVars : [
		'name',
		'children'
	],
	#category : #'Roassal3-Spec2'
}

{ #category : #accessing }
RSExampleContainer >> children [
	^ children
]

{ #category : #accessing }
RSExampleContainer >> children: anObject [
	children := anObject
]

{ #category : #'as yet unclassified' }
RSExampleContainer >> collectChildrenFrom: aClass [ 
	
	self children: ((aClass methods 
		select: [ :each | each selector beginsWith: 'example' ]
		thenCollect: [ :each | RSExampleMethod newMethod: each  ])
		sort: #name ascending) 
]

{ #category : #accessing }
RSExampleContainer >> name [
	^ name
]

{ #category : #accessing }
RSExampleContainer >> name: anObject [
	name := anObject
]

{ #category : #accessing }
RSExampleContainer >> newMorph [

	^ PanelMorph new
]
