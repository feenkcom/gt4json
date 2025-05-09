"
I implement JSON Pointer (https://www.rfc-editor.org/rfc/rfc6901)
"
Class {
	#name : #NeoJSONPointer,
	#superclass : #Object,
	#instVars : [
		'tokens'
	],
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #accessing }
NeoJSONPointer >> add: token [
	self assert: token isString | token isInteger.
	self tokens add: token
]

{ #category : #examples }
NeoJSONPointer >> exampleConstructed [
	<gtExample>
	<return: #NeoJSONPointer>
	self tokens: #(foo 1 bar).
	self assert: self isRoot not.
	self assert: self tokens first equals: 'foo'.
	self assert: self tokens second equals: 1.
	self assert: self tokens third equals: 'bar'.
	self assert: self printString equals: '/foo/0/bar'
]

{ #category : #examples }
NeoJSONPointer >> exampleEscape [
	<gtExample>
	<return: #NeoJSONPointer>
	self fromString: '/_~1_/7/_~0_'.
	self assert: self isRoot not.
	self assert: self tokens first equals: '_/_'.
	self assert: self tokens second equals: 8.
	self assert: self tokens third equals: '_~_'.
	self assert: self printString equals: '/_~1_/7/_~0_'
]

{ #category : #examples }
NeoJSONPointer >> exampleRoot [
	<gtExample>
	<return: #NeoJSONPointer>
	self assert: self isRoot.
	self assert: self path isEmpty.
	self assert: self printString equals: String empty
]

{ #category : #examples }
NeoJSONPointer >> exampleSimple [
	<gtExample>
	<return: #NeoJSONPointer>
	self fromString: '/foo/1/bar'.
	self assert: self isRoot not.
	self assert: self tokens first equals: 'foo'.
	self assert: self tokens second equals: 2.
	self assert: self tokens third equals: 'bar'.
	self assert: self printString equals: '/foo/1/bar'
]

{ #category : #parsing }
NeoJSONPointer >> fromString: string [
	| parts token stream char |
	parts := string findTokens: $/.
	parts do: [ :part |
		token := String streamContents: [ :out |
			stream := part readStream.
			[ stream atEnd ] whileFalse: [
				char := stream next.
				char = $~
					ifTrue: [
						char := stream next.
						char = $0 ifTrue: [ out nextPut: $~ ].
						char = $1 ifTrue: [ out nextPut: $/ ] ]
					ifFalse: [ out nextPut: char ] ] ].
		token := Integer readFrom: token ifFail: [ token ].
		token isInteger ifTrue: [ token := token + 1 ].
		self add: token ]
]

{ #category : #testing }
NeoJSONPointer >> isRoot [
	^ tokens isEmptyOrNil
]

{ #category : #accessing }
NeoJSONPointer >> path [
	^ self tokens
]

{ #category : #printing }
NeoJSONPointer >> printOn: stream [
	self isRoot ifTrue: [ ^ self ].
	self tokens do: [ :token |
		stream nextPut: $/.
		token isInteger
			ifTrue: [ stream print: token - 1 ]
			ifFalse: [ token do: [ :char |
				char = $/
					ifTrue: [ stream nextPut: $~; print: 1 ]
					ifFalse: [
						char = $~
							ifTrue: [ stream nextPut: $~; print: 0 ]
							ifFalse: [ stream nextPut: char ] ] ] ] ]
]

{ #category : #accessing }
NeoJSONPointer >> size [
	^ self isRoot ifTrue: [ 0 ] ifFalse: [ self tokens size ]
]

{ #category : #accessing }
NeoJSONPointer >> tokens [
	^ tokens ifNil: [ tokens := OrderedCollection new ]
]

{ #category : #accessing }
NeoJSONPointer >> tokens: aCollection [
	aCollection do: [ :each | self add: each ]
]
