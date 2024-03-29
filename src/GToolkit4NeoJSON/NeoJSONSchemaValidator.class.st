Class {
	#name : #NeoJSONSchemaValidator,
	#superclass : #Object,
	#instVars : [
		'schema',
		'instance',
		'validationErrors'
	],
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #accessing }
NeoJSONSchemaValidator >> addValidationError: message [
	validationErrors add: message.
	^ false
]

{ #category : #initialization }
NeoJSONSchemaValidator >> initialize [
	super initialize.
	validationErrors := OrderedCollection new
]

{ #category : #validation }
NeoJSONSchemaValidator >> isValid [
	^ validationErrors isEmpty
]

{ #category : #accessing }
NeoJSONSchemaValidator >> schema [
	^ schema
]

{ #category : #accessing }
NeoJSONSchemaValidator >> schema: jsonSchema [
	schema := jsonSchema
]

{ #category : #validation }
NeoJSONSchemaValidator >> validate: jsonInstance [
	validationErrors removeAll.
	instance := jsonInstance.
	schema raw = true ifTrue: [ ^ true ].
	schema raw = false ifTrue: [ ^ self addValidationError: 'false JSON Schema is always invalid' ].
	schema isEmpty ifTrue: [ ^ true ].
	schema type ifNotNil: [ :type |
		self perform: #validate , type capitalized ].
	self validateGeneral.
	^ self isValid
]

{ #category : #accessing }
NeoJSONSchemaValidator >> validateArray [
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateBoolean [
	instance isBoolean
		ifFalse: [ self addValidationError: 'boolean expected' ].
]

{ #category : #accessing }
NeoJSONSchemaValidator >> validateGeneral [
	schema const ifNotNil: [ :const |
		instance = const ifFalse: [ self addValidationError: ('not equal to const {1}' format: { const }) ] ].
	schema enum ifNotNil: [ :enum |
		(enum includes: instance) ifFalse: [ self addValidationError: ('not part of enum {1}' format: { enum }) ] ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateInteger [
	(instance isNumber and: [ instance isInteger  or: [ instance asInteger = instance ] ])
		ifTrue: [ self validateNumeric ]
		ifFalse: [ self addValidationError: 'integer expected' ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateNull [
	instance isNil
		ifFalse: [ self addValidationError: 'null expected' ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateNumber [
	instance isNumber
		ifTrue: [ self validateNumeric ]
		ifFalse: [ self addValidationError: 'number expected' ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateNumeric [
	schema multipleOf ifNotNil: [ :multiple |
		(instance // multiple) * multiple = instance
			ifFalse: [ self addValidationError: ('not multipleOf {1}' format: { multiple }) ] ].
	schema minimum ifNotNil: [ :minimum |
		minimum <= instance
			ifFalse: [ self addValidationError: ('smaller than minimum {1}' format: { minimum }) ] ].
	schema exclusiveMinimum ifNotNil: [ :minimum |
		minimum < instance
			ifFalse: [ self addValidationError: ('smaller or equal than exclusiveMinimum {1}' format: { minimum }) ] ].
	schema maximum ifNotNil: [ :maximum |
		instance <= maximum
			ifFalse: [ self addValidationError: ('larger than maximum {1}' format: { maximum }) ] ].
	schema exclusiveMaximum ifNotNil: [ :maximum |
		instance < maximum
			ifFalse: [ self addValidationError: ('larger or equal than maximum {1}' format: { maximum }) ] ].
]

{ #category : #accessing }
NeoJSONSchemaValidator >> validateObject [
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateString [
	instance isString
		ifFalse: [ ^ self addValidationError: 'string expected' ].
	schema minLength ifNotNil: [ :minimum |
		minimum <= instance size
			ifFalse: [ self addValidationError: ('shorter than minLength {1}' format: { minimum }) ] ].
	schema maxLength ifNotNil: [ :maximum |
		instance size <= maximum
			ifFalse: [ self addValidationError: ('longer than maxLength {1}' format: { maximum }) ] ].
	"pattern"
	"format"
]

{ #category : #accessing }
NeoJSONSchemaValidator >> validationErrors [
	^ validationErrors
]
