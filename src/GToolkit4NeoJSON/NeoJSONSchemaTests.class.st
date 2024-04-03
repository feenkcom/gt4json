Class {
	#name : #NeoJSONSchemaTests,
	#superclass : #TestCase,
	#instVars : [
		'schema'
	],
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #accessing }
NeoJSONSchemaTests >> arrayOfInstances [
	^ { 42 . 'string' . Float pi . true . nil . #(1 2 3). { 'foo'->'bar' } as: NeoJSONObject }
]

{ #category : #asserting }
NeoJSONSchemaTests >> assertValid: jsonObject [
	| validator errors |
	validator := schema validator.
	validator validate: jsonObject.
	errors := validator validationErrors.
	self assert: validator isValid.
	self assert: errors isEmpty.
	^ validator
]

{ #category : #asserting }
NeoJSONSchemaTests >> assertValidJson: jsonString [
	| jsonObject |
	jsonObject := NeoJSONObject fromString: jsonString.
	^ self assertValid: jsonObject
]

{ #category : #asserting }
NeoJSONSchemaTests >> denyValid: jsonObject [
	| validator errors |
	validator := schema validator.
	validator validate: jsonObject.
	errors := validator validationErrors.
	self deny: validator isValid.
	self deny: errors isEmpty.
	^ validator
]

{ #category : #asserting }
NeoJSONSchemaTests >> denyValidJson: jsonString [
	| jsonObject |
	jsonObject := NeoJSONObject fromString: jsonString.
	^ self denyValid: jsonObject
]

{ #category : #accessing }
NeoJSONSchemaTests >> schemaFromJson: jsonString [
	| jsonObject |
	jsonObject := NeoJSONObject fromString: jsonString.
	schema := NeoJSONSchema new json: jsonObject
]

{ #category : #testing }
NeoJSONSchemaTests >> testAllOf [
	self schemaFromJson: '
	{
		"allOf":[
			{"type":"string","maxLength":7},
			{"type":"string","minLength":3}
		]
	}'.
	self assertValidJson: '"foobar"'.
	self assertValidJson: '"abcd"'.
	self denyValidJson: '"fo"'.
	self denyValidJson: '"abcdefghijklmnopqrstuvwxyz"'.
	self denyValidJson: '[1,2]'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testAnyOf [
	self schemaFromJson: '
	{
		"anyOf":[
			{"type":"string"},
			{"type":"integer"}
		]
	}'.
	self assertValidJson: '"foobar"'.
	self assertValidJson: '100'.
	self denyValidJson: 'true'.
	self denyValidJson: '-3.14159'.
	self denyValidJson: '[1,2]'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testArrayAnyExtra [
	self schemaFromJson: '
	{
		"type":"array",
		"prefixItems":[
			{"type":"string","minLength":1},
			{"type":"integer","minimum":1}
		]
	}'.
	self assertValidJson: '["foo",100]'.
	self assertValidJson: '["foo",123,"extra"]'.
	self denyValidJson: '{"first":"Jane","last":"Doe","age":0}'.
	self denyValidJson: '[1,2,3]'.
	self denyValidJson: '["",0]'.
	self denyValidJson: '["x",-1]'.
	self denyValidJson: '["",1000]'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testArrayNoExtra [
	self schemaFromJson: '
	{
		"type":"array",
		"prefixItems":[
			{"type":"string","minLength":1},
			{"type":"integer","minimum":1}
		],
		"items":false
	}'.
	self assertValidJson: '["foo",100]'.
	self denyValidJson: '["foo",123,"extra"]'.
	self denyValidJson: '{"first":"Jane","last":"Doe","age":0}'.
	self denyValidJson: '[1,2,3]'.
	self denyValidJson: '["",0]'.
	self denyValidJson: '["x",-1]'.
	self denyValidJson: '["",1000]'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testArraySimpleListValidation [
	self schemaFromJson: '
	{
		"type":"array",
		"items":{
			"type":"string",
			"minLength":1
		}
	}'.
	self assertValidJson: '["foo","bar"]'.
	self assertValidJson: '[]'.
	self denyValidJson: '{"first":"Jane","last":"Doe","age":0}'.
	self denyValidJson: '[1,2,3]'.
	self denyValidJson: '["foo",""]'.
	self denyValidJson: '100'.
	self denyValidJson: 'null'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testArraySimpleTupleValidation [
	self schemaFromJson: '
	{
		"type":"array",
		"prefixItems":[
			{"type":"string","minLength":1},
			{"type":"integer","minimum":1}
		]
	}'.
	self assertValidJson: '["foo",100]'.
	self assertValidJson: '["x",1]'.
	self denyValidJson: '{"first":"Jane","last":"Doe","age":0}'.
	self denyValidJson: '[1,2,3]'.
	self denyValidJson: '["",0]'.
	self denyValidJson: '["x",-1]'.
	self denyValidJson: '["",1000]'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testArrayStringExtra [
	self schemaFromJson: '
	{
		"type":"array",
		"prefixItems":[
			{"type":"string","minLength":1},
			{"type":"integer","minimum":1}
		],
		"items":{"type":"string"}
	}'.
	self assertValidJson: '["foo",100]'.
	self assertValidJson: '["foo",123,"extra"]'.
	self denyValidJson: '["foo",123,1000000]'.
	self denyValidJson: '{"first":"Jane","last":"Doe","age":0}'.
	self denyValidJson: '[1,2,3]'.
	self denyValidJson: '["",0]'.
	self denyValidJson: '["x",-1]'.
	self denyValidJson: '["",1000]'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testBoolean [
	schema := NeoJSONSchema new json: ({ 'type' -> 'boolean' } as: NeoJSONObject).
	#( true false ) do: [ :each |
		self assert: (schema validate: each) ].
	{ 'foo' . 42 . nil . #(1 2 3) . Float pi } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testConst [
	schema := NeoJSONSchema new json: ({ 'const' -> 'one' } as: NeoJSONObject).
	self assert: (schema validate: 'one').
	{ 42 . 'string' . Float pi . true . #(1 2 3). { 'foo'->'bar' } as: NeoJSONObject } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testDependentRequired [
	self schemaFromJson: '{
  	"type": "object",
  	"properties": {
    	"name": { "type": "string" },
   	 "credit_card": { "type": "number" },
    	"billing_address": { "type": "string" }
  	},
  	"required": ["name"],
  	"dependentRequired": {
  	  "credit_card": ["billing_address"]
  	}
	}'.
	self assertValidJson: '{
  	"name": "John Doe",
  	"credit_card": 5555555555555555,
  	"billing_address": "555 Debtor''s Lane"
	}'.
	self assertValidJson: '{
  	"name": "John Doe"
	}'.
	self denyValidJson: '{
  	"name": "John Doe",
  	"credit_card": 5555555555555555
	}'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testDependentSchemas [
	self schemaFromJson: '{
 	 "type": "object",
  	"properties": {
    	"name": { "type": "string" },
    	"credit_card": { "type": "number" }
  	},
  	"required": ["name"],
  	"dependentSchemas": {
   	 "credit_card": {
   	   "type":"object",
    	  "properties": {
        	"billing_address": { "type": "string" }
      	},
      	"required": ["billing_address"]
    	}
  	}
	}'.
	self assertValidJson: '{
  	"name": "John Doe",
  	"credit_card": 5555555555555555,
  	"billing_address": "555 Debtor''s Lane"
	}'.
	self assertValidJson: '{
  	"name": "John Doe"
	}'.
	self denyValidJson: '{
  	"name": "John Doe",
  	"credit_card": 5555555555555555
	}'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testEmpty [
	schema := NeoJSONSchema new.
	self arrayOfInstances do: [ :each |
		self assert: (schema validate: each) ] 
]

{ #category : #testing }
NeoJSONSchemaTests >> testEnum [
	schema := NeoJSONSchema new json: ({ 'enum' -> #( 'one' 'two' ) } as: NeoJSONObject).
	#( 'one' 'two' ) do: [ :each |
		self assert: (schema validate: each) ].
	{ 'foo' . Float pi . true . nil . #(1 2 3) } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testFalse [
	schema := NeoJSONSchema new json: false.
	self arrayOfInstances do: [ :each |
		self deny: (schema validate: each) ] 
]

{ #category : #testing }
NeoJSONSchemaTests >> testInteger [
	schema := NeoJSONSchema new json: ({ 'type' -> 'integer' } as: NeoJSONObject).
	#( 1 -1 0 1.0 0.0 -1.0 ) do: [ :each |
		self assert: (schema validate: each) ].
	{ 'foo' . Float pi . true . nil . #(1 2 3) } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testIntegerMultiple [
	schema := NeoJSONSchema new json: ({ 
		'type' -> 'integer' . 
		'multipleOf' -> 10 } as: NeoJSONObject).
	#( 0 10 20 100 ) do: [ :each |
		self assert: (schema validate: each) ].
	#( 1 5 15 3.14159 'NaN' ) do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testNot [
	self schemaFromJson: '
	{
		"not":{
			"type":"string"
		}
	}'.
	self assertValidJson: '100'.
	self assertValidJson: 'null'.
	self denyValidJson: '"foo"'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testNull [
	schema := NeoJSONSchema new json: ({ 'type' -> 'null' } as: NeoJSONObject).
	self assert: (schema validate: nil).
	{ 42 . 'string' . Float pi . true . #(1 2 3). { 'foo'->'bar' } as: NeoJSONObject } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testNumber [
	schema := NeoJSONSchema new json: ({ 'type' -> 'number' } as: NeoJSONObject).
	#( 1 -1 0 1.0 0.0 -1.0 3.14159 -0.123456789e10 ) do: [ :each |
		self assert: (schema validate: each) ].
	{ 'foo' . true . nil . #(1 2 3) } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testNumberExclusiveRange [
	schema := NeoJSONSchema new json: ({ 
		'type' -> 'number' . 
		'exclusiveMinimum' -> 10 . 
		'exclusiveMaximum' -> 20 } as: NeoJSONObject).
	#( 11 15 19 ) do: [ :each |
		self assert: (schema validate: each) ].
	#( 10 20 0 50 -1.0 'NaN' ) do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testNumberRange [
	schema := NeoJSONSchema new json: ({ 
		'type' -> 'number' . 
		'minimum' -> 10 . 
		'maximum' -> 20 } as: NeoJSONObject).
	#( 10 15 20 ) do: [ :each |
		self assert: (schema validate: each) ].
	#( 0 50 -1.0 'NaN' ) do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testObjectSimple [
	self schemaFromJson: '
	{
		"type":"object",
		"properties":{
			"first":{"type":"string","minLength":1},
			"last":{"type":"string","minLength":1},
			"age":{"type":"integer","minimum":1}},
		"required":["first","last"]
	}'.
	self assertValidJson: '{"first":"Jane","last":"Doe","age":33}'.
	self assertValidJson: '{"first":"Jane","last":"Doe"}'.
	self denyValidJson: '{"first":"Jane","last":"Doe","age":0}'.
	self denyValidJson: '{"first":"Jane","last":"","age":33}'.
	self denyValidJson: '{"first":-1,"last":false,"age":"N/A"}'.
	self denyValidJson: '{"first":"Jane","age":33}'.
	self denyValidJson: '{"first":"Jane","last":{},"age":33}'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testOneOf [
	self schemaFromJson: '
	{
		"oneOf":[
			{"type":"integer","multipleOf":5},
			{"type":"integer","multipleOf":3}
		]
	}'.
	self assertValidJson: '10'.
	self assertValidJson: '9'.
	self denyValidJson: '2'.
	self denyValidJson: '-3.14159'.
	self denyValidJson: '15'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testString [
	schema := NeoJSONSchema new json: ({ 'type' -> 'string' } as: NeoJSONObject).
	#( 'str' '' 'élève' ) do: [ :each |
		self assert: (schema validate: each) ].
	{ 42 . 3.14159 . true . nil . #(1 2 3) } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testStringFormatDateTime [
	schema := NeoJSONSchema new json: ({ 'type' -> 'string' . 'format' -> 'date-time' } as: NeoJSONObject).
	#( '2018-11-13T20:20:39+00:00' '2024-04-02T08:15:09.762852Z' '2024-04-02T08:15:09.762852+02:00' ) do: [ :each |
		self assert: (schema validate: each) ].
	{ 'foo' . '2024-AA-02T08:15:09.762852Z' . 42 . 3.14159 . true . nil . #(1 2 3) } do: [ :each |
		self deny: (schema validate: each) ] 	
]

{ #category : #testing }
NeoJSONSchemaTests >> testStringLength [
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
NeoJSONSchemaTests >> testStringPattern [
	self schemaFromJson: '
	{
		"type": "string",
		"pattern": "^(\\([0-9]{3}\\))?[0-9]{3}-[0-9]{4}$"
	}'.
	self assertValidJson: '"555-1212"'.
	self assertValidJson: '"(888)555-1212"'.
	self denyValidJson: '"(888)555-1212 ext. 532"'.
	self denyValidJson: '"(800)FLOWERS"'.
	self denyValidJson: '42'.
]

{ #category : #testing }
NeoJSONSchemaTests >> testTrue [
	schema := NeoJSONSchema new json: true.
	self arrayOfInstances do: [ :each |
		self assert: (schema validate: each) ] 
]
