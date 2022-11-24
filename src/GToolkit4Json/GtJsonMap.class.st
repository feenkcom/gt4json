Class {
	#name : #GtJsonMap,
	#superclass : #GtJsonBasic,
	#instVars : [
		'parent'
	],
	#category : #'GToolkit4Json-Support'
}

{ #category : #'gt - extensions' }
GtJsonMap >> gtJsonPathItemText [
	^ 'map(...)'
]

{ #category : #accessing }
GtJsonMap >> parent [
	^ parent
]

{ #category : #accessing }
GtJsonMap >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
GtJsonMap >> pathText [

	<return: #BlText>
	| aPath |
	aPath := '.map(...)' asRopedText.
	self exists ifFalse: [ 
		aPath foreground: BrGlamorousColors errorBackgroundColor ].
	^ aPath
]

{ #category : #printing }
GtJsonMap >> printOn: aStream [
	super printOn: aStream.

	aStream
		space;
		nextPut: $[;
		print: self size;
		space;
		nextPutAll: ('item' asPluralBasedOn: self size);
		nextPut: $]
]

{ #category : #accessing }
GtJsonMap >> size [
	^ self exists ifTrue: [ self jsonObject size ] ifFalse: [ 0 ]
]

{ #category : #enumerating }
GtJsonMap >> withParentsDo: aBlock [

	self parent ifNotNil: [ :aParent | aParent withParentsDo: aBlock ].
	aBlock cull: self
]
