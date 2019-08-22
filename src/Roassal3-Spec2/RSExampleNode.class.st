Class {
	#name : #RSExampleNode,
	#superclass : #Object,
	#category : #'Roassal3-Spec2'
}

{ #category : #accessing }
RSExampleNode >> children [

	^ #()
]

{ #category : #accessing }
RSExampleNode >> fullName [

	^ self name
]

{ #category : #accessing }
RSExampleNode >> name [

	^ self subclassResponsibility
]

{ #category : #'private factory' }
RSExampleNode >> newMorph [

	^ self subclassResponsibility
]
