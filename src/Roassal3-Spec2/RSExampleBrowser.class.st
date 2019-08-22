Class {
	#name : #RSExampleBrowser,
	#superclass : #StPresenter,
	#instVars : [
		'exampleTree',
		'examplePanel'
	],
	#category : #'Roassal3-Spec2'
}

{ #category : #specs }
RSExampleBrowser class >> defaultSpec [

	^ SpPanedLayout newHorizontal
		position: 30 percent;
		add: #exampleTree;
		add: #examplePanel;
		yourself
]

{ #category : #initialization }
RSExampleBrowser >> initializeWidgets [
	<script: 'self new openWithSpec'>

	exampleTree := self newTreeTable
		hideColumnHeaders;
		addColumn: (SpStringTableColumn evaluated: #name);
		roots: self rootNodes;
		children: #children;
		yourself.
		
	examplePanel := self newMorph.
	
	exampleTree transmitTo: examplePanel transform: #newMorph
]

{ #category : #initialization }
RSExampleBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Roassal3 Examples';
		initialExtent: 800@600
]

{ #category : #private }
RSExampleBrowser >> rootNodes [
	
	^ { 
	RSExampleContainer new
		name: 'Animation';
		collectChildrenFrom: RSAnimationExamples;
		yourself.
	RSExampleContainer new
		name: 'Highlightable';
		collectChildrenFrom: RSHighlightableExamples;
		yourself.
	RSExampleContainer new
		name: 'Layout';
		collectChildrenFrom: RSLayoutExamples;
		yourself.
	}
]
