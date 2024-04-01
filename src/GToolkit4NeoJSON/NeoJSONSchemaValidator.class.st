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
NeoJSONSchemaValidator >> addValidationError: validationError [
	validationErrors add: validationError.
	^ false
]

{ #category : #accessing }
NeoJSONSchemaValidator >> addValidationErrorMessage: message [
	| validationError |
	validationError := NeoJSONSchemaValidationError new.
	validationError 
		instance: instance; 
		schema: schema;
		message: message. 
	^ self addValidationError: validationError
]

{ #category : #accessing }
NeoJSONSchemaValidator >> gtViewValidationErrorsIn: composite [
	<gtView>
	self isValid ifTrue: [ ^ composite empty ].
	^ composite columnedList
		title: 'Validation errors';
		priority: 20;
		items: [ self validationErrors ];
		column: 'Location' text: [ :each |
			each location ifNil: [ '' ] ifNotNil: [ :location | #/ join: location ] ];
		column: 'Message' text: #message
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
		ifFalse: [ self addValidationErrorMessage: 'boolean expected' ].
]

{ #category : #accessing }
NeoJSONSchemaValidator >> validateGeneral [
	schema const ifNotNil: [ :const |
		instance = const ifFalse: [ self addValidationErrorMessage: ('not equal to const {1}' format: { const }) ] ].
	schema enum ifNotNil: [ :enum |
		(enum includes: instance) ifFalse: [ self addValidationErrorMessage: ('not part of enum {1}' format: { enum }) ] ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateInteger [
	(instance isNumber and: [ instance isInteger  or: [ instance asInteger = instance ] ])
		ifTrue: [ self validateNumeric ]
		ifFalse: [ self addValidationErrorMessage: 'integer expected' ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateNull [
	instance isNil
		ifFalse: [ self addValidationErrorMessage: 'null expected' ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateNumber [
	instance isNumber
		ifTrue: [ self validateNumeric ]
		ifFalse: [ self addValidationErrorMessage: 'number expected' ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateNumeric [
	schema multipleOf ifNotNil: [ :multiple |
		(instance // multiple) * multiple = instance
			ifFalse: [ self addValidationErrorMessage: ('not multipleOf {1}' format: { multiple }) ] ].
	schema minimum ifNotNil: [ :minimum |
		minimum <= instance
			ifFalse: [ self addValidationErrorMessage: ('smaller than minimum {1}' format: { minimum }) ] ].
	schema exclusiveMinimum ifNotNil: [ :minimum |
		minimum < instance
			ifFalse: [ self addValidationErrorMessage: ('smaller or equal than exclusiveMinimum {1}' format: { minimum }) ] ].
	schema maximum ifNotNil: [ :maximum |
		instance <= maximum
			ifFalse: [ self addValidationErrorMessage: ('larger than maximum {1}' format: { maximum }) ] ].
	schema exclusiveMaximum ifNotNil: [ :maximum |
		instance < maximum
			ifFalse: [ self addValidationErrorMessage: ('larger or equal than maximum {1}' format: { maximum }) ] ].
]

{ #category : #accessing }
NeoJSONSchemaValidator >> validateObject [
	schema properties ifNotNil: [ :properties |
		properties keysAndValuesDo: [ :key :value | | subSchema subValidator subInstance |
			subSchema := schema resolveSubSchema: value.
			subValidator := subSchema validator.
			(instance includesKey: key)
				ifTrue: [
					subInstance := instance at: key.
					(subValidator validate: subInstance)
						ifFalse: [ subValidator validationErrors do: [ :each | 
							self addValidationError: (each pushLocation: key) ] ] ] ] ].
	schema required ifNotNil: [ :required |
		required \ instance keys
			ifNotEmpty: [ :missing | self addValidationErrorMessage: ('required properties missing {1}' format: { ', ' join: missing }) ] ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateString [
	instance isString
		ifFalse: [ ^ self addValidationErrorMessage: 'string expected' ].
	schema minLength ifNotNil: [ :minimum |
		minimum <= instance size
			ifFalse: [ self addValidationErrorMessage: ('shorter than minLength {1}' format: { minimum }) ] ].
	schema maxLength ifNotNil: [ :maximum |
		instance size <= maximum
			ifFalse: [ self addValidationErrorMessage: ('longer than maxLength {1}' format: { maximum }) ] ].
	"pattern"
	"format"
]

{ #category : #accessing }
NeoJSONSchemaValidator >> validationErrors [
	^ validationErrors
]
