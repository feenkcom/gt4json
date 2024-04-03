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

{ #category : #testing }
NeoJSONSchemaValidator >> isValid [
	^ validationErrors isEmpty
]

{ #category : #accessing }
NeoJSONSchemaValidator >> knowTypes [
	^ #( number integer string boolean null object array )
]

{ #category : #accessing }
NeoJSONSchemaValidator >> knownFormats [
	^ #( 'date-time' )
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
	schema raw = true 
		ifTrue: [ ^ true ].
	schema raw = false
		ifTrue: [ ^ self addValidationErrorMessage: 'false JSON Schema is always invalid' ].
	schema isEmpty 
		ifTrue: [ ^ true ].
	schema type 
		ifNotNil: [ :type | 
			(self knowTypes includes: type)
				ifTrue: [ self perform: #validate , type capitalized ] ].
	self validateGeneric.
	self validateComposition.
	self validateConditionals.
	^ self isValid
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateArray [
	| lastPrefixItemMatch incomplete |
	instance isArray
		ifFalse: [ ^ self addValidationErrorMessage: 'array expected' ].
	lastPrefixItemMatch := 0.
	schema prefixItems ifNotNil: [ :prefixItems |
		incomplete := false.
		prefixItems doWithIndex: [ :prefixItem :index |
			| subSchema subValidator subInstance |
			subSchema := schema resolveSubSchema: prefixItem.
			subValidator := subSchema validator.
			index > instance size
				ifTrue: [ incomplete := true ]
				ifFalse: [
					subInstance := instance at: index.
					(subValidator validate: subInstance)
						ifTrue: [ lastPrefixItemMatch := index ]
						ifFalse: [
							subValidator validationErrors do: [ :error | 
								self addValidationError: (error pushLocation: index) ] ] ] ].
		incomplete ifTrue: [ self addValidationErrorMessage: 'array required prefixItems missing' ] ].
	schema items ifNotNil: [ :items |
		| itemsSchema itemsValidator |
		itemsSchema := schema resolveSubSchema: items.
		itemsValidator := itemsSchema validator.
		instance doWithIndex: [ :item :index |
			index > lastPrefixItemMatch
				ifTrue: [
					(itemsValidator validate: item)
						ifFalse: [
							itemsValidator validationErrors do: [ :error | 
								self addValidationError: (error pushLocation: index) ] ] ] ] ].
	schema uniqueItems ifNotNil: [ :uniqueItems |
		uniqueItems ifTrue: [
			instance asSet size = instance size ifFalse: [ self addValidationErrorMessage: 'array uniqueItems expected' ] ] ].
	schema minItems ifNotNil: [ :minItems |
		minItems <= instance size ifFalse: [
			self addValidationErrorMessage: ('less than minItems [{1}]' format: { minItems }) ] ].
	schema maxItems ifNotNil: [ :maxItems |
		instance size  <= maxItems ifFalse: [
			self addValidationErrorMessage: ('more than maxItems [{1}]' format: { maxItems }) ] ].
	schema contains ifNotNil: [ :contains |
		| containsSchema containsValidator |
		containsSchema := schema resolveSubSchema: contains.
		containsValidator := containsSchema validator.
		(instance anySatisfy: [ :each | containsValidator validate: each ])
			ifFalse: [ self addValidationErrorMessage: 'contains expected' ].
		"minContains"
		"maxContains" ]
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateBoolean [
	instance isBoolean
		ifFalse: [ self addValidationErrorMessage: 'boolean expected' ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateComposition [
	| subSchema subValidator |
	schema allOf ifNotNil: [ :allOf |
		(allOf allSatisfy: [ :each |
			subSchema := schema resolveSubSchema: each.
			subValidator := subSchema validator.
			subValidator validate: instance ])
			ifFalse: [ self addValidationErrorMessage: 'allOf expected' ] ].
	schema anyOf ifNotNil: [ :anyOf |
		(anyOf anySatisfy: [ :each |
			subSchema := schema resolveSubSchema: each.
			subValidator := subSchema validator.
			subValidator validate: instance ])
			ifFalse: [ self addValidationErrorMessage: 'anyOf expected' ] ].
	schema oneOf ifNotNil: [ :oneOf |
		(oneOf count: [ :each |
			subSchema := schema resolveSubSchema: each.
			subValidator := subSchema validator.
			subValidator validate: instance ]) = 1
			ifFalse: [ self addValidationErrorMessage: 'oneOf expected' ] ].
	schema not ifNotNil: [ :not |
		subSchema := schema resolveSubSchema: not.
		subValidator := subSchema validator.
		(subValidator validate: instance)
			ifTrue: [ self addValidationErrorMessage: 'not expected' ] ]
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateConditionals [
	instance isDictionary ifFalse: [ ^ self ].
	schema dependentRequired ifNotNil: [ :dependentRequired |
		dependentRequired keysAndValuesDo: [ :key :value |
			(instance includesKey: key)
				ifTrue: [
					value \ instance keys
						ifNotEmpty: [ :missing | 
							self addValidationErrorMessage: ('required properties missing [{1}]' format: 
								{ ', ' join: missing }) ] ] ] ].
	schema dependentSchemas ifNotNil: [ :dependentSchemas |
		dependentSchemas keysAndValuesDo: [ :key :value |
			(instance includesKey: key)
				ifTrue: [
					| subSchema subValidator |
					subSchema := schema resolveSubSchema: value.
					subValidator := subSchema validator.
					(subValidator validate: instance)
						ifFalse: [
							subValidator validationErrors do: [ :error | 
								self addValidationError: error ] ] ] ] ].
	"if"
	"then"
	"else"
]

{ #category : #formats }
NeoJSONSchemaValidator >> validateFormatDateTime [
	[ DateAndTime fromString: instance ]
		on: Error 
		do: [ self addValidationError: 'string format date-time expected' ] 
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateGeneric [
	schema const ifNotNil: [ :const |
		instance = const 
			ifFalse: [ self addValidationErrorMessage: ('not equal to const [{1}]' format: { const }) ] ].
	schema enum ifNotNil: [ :enum |
		(enum includes: instance) 
			ifFalse: [ self addValidationErrorMessage: ('not part of enum [{1}]' format: { enum }) ] ].
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
			ifFalse: [ self addValidationErrorMessage: ('not multipleOf [{1}]' format: { multiple }) ] ].
	schema minimum ifNotNil: [ :minimum |
		minimum <= instance
			ifFalse: [ self addValidationErrorMessage: ('smaller than minimum [{1}]' format: { minimum }) ] ].
	schema exclusiveMinimum ifNotNil: [ :minimum |
		minimum < instance
			ifFalse: [ self addValidationErrorMessage: ('smaller or equal than exclusiveMinimum [{1}]' format: { minimum }) ] ].
	schema maximum ifNotNil: [ :maximum |
		instance <= maximum
			ifFalse: [ self addValidationErrorMessage: ('larger than maximum [{1}]' format: { maximum }) ] ].
	schema exclusiveMaximum ifNotNil: [ :maximum |
		instance < maximum
			ifFalse: [ self addValidationErrorMessage: ('larger or equal than maximum [{1}]' format: { maximum }) ] ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateObject [
	instance isDictionary
		ifFalse: [ ^ self addValidationErrorMessage: 'object expected'].
	schema properties ifNotNil: [ :properties |
		properties keysAndValuesDo: [ :key :value | 
			| subSchema subValidator subInstance |
			subSchema := schema resolveSubSchema: value.
			subValidator := subSchema validator.
			(instance includesKey: key)
				ifTrue: [
					subInstance := instance at: key.
					(subValidator validate: subInstance)
						ifFalse: [
							subValidator validationErrors do: [ :error | 
								self addValidationError: (error pushLocation: key) ] ] ] ] ].
	schema required ifNotNil: [ :required |
		required \ instance keys
			ifNotEmpty: [ :missing | 
				self addValidationErrorMessage: ('required properties missing [{1}]' format: { ', ' join: missing }) ] ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateString [
	instance isString
		ifFalse: [ ^ self addValidationErrorMessage: 'string expected' ].
	schema minLength ifNotNil: [ :minimum |
		minimum <= instance size
			ifFalse: [ self addValidationErrorMessage: ('shorter than minLength [{1}]' format: { minimum }) ] ].
	schema maxLength ifNotNil: [ :maximum |
		instance size <= maximum
			ifFalse: [ self addValidationErrorMessage: ('longer than maxLength [{1}]' format: { maximum }) ] ].
	schema pattern ifNotNil: [ :pattern |
		(instance matchesRegex: pattern)
			ifFalse: [ self addValidationErrorMessage: ('string does not match pattern [{1}]' format: { pattern }) ] ].
	schema format ifNotNil: [ :format |
		(self knownFormats includes: format)
			ifTrue: [ self perform: #validateFormat , (($- split: format) flatCollect: #capitalized as: String) ] ]
]

{ #category : #accessing }
NeoJSONSchemaValidator >> validationErrors [
	^ validationErrors
]
