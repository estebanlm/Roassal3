Class {
	#name : #RSExampleMethod,
	#superclass : #RSExampleNode,
	#instVars : [
		'method'
	],
	#category : #'Roassal3-Spec2'
}

{ #category : #'instance creation' }
RSExampleMethod class >> newMethod: aMethod [

	^ self new 
		method: aMethod;
		yourself
]

{ #category : #private }
RSExampleMethod >> errorString: error [
		
	^ String streamContents: [ :stream | 
		error signalerContext shortDebugStackOn: stream ]
]

{ #category : #accessing }
RSExampleMethod >> fullName [

	^ self method selector
]

{ #category : #accessing }
RSExampleMethod >> method [
	^ method
]

{ #category : #accessing }
RSExampleMethod >> method: anObject [
	method := anObject
]

{ #category : #accessing }
RSExampleMethod >> name [

	^ self method selector allButFirst: 9
]

{ #category : #'private factory' }
RSExampleMethod >> newMorph [

	^ [ self newView createMorph ]
	on: Error 
	do: [ :e | 
		Morph new  
			color: Color red;
			addMorph: (self errorString: e) asMorph asReadOnlyMorph;
			yourself ]
]

{ #category : #'private factory' }
RSExampleMethod >> newView [
	
	^ self method 
		valueWithReceiver: self method methodClass new
		arguments: #()
]
