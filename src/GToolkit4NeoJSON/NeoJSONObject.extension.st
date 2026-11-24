Extension { #name : #NeoJSONObject }

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> add: anAssociation [
	^ super add: ((self normalizedJsonKey: anAssociation key) -> anAssociation value)
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> associationAt: aKey [
	^ super associationAt: (self normalizedJsonKey: aKey)
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> associationAt: aKey ifAbsent: aBlock [
	^ super associationAt: (self normalizedJsonKey: aKey) ifAbsent: aBlock
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> associationAt: aKey ifPresent: aBlock [
	^ super associationAt: (self normalizedJsonKey: aKey) ifPresent: aBlock
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> associationAt: aKey ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ super associationAt: (self normalizedJsonKey: aKey) ifPresent: aPresentBlock ifAbsent: anAbsentBlock
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> at: firstKey at: secondKey ifAbsent: aZeroArgBlock [
	"OrderedDictionary looks up firstKey in its dictionary directly"

	^ (self at: firstKey ifAbsent: [ ^ aZeroArgBlock value ]) at: secondKey ifAbsent: aZeroArgBlock
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> at: firstKey at: secondKey ifAbsentPut: aZeroArgBlock [
	"OrderedDictionary stores firstKey in its dictionary directly.
	As #at:at:put:, create a new level of my species when needed"

	^ (self at: firstKey ifAbsentPut: [ self species new ]) at: secondKey ifAbsentPut: aZeroArgBlock
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> at: aKey ifAbsent: aBlock [
	^ super at: (self normalizedJsonKey: aKey) ifAbsent: aBlock
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> at: aKey ifPresent: aBlock [
	^ super at: (self normalizedJsonKey: aKey) ifPresent: aBlock
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> at: aKey ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ super at: (self normalizedJsonKey: aKey) ifPresent: aPresentBlock ifAbsent: anAbsentBlock
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> at: aKey put: aValue [
	^ super at: (self normalizedJsonKey: aKey) put: aValue
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> gtJsonFor: aView [
	<gtView>
	^ aView explicit
		title: 'JSON';
		priority: 10;
		stencil: [ | editorElement textEditor text |
			textEditor := BrTextEditorModel new.
			textEditor styler: JSONParser gtStyler.
			editorElement := BrEditorElement new.
			editorElement editor: textEditor.
			text := (NeoJSONWriter toStringPretty: self) asRopedText.
			text glamorousCodeFontDo: #beNotOverwritableByStyler; glamorousCodeSizeDo: #beNotOverwritableByStyler.
			textEditor text: text.
			editorElement
				padding: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			editorElement ]
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> includesAssociation: anAssociation [
	^ super includesAssociation: ((self normalizedJsonKey: anAssociation key) -> anAssociation value)
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> includesKey: aKey [
	^ super includesKey: (self normalizedJsonKey: aKey)
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> indexOfKey: aKey ifAbsent: aBlock [
	^ super indexOfKey: (self normalizedJsonKey: aKey) ifAbsent: aBlock
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> normalizedJsonKey: aKey [
	"JSON property names use strings; leave other key types unchanged."
	^ aKey isSymbol ifTrue: [ aKey asString ] ifFalse: [ aKey ]
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> putObjectSchemaAt: aKey properties: aProperties [
	self
		at: aKey
		put: (NeoJSONObject new
				at: #type put: 'object';
				at: #properties put: aProperties;
				yourself)
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> putStringArraySchemaAt: aKey [
	self
		at: aKey
		put: {NeoJSONObject new
					at: #type put: 'array';
					putStringSchemaAt: #items;
					yourself}
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> putStringOrNilSchemaAt: aKey [
	self
		at: aKey
		put: (NeoJSONObject new
				at: #type put: #('string' 'null');
				yourself)
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> putStringSchemaAt: aKey [
	self
		at: aKey
		put: (NeoJSONObject new
				at: #type put: 'string';
				yourself)
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> removeKey: aKey [
	^ super removeKey: (self normalizedJsonKey: aKey)
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> removeKey: aKey ifAbsent: aBlock [
	^ super removeKey: (self normalizedJsonKey: aKey) ifAbsent: aBlock
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> removeKeys: aKeyCollection [
	"OrderedDictionary removes several keys from its dictionary directly"

	aKeyCollection do: [ :each | self removeKey: each ifAbsent: [ nil ] ]
]

{ #category : #'*GToolkit4NeoJSON' }
NeoJSONObject >> replaceKey: aKey with: otherKey [
	^ super replaceKey: (self normalizedJsonKey: aKey) with: (self normalizedJsonKey: otherKey)
]
