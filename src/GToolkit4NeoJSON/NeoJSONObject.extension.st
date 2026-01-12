Extension { #name : #NeoJSONObject }

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
