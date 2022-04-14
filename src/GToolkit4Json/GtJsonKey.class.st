Class {
	#name : #GtJsonKey,
	#superclass : #GtJsonRasic,
	#instVars : [
		'key',
		'parent'
	],
	#category : #'GToolkit4Json-Model'
}

{ #category : #'gt - extensions' }
GtJsonKey >> gtJsonPathItemText [

	^ self key asString
]

{ #category : #accessing }
GtJsonKey >> key [

	^ key
]

{ #category : #accessing }
GtJsonKey >> key: anObject [

	key := anObject
]

{ #category : #accessing }
GtJsonKey >> parent [

	^ parent
]

{ #category : #accessing }
GtJsonKey >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
GtJsonKey >> pathText [

	<return: #BlText>
	| aPath |
	aPath := '.' asRopedText append: self key asRopedText.
	self exists ifFalse: [ 
		aPath foreground: BrGlamorousColors errorBackgroundColor ].
	^ aPath
]

{ #category : #enumerating }
GtJsonKey >> withParentsDo: aBlock [

	self parent ifNotNil: [ :aParent | aParent withParentsDo: aBlock ].
	aBlock cull: self
]
