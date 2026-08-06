"
I compare the structural shape of two JSON object graphs.

A shape comparison ignores concrete scalar values and focuses on structure:
- dictionaries must have the same keys;
- arrays must have the same size;
- scalar leaves must have the same JSON kind (string, number, boolean, null).

Use the class side constructor #compareJsonString:withJsonString: when starting from JSON text, or #compare:with: when starting from already parsed JSON-compatible objects.
"
Class {
	#name : #GtJsonShapeComparison,
	#superclass : #Object,
	#instVars : [
		'differences'
	],
	#category : #'GToolkit4Json-Utilities'
}

{ #category : #'instance creation' }
GtJsonShapeComparison class >> compare: aJsonObject with: anotherJsonObject [
	^ self new
		compare: aJsonObject with: anotherJsonObject;
		yourself
]

{ #category : #'instance creation' }
GtJsonShapeComparison class >> compareJsonString: aJsonString withJsonString: anotherJsonString [
	^ self
		compare: (NeoJSONReader fromString: aJsonString)
		with: (NeoJSONReader fromString: anotherJsonString)
]

{ #category : #private }
GtJsonShapeComparison >> addDifferenceAt: aPath message: aMessage [
	differences add: aPath -> aMessage
]

{ #category : #comparing }
GtJsonShapeComparison >> compare: aJsonObject with: anotherJsonObject [
	self compare: aJsonObject with: anotherJsonObject atPath: '$'
]

{ #category : #comparing }
GtJsonShapeComparison >> compare: aJsonObject with: anotherJsonObject atPath: aPath [
	| leftKind rightKind |
	leftKind := self jsonKindOf: aJsonObject.
	rightKind := self jsonKindOf: anotherJsonObject.
	leftKind = rightKind
		ifFalse: [ ^ self addDifferenceAt: aPath message: 'expected ', leftKind asString, ' but found ', rightKind asString ].
	leftKind = #object
		ifTrue: [ ^ self compareObject: aJsonObject with: anotherJsonObject atPath: aPath ].
	leftKind = #array
		ifTrue: [ ^ self compareArray: aJsonObject with: anotherJsonObject atPath: aPath ].
]

{ #category : #comparing }
GtJsonShapeComparison >> compareArray: aCollection with: anotherCollection atPath: aPath [
	aCollection size = anotherCollection size
		ifFalse: [ self addDifferenceAt: aPath message: 'expected array size ', aCollection size asString, ' but found ', anotherCollection size asString ].
	1 to: (aCollection size min: anotherCollection size) do: [ :eachIndex |
		self
			compare: (aCollection at: eachIndex)
			with: (anotherCollection at: eachIndex)
			atPath: (self path: aPath index: eachIndex) ]
]

{ #category : #comparing }
GtJsonShapeComparison >> compareObject: aDictionary with: anotherDictionary atPath: aPath [
	| leftKeys rightKeys missingKeys extraKeys commonKeys |
	leftKeys := aDictionary keys asSet.
	rightKeys := anotherDictionary keys asSet.
	missingKeys := leftKeys difference: rightKeys.
	extraKeys := rightKeys difference: leftKeys.
	missingKeys asSortedCollection do: [ :eachKey |
		self addDifferenceAt: (self path: aPath key: eachKey) message: 'missing key' ].
	extraKeys asSortedCollection do: [ :eachKey |
		self addDifferenceAt: (self path: aPath key: eachKey) message: 'extra key' ].
	commonKeys := leftKeys intersection: rightKeys.
	commonKeys asSortedCollection do: [ :eachKey |
		self
			compare: (aDictionary at: eachKey)
			with: (anotherDictionary at: eachKey)
			atPath: (self path: aPath key: eachKey) ]
]

{ #category : #accessing }
GtJsonShapeComparison >> differences [
	^ differences
]

{ #category : #views }
GtJsonShapeComparison >> gtDifferencesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Differences';
		priority: 10;
		items: [ self differences ];
		column: 'Path' text: [ :each | each key ];
		column: 'Difference' text: [ :each | each value ];
		actionUpdateButtonTooltip: 'Update differences'
]

{ #category : #initialization }
GtJsonShapeComparison >> initialize [
	super initialize.
	differences := OrderedCollection new
]

{ #category : #private }
GtJsonShapeComparison >> jsonKindOf: anObject [
	anObject isNil
		ifTrue: [ ^ #null ].
	anObject isDictionary
		ifTrue: [ ^ #object ].
	(anObject isArray or: [ anObject class name = #NeoJSONArray ])
		ifTrue: [ ^ #array ].
	anObject isString
		ifTrue: [ ^ #string ].
	anObject isBoolean
		ifTrue: [ ^ #boolean ].
	anObject isNumber
		ifTrue: [ ^ #number ].
	^ anObject class name asSymbol
]

{ #category : #testing }
GtJsonShapeComparison >> matches [
	^ differences isEmpty
]

{ #category : #private }
GtJsonShapeComparison >> path: aPath index: anIndex [
	^ aPath, '[', anIndex asString, ']'
]

{ #category : #private }
GtJsonShapeComparison >> path: aPath key: aKey [
	^ aPath, '.', aKey asString
]

{ #category : #printing }
GtJsonShapeComparison >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: (self matches ifTrue: [ 'matching shape' ] ifFalse: [ differences size asString, ' differences' ]);
		nextPutAll: ')'
]
