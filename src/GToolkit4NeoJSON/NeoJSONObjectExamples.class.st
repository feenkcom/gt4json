"
I show that a NeoJSONObject answers lookups and changes with String and Symbol keys.
A NeoJSONObject stores its keys as Strings, the names of JSON properties: every method that takes a key converts a Symbol key to a String (see NeoJSONObject>>#normalizedJsonKey:). So a key read from JSON and a key written as a Symbol in code are the same key, also when Strings and Symbols are never equal.
"
Class {
	#name : #NeoJSONObjectExamples,
	#superclass : #Object,
	#category : #'GToolkit4NeoJSON-Examples'
}

{ #category : #examples }
NeoJSONObjectExamples >> changesWithBothKinds [
	<gtExample>
	<return: #NeoJSONObject>
	| object |
	object := NeoJSONObject fromString: '{"a":1,"b":2,"c":3,"d":4}'.
	object at: #a put: 10.
	self assert: object size equals: 4.
	self assert: (object at: 'a') equals: 10.
	object add: #e -> 5.
	self assert: (object at: 'e') equals: 5.
	object replaceKey: #b with: #bb.
	self assert: (object at: 'bb') equals: 2.
	self assert: (object removeKey: #c) equals: 3.
	self assert: (object removeKey: #c ifAbsent: [ nil ]) isNil.
	object removeKeys: #(#d #e).
	object at: #f at: #g ifAbsentPut: [ 6 ].
	self assert: (object at: 'f') class equals: NeoJSONObject.
	self assert: (object at: 'f' at: 'g') equals: 6.
	self assert: object keys asArray equals: #('a' 'bb' 'f').
	self assert: (object keys allSatisfy: [ :each | each isString and: [ each isSymbol not ] ]).
	^ object
]

{ #category : #examples }
NeoJSONObjectExamples >> collectAndSelectKeepStringKeys [
	<gtExample>
	<return: #NeoJSONObject>
	| object collected selected |
	object := NeoJSONObject new
			at: #a put: 1;
			at: #b put: 2;
			yourself.
	collected := object collect: [ :each | each * 10 ].
	selected := object select: [ :each | each > 1 ].
	self assert: collected class equals: NeoJSONObject.
	self assert: (collected at: #b) equals: 20.
	self assert: selected keys asArray equals: #('b').
	self assert: (selected at: #b) equals: 2.
	self assert: object copy keys asArray equals: #('a' 'b').
	^ object
]

{ #category : #examples }
NeoJSONObjectExamples >> lookupsWithBothKinds [
	<gtExample>
	<return: #NeoJSONObject>
	| object |
	object := self parsedObjectHasStringKeys.
	{ #title. 'title' }
		do: [ :aKey |
			self assert: (object includesKey: aKey).
			self assert: (object at: aKey ifAbsent: [ nil ]) equals: 'x'.
			self assert: (object at: aKey ifPresent: [ :aValue | aValue ]) equals: 'x'.
			self assert: (object at: aKey ifPresent: [ :aValue | aValue ] ifAbsent: [ nil ]) equals: 'x'.
			self assert: (object at: aKey ifAbsentPut: [ 'other' ]) equals: 'x'.
			self assert: (object associationAt: aKey) value equals: 'x'.
			self assert: (object associationAt: aKey ifAbsent: [ nil ]) value equals: 'x'.
			self assert: (object associationAt: aKey ifPresent: [ :anAssociation | anAssociation value ]) equals: 'x'.
			self
				assert: (object
						associationAt: aKey
						ifPresent: [ :anAssociation | anAssociation value ]
						ifAbsent: [ nil ])
				equals: 'x'.
			self assert: (object includesAssociation: aKey -> 'x').
			self assert: (object indexOfKey: aKey) equals: 1 ].
	{ #address. 'address' }
		do: [ :aKey |
			self assert: (object at: aKey at: #city ifAbsent: [ nil ]) equals: 'Bern'.
			self assert: (object at: aKey at: 'city' ifAbsent: [ nil ]) equals: 'Bern' ].
	self assert: (object includesKey: #missing) not.
	self assert: (object at: #missing) isNil.
	self assert: (object at: #missing at: #city ifAbsent: [ nil ]) isNil.
	self assert: object size equals: 3.
	^ object
]

{ #category : #examples }
NeoJSONObjectExamples >> parsedAndBuiltObjectsAreEqual [
	"An object built with String and Symbol keys equals the same object read from JSON, and writes the same JSON"

	<gtExample>
	<return: #NeoJSONObject>
	| parsed built |
	parsed := NeoJSONObject fromString: '{"title":"x","address":{"city":"Bern"}}'.
	built := NeoJSONObject new
			at: 'title' put: 'x';
			at: #address put: (NeoJSONObject new at: #city put: 'Bern'; yourself);
			yourself.
	self assert: built equals: parsed.
	self assert: parsed equals: built.
	self assert: (NeoJSONWriter toString: built) equals: '{"title":"x","address":{"city":"Bern"}}'.
	self assert: (NeoJSONWriter toString: built) equals: (NeoJSONWriter toString: parsed).
	^ built
]

{ #category : #examples }
NeoJSONObjectExamples >> parsedObjectHasStringKeys [
	"JSON property names are Strings; they can be looked up with Strings and Symbols"

	<gtExample>
	<return: #NeoJSONObject>
	| object |
	object := NeoJSONObject fromString: '{"title":"x","address":{"city":"Bern"},"tags":["a","b"]}'.
	self assert: object keys asArray equals: #('title' 'address' 'tags').
	self assert: (object keys allSatisfy: [ :each | each isString and: [ each isSymbol not ] ]).
	self assert: ((object at: 'address') keys allSatisfy: [ :each | each isString and: [ each isSymbol not ] ]).
	self assert: (object at: #title) equals: 'x'.
	self assert: (object at: 'title') equals: 'x'.
	self assert: object title equals: 'x'.
	self assert: (object at: #address at: #city) equals: 'Bern'.
	self assert: (object at: 'address' at: 'city') equals: 'Bern'.
	self assert: (object atPath: #(#address #city)) equals: 'Bern'.
	self assert: (object atPath: #('address' 'city')) equals: 'Bern'.
	self assert: object address city equals: 'Bern'.
	self assert: (object at: #tags) size equals: 2.
	^ object
]

{ #category : #examples }
NeoJSONObjectExamples >> symbolKeysAreStoredAsStrings [
	"A Symbol key, also from a dynamic accessor such as #age:, is stored as a String"

	<gtExample>
	<return: #NeoJSONObject>
	| object |
	object := NeoJSONObject new.
	object at: #name put: 'x'.
	object age: 3.
	object at: 'name' put: 'y'.
	self assert: object size equals: 2.
	self assert: object keys asArray equals: #('name' 'age').
	self assert: (object keys allSatisfy: [ :each | each isString and: [ each isSymbol not ] ]).
	self assert: (object at: #name) equals: 'y'.
	self assert: (object at: 'age') equals: 3.
	self assert: object age equals: 3.
	^ object
]
