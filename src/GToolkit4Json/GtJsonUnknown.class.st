Class {
	#name : #GtJsonUnknown,
	#superclass : #GtJsonRasic,
	#instVars : [
		'path',
		'parent'
	],
	#category : #'GToolkit4Json-Model'
}

{ #category : #enumerating }
GtJsonUnknown >> collect: aBlock [

	^ #(  )
]

{ #category : #'gt - extensions' }
GtJsonUnknown >> gtJsonPathItemText [

	^ self path asString
]

{ #category : #accessing }
GtJsonUnknown >> parent [

	^ parent
]

{ #category : #accessing }
GtJsonUnknown >> parent: anObject [

	parent := anObject
]

{ #category : #accessing }
GtJsonUnknown >> path [

	^ path
]

{ #category : #accessing }
GtJsonUnknown >> path: anObject [

	path := anObject
]

{ #category : #accessing }
GtJsonUnknown >> pathText [

	<return: #BlText>
	^ ('.' asRopedText append: self path asRopedText) foreground:
		  BrGlamorousColors errorBackgroundColor
]

{ #category : #accessing }
GtJsonUnknown >> withParentsDo: aBlock [

	self parent ifNotNil: [ :aParent | aParent withParentsDo: aBlock ].
	aBlock cull: self
]
