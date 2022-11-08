Class {
	#name : #GtJsonFilter,
	#superclass : #GtJsonBasic,
	#instVars : [
		'parent'
	],
	#category : #'GToolkit4Json-Support'
}

{ #category : #'gt - extensions' }
GtJsonFilter >> gtJsonPathItemText [
	^ 'filter(...)'
]

{ #category : #accessing }
GtJsonFilter >> parent [

	^ parent
]

{ #category : #accessing }
GtJsonFilter >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
GtJsonFilter >> pathText [

	<return: #BlText>
	| aPath |
	aPath := '.filter(...)' asRopedText.
	self exists ifFalse: [ 
		aPath foreground: BrGlamorousColors errorBackgroundColor ].
	^ aPath
]

{ #category : #printing }
GtJsonFilter >> printOn: aStream [
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
GtJsonFilter >> size [
	^ self exists ifTrue: [ self jsonObject size ] ifFalse: [ 0 ]
]

{ #category : #enumerating }
GtJsonFilter >> withParentsDo: aBlock [

	self parent ifNotNil: [ :aParent | aParent withParentsDo: aBlock ].
	aBlock cull: self
]
