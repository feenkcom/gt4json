Class {
	#name : #GtJsonKey,
	#superclass : #GtJsonBasic,
	#instVars : [
		'key',
		'parent'
	],
	#category : #'GToolkit4Json-Json'
}

{ #category : #private }
GtJsonKey >> createJsonObject: aType [
	"Create an empty JSON object"

	| aNewValue |
	aNewValue := GtJsonUtility newValueOfType: aType.
	self jsonObject: aNewValue.
	self updateValueInParent: aNewValue
]

{ #category : #private }
GtJsonKey >> evaluateBlock: aBlock [
	aBlock
		cull: self jsonObject
		cull: self key
		cull: self parent
		cull: self
]

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

{ #category : #private }
GtJsonKey >> updateValueInParent: aNewValue [
	"Set new value in my parent JSON object"

	| aParentObject |
	aParentObject := self parent jsonObject.
	aParentObject at: self key put: aNewValue
]

{ #category : #enumerating }
GtJsonKey >> withParentsDo: aBlock [

	self parent ifNotNil: [ :aParent | aParent withParentsDo: aBlock ].
	aBlock cull: self
]
