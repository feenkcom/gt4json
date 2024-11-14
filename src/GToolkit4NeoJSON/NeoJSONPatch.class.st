Class {
	#name : #NeoJSONPatch,
	#superclass : #Object,
	#instVars : [
		'operation',
		'path',
		'value',
		'from'
	],
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #operations }
NeoJSONPatch >> applyTo: anObject [
	self isAddition
		ifTrue: [
			self path isRoot ifTrue: [ ^ self value ]. 
			^ anObject
				atPath: self path tokens put: self value;
				yourself ].
	self isRemoval
		ifTrue: [ | subObject token |
			self path isRoot ifTrue: [ ^ anObject species new ].
			subObject := self path size = 1
				ifTrue: [
					anObject ]
				ifFalse: [
					anObject atPath: self path tokens allButLast ].
			token := self path tokens last.
			token isInteger
				ifTrue: [ anObject 
							at: self path tokens allButLast 
							put: (subObject copyWithoutIndex:  token) ]
				ifFalse: [ subObject removeKey: token ].
			^ anObject ].
	self isReplacement
		ifTrue: [
			self path isRoot ifTrue: [ ^ self value ]. 
			^ anObject
				atPath: self path tokens put: self value;
				yourself ].
	self isCopy
		ifTrue: [
			^ anObject 
				atPath: self path tokens 
				put: (anObject atPath: self from tokens);
				yourself].
	self isMove
		ifTrue: [
			anObject 
				atPath: self path tokens 
				put: (anObject atPath: self from tokens).
			(anObject atPath: self from tokens allButLast) 
				removeKey: self from tokens last.
			^ anObject ].
	self isTest
		ifTrue: [
			self assert: (anObject atPath: self path tokens) equals: self value.
			^ true ].
	^ anObject
]

{ #category : #accessing }
NeoJSONPatch >> from [
	^ from
]

{ #category : #accessing }
NeoJSONPatch >> from: aJSONPointer [
	from := aJSONPointer
]

{ #category : #initialization }
NeoJSONPatch >> fromDictionary: aDictionary [
	self operation: (aDictionary at: 'op').
	self path: (NeoJSONPointer new fromString: (aDictionary at: 'path')).
	self isCopy | self isMove 
		ifTrue: [ self from: (NeoJSONPointer new fromString: (aDictionary at: 'from')) ]
		ifFalse: [ self value: (aDictionary at: 'value') ]
]

{ #category : #testing }
NeoJSONPatch >> isAddition [
	^ self operation = 'add'
]

{ #category : #testing }
NeoJSONPatch >> isCopy [
	^ self operation = 'copy'
]

{ #category : #testing }
NeoJSONPatch >> isMove [
	^ self operation = 'move'
]

{ #category : #testing }
NeoJSONPatch >> isRemoval [
	^ self operation = 'remove'
]

{ #category : #testing }
NeoJSONPatch >> isReplacement [
	^ self operation = 'replace'
]

{ #category : #testing }
NeoJSONPatch >> isTest [
	^ self operation = 'test'
]

{ #category : #accessing }
NeoJSONPatch >> operation [
	^ operation
]

{ #category : #accessing }
NeoJSONPatch >> operation: aString [
	self assert: (#('add' 'remove' 'replace' 'move' 'copy' 'test') includes: aString).
	operation := aString
]

{ #category : #accessing }
NeoJSONPatch >> path [
	^ path
]

{ #category : #accessing }
NeoJSONPatch >> path: aJSONPointer [
	path := aJSONPointer
]

{ #category : #accessing }
NeoJSONPatch >> value [
	^ value
]

{ #category : #accessing }
NeoJSONPatch >> value: anObject [
	value := anObject
]
