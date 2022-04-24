Class {
	#name : #GtJsonIndex,
	#superclass : #GtJsonRasic,
	#instVars : [
		'parent',
		'index'
	],
	#category : #'GToolkit4Json-Json'
}

{ #category : #'gt - extensions' }
GtJsonIndex >> gtJsonPathItemText [

	^ self index asString
]

{ #category : #accessing }
GtJsonIndex >> index [

	^ index
]

{ #category : #accessing }
GtJsonIndex >> index: anObject [

	index := anObject
]

{ #category : #accessing }
GtJsonIndex >> parent [

	^ parent
]

{ #category : #accessing }
GtJsonIndex >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
GtJsonIndex >> pathText [

	<return: #BlText>
	| aPath |
	aPath := '[' asRopedText
		         append: self index asRopedText;
		         append: ']' asRopedText.
		         
	self exists ifFalse: [ 
		aPath foreground: BrGlamorousColors errorBackgroundColor ].
		
	^ aPath
]

{ #category : #enumerating }
GtJsonIndex >> withParentsDo: aBlock [

	self parent ifNotNil: [ :aParent | aParent withParentsDo: aBlock ].
	aBlock cull: self
]
