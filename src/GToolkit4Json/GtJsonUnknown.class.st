Class {
	#name : #GtJsonUnknown,
	#superclass : #GtJsonBasic,
	#instVars : [
		'path',
		'parent'
	],
	#category : #'GToolkit4Json-Json'
}

{ #category : #enumerating }
GtJsonUnknown >> collect: aBlock [

	^ #(  )
]

{ #category : #private }
GtJsonUnknown >> createJsonObject: aType [
	| aNewParent aNewInstance |
	aNewParent := self parent.
	self parent exists
		ifFalse: [ aNewParent := self parent createJsonObject: self path ].

	aNewInstance := aNewParent at: self path.
	^ aNewInstance createJsonObject: aType
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

{ #category : #private }
GtJsonUnknown >> updateValueInParent: aNewValue [
	"I am not sure what to do in this case."
	
	self parent exists ifFalse: [ ^ self ].
	
	self parent jsonObject at: self path put: aNewValue
]

{ #category : #accessing }
GtJsonUnknown >> withParentsDo: aBlock [

	self parent ifNotNil: [ :aParent | aParent withParentsDo: aBlock ].
	aBlock cull: self
]
