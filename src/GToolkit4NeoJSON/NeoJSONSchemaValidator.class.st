"
I am NeoJSONSchemaValidator.

Given a NeoJSONSchema and a JSON instance I run a validation and collect NeoJSONValidationErrors, if any.
"
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

{ #category : #'gt extensions' }
NeoJSONSchemaValidator >> gtViewDetailsIn: composite [
	<gtView>
	^ composite columnedList
		title: 'Details';
		priority: 30;
		items: [ {
			{ #valid . self isValid }.
			{ #instance . instance }.
			{ #schema . self schema }. 
		} ];
		column: 'Key' text: #first;
		column: 'Value' text: #second weight: 3;
		send: #second
]

{ #category : #'gt extensions' }
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
	self validateType.
	self validateNumeric.
	self validateString.
	self validateObject.
	self validateArray.
	self validateGeneric.
	self validateComposition.
	self validateConditionals.
	^ self isValid
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateArray [
	| lastPrefixItemMatch incomplete |
	lastPrefixItemMatch := 0.
	schema prefixItems ifNotNil: [ :prefixItems |
		incomplete := false.
		instance isArray ifTrue: [
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
			incomplete ifTrue: [ 
				self addValidationErrorMessage: 'array required prefixItems missing' ] ] ].
	schema items ifNotNil: [ :items |
		| itemsSchema itemsValidator |
		itemsSchema := schema resolveSubSchema: items.
		itemsValidator := itemsSchema validator.
		instance isArray ifTrue: [
			instance doWithIndex: [ :item :index |
				index > lastPrefixItemMatch
					ifTrue: [
						(itemsValidator validate: item)
							ifFalse: [
								itemsValidator validationErrors do: [ :error | 
									self addValidationError: (error pushLocation: index) ] ] ] ] ] ].
	schema uniqueItems ifNotNil: [ :uniqueItems |
		uniqueItems ifTrue: [
			(instance isArray and: [ instance asSet size = instance size ]) ifFalse: [
				self addValidationErrorMessage: 'array uniqueItems expected' ] ] ].
	schema minItems ifNotNil: [ :minItems |
		(instance isArray and: [ minItems <= instance size ]) ifFalse: [
			self addValidationErrorMessage: ('less than minItems [{1}]' format: { minItems }) ] ].
	schema maxItems ifNotNil: [ :maxItems |
		(instance isArray and: [ instance size  <= maxItems ]) ifFalse: [
			self addValidationErrorMessage: ('more than maxItems [{1}]' format: { maxItems }) ] ].
	schema contains ifNotNil: [ :contains |
		| containsSchema containsValidator |
		containsSchema := schema resolveSubSchema: contains.
		containsValidator := containsSchema validator.
		(instance isArray and: [ instance anySatisfy: [ :each | containsValidator validate: each ] ])
			ifFalse: [ self addValidationErrorMessage: 'contains expected' ].
		"minContains"
		"maxContains" ]
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
	| conditionValue subSchema subValidator |
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
					subSchema := schema resolveSubSchema: value.
					subValidator := subSchema validator.
					(subValidator validate: instance)
						ifFalse: [
							subValidator validationErrors do: [ :error | 
								self addValidationError: error ] ] ] ] ].
	conditionValue := nil.
	schema if ifNotNil: [ :if |
		subSchema := schema resolveSubSchema: if.
		conditionValue := subSchema validate: instance ].
	schema then ifNotNil: [ :then |
		conditionValue = true ifTrue: [
			subSchema := schema resolveSubSchema: then.
			(subSchema validate: instance)
				ifFalse: [ self addValidationErrorMessage: 'if/then failed' ] ] ].
	schema else ifNotNil: [ :else |
		conditionValue = false ifTrue: [
			subSchema := schema resolveSubSchema: else.
			(subSchema validate: instance)
				ifFalse: [ self addValidationErrorMessage: 'if/else failed' ] ] ].
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
NeoJSONSchemaValidator >> validateNumeric [
	schema multipleOf ifNotNil: [ :multiple |
		(instance isNumber and: [ (instance // multiple) * multiple = instance ])
			ifFalse: [ self addValidationErrorMessage: ('not multipleOf [{1}]' format: { multiple }) ] ].
	schema minimum ifNotNil: [ :minimum |
		(instance isNumber and: [ minimum <= instance ])
			ifFalse: [ self addValidationErrorMessage: ('smaller than minimum [{1}]' format: { minimum }) ] ].
	schema exclusiveMinimum ifNotNil: [ :minimum |
		(instance isNumber and: [ minimum < instance ])
			ifFalse: [ self addValidationErrorMessage: ('smaller or equal than exclusiveMinimum [{1}]' format: { minimum }) ] ].
	schema maximum ifNotNil: [ :maximum |
		(instance isNumber and: [ instance <= maximum ])
			ifFalse: [ self addValidationErrorMessage: ('larger than maximum [{1}]' format: { maximum }) ] ].
	schema exclusiveMaximum ifNotNil: [ :maximum |
		(instance isNumber and: [ instance < maximum ])
			ifFalse: [ self addValidationErrorMessage: ('larger or equal than maximum [{1}]' format: { maximum }) ] ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateObject [
	schema properties ifNotNil: [ :properties |
		properties keysAndValuesDo: [ :key :value | 
			| subSchema subValidator subInstance |
			subSchema := schema resolveSubSchema: value.
			subValidator := subSchema validator.
			(instance isDictionary and: [ instance includesKey: key ])
				ifTrue: [
					subInstance := instance at: key.
					(subValidator validate: subInstance)
						ifFalse: [
							subValidator validationErrors do: [ :error | 
								self addValidationError: (error pushLocation: key) ] ] ] ] ].
	schema required ifNotNil: [ :required |
		instance isDictionary
			ifTrue: [
				required \ instance keys
					ifNotEmpty: [ :missing | 
						self addValidationErrorMessage: ('required properties missing [{1}]' format: { ', ' join: missing }) ]]
			ifFalse: [ 
				self addValidationErrorMessage: ('required properties missing [{1}]' format: { ', ' join: required }) ] ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateString [
	schema minLength ifNotNil: [ :minimum |
		(instance isString and: [ minimum <= instance size ])
			ifFalse: [ self addValidationErrorMessage: ('string minLength [{1}] expected' format: { minimum }) ] ].
	schema maxLength ifNotNil: [ :maximum |
		(instance isString and: [ instance size <= maximum ])
			ifFalse: [ self addValidationErrorMessage: ('string maxLength [{1}] expected' format: { maximum }) ] ].
	schema pattern ifNotNil: [ :pattern |
		(instance isString and: [ instance matchesRegex: pattern ])
			ifFalse: [ self addValidationErrorMessage: ('string does not match pattern [{1}]' format: { pattern }) ] ].
	schema format ifNotNil: [ :format |
		(self knownFormats includes: format)
			ifTrue: [ self perform: #validateFormat , (($- split: format) flatCollect: #capitalized as: String) ] ].
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateType [
	schema type ifNotNil: [ :type |
		type isArray
			ifTrue: [
				(type anySatisfy: [ :each |
						(self knowTypes includes: each)
							and: [ self perform: #validateType , each capitalized ] ])
					ifFalse: [ self addValidationErrorMessage: ('{1] expected' format: { ' or' join: type }) ] ]
			ifFalse: [
				(self knowTypes includes: type)
					ifTrue: [ 
						(self perform: #validateType , type capitalized)
							ifFalse: [ self addValidationErrorMessage: ('{1} expected' format: { type }) ] ] ] ]
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateTypeArray [
	^ instance isArray
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateTypeBoolean [
	^ instance isBoolean
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateTypeInteger [
	^ instance isNumber 
		and: [ instance isInteger  
					or: [ instance asInteger = instance ] ]
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateTypeNull [
	^ instance isNil
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateTypeNumber [
	^ instance isNumber
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateTypeObject [
	^ instance isDictionary
]

{ #category : #validation }
NeoJSONSchemaValidator >> validateTypeString [
	^ instance isString
]

{ #category : #accessing }
NeoJSONSchemaValidator >> validationErrors [
	^ validationErrors
]
