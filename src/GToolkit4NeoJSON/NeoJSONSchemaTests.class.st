Class {
	#name : #NeoJSONSchemaTests,
	#superclass : #TestCase,
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #accessing }
NeoJSONSchemaTests >> arrayOfInstances [
	^ { 42 . 'string' . Float pi . true . nil . #(1 2 3). { 'foo'->'bar' } as: NeoJSONObject }
]

{ #category : #accessing }
NeoJSONSchemaTests >> testBoolean [
	| schema |
	schema := NeoJSONSchema new json: ({ 'type' -> 'boolean' } as: NeoJSONObject).
	#( true false ) do: [ :each |
		self assert: (schema validate: each) ].
	{ 'foo' . 42 . nil . #(1 2 3) . Float pi } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #accessing }
NeoJSONSchemaTests >> testConst [
	| schema |
	schema := NeoJSONSchema new json: ({ 'const' -> 'one' } as: NeoJSONObject).
	self assert: (schema validate: 'one').
	{ 42 . 'string' . Float pi . true . #(1 2 3). { 'foo'->'bar' } as: NeoJSONObject } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testEmpty [
	| schema |
	schema := NeoJSONSchema new.
	self arrayOfInstances do: [ :each |
		self assert: (schema validate: each) ] 
]

{ #category : #accessing }
NeoJSONSchemaTests >> testEnum [
	| schema |
	schema := NeoJSONSchema new json: ({ 'enum' -> #( 'one' 'two' ) } as: NeoJSONObject).
	#( 'one' 'two' ) do: [ :each |
		self assert: (schema validate: each) ].
	{ 'foo' . Float pi . true . nil . #(1 2 3) } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testFalse [
	| schema |
	schema := NeoJSONSchema new json: false.
	self arrayOfInstances do: [ :each |
		self deny: (schema validate: each) ] 
]

{ #category : #accessing }
NeoJSONSchemaTests >> testInteger [
	| schema |
	schema := NeoJSONSchema new json: ({ 'type' -> 'integer' } as: NeoJSONObject).
	#( 1 -1 0 1.0 0.0 -1.0 ) do: [ :each |
		self assert: (schema validate: each) ].
	{ 'foo' . Float pi . true . nil . #(1 2 3) } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #accessing }
NeoJSONSchemaTests >> testIntegerMultiple [
	| schema |
	schema := NeoJSONSchema new json: ({ 
		'type' -> 'integer' . 
		'multipleOf' -> 10 } as: NeoJSONObject).
	#( 0 10 20 100 ) do: [ :each |
		self assert: (schema validate: each) ].
	#( 1 5 15 3.14159 'NaN' ) do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #accessing }
NeoJSONSchemaTests >> testNull [
	| schema |
	schema := NeoJSONSchema new json: ({ 'type' -> 'null' } as: NeoJSONObject).
	self assert: (schema validate: nil).
	{ 42 . 'string' . Float pi . true . #(1 2 3). { 'foo'->'bar' } as: NeoJSONObject } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #accessing }
NeoJSONSchemaTests >> testNumber [
	| schema |
	schema := NeoJSONSchema new json: ({ 'type' -> 'number' } as: NeoJSONObject).
	#( 1 -1 0 1.0 0.0 -1.0 3.14159 -0.123456789e10 ) do: [ :each |
		self assert: (schema validate: each) ].
	{ 'foo' . true . nil . #(1 2 3) } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #accessing }
NeoJSONSchemaTests >> testNumberExclusiveRange [
	| schema |
	schema := NeoJSONSchema new json: ({ 
		'type' -> 'number' . 
		'exclusiveMinimum' -> 10 . 
		'exclusiveMaximum' -> 20 } as: NeoJSONObject).
	#( 11 15 19 ) do: [ :each |
		self assert: (schema validate: each) ].
	#( 10 20 0 50 -1.0 'NaN' ) do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #accessing }
NeoJSONSchemaTests >> testNumberRange [
	| schema |
	schema := NeoJSONSchema new json: ({ 
		'type' -> 'number' . 
		'minimum' -> 10 . 
		'maximum' -> 20 } as: NeoJSONObject).
	#( 10 15 20 ) do: [ :each |
		self assert: (schema validate: each) ].
	#( 0 50 -1.0 'NaN' ) do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #accessing }
NeoJSONSchemaTests >> testString [
	| schema |
	schema := NeoJSONSchema new json: ({ 'type' -> 'string' } as: NeoJSONObject).
	#( 'str' '' 'élève' ) do: [ :each |
		self assert: (schema validate: each) ].
	{ 42 . 3.14159 . true . nil . #(1 2 3) } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #accessing }
NeoJSONSchemaTests >> testStringLength [
	| schema |
	schema := NeoJSONSchema new json: ({ 
		'type' -> 'string'.
		'minLength' -> 2.
		'maxLength' -> 4 } as: NeoJSONObject).
	#( 'AB' 'ABC' 'ABCD' ) do: [ :each |
		self assert: (schema validate: each) ].
	#( '' 'A' 'ABCDE' 42 true nil ) do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testTrue [
	| schema |
	schema := NeoJSONSchema new json: true.
	self arrayOfInstances do: [ :each |
		self assert: (schema validate: each) ] 
]
