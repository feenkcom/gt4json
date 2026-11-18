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
GtJsonUnknown >> allValuesDepthFirstDo: aBlock [
	"do nothing"

	
]

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

{ #category : #private }
GtJsonUnknown >> evaluateBlock: aBlock [
	self shouldNotImplement
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

	| aParentObject |
	self parent exists ifFalse: [ ^ self ].

	aParentObject := self parent jsonObject.
	aParentObject isDictionary
		ifTrue: [ GtJsonUtility
				keyIn: aParentObject
				matching: self path
				ifFound: [ :anExistingKey | aParentObject at: anExistingKey put: aNewValue ]
				ifNone: [ aParentObject
						at: (GtJsonUtility normalizedKey: self path)
						put: aNewValue ] ]
		ifFalse: [ aParentObject at: self path put: aNewValue ]
]

{ #category : #accessing }
GtJsonUnknown >> withParentsDo: aBlock [

	self parent ifNotNil: [ :aParent | aParent withParentsDo: aBlock ].
	aBlock cull: self
]
