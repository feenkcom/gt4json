Class {
	#name : #NeoJSONSchemaExamples,
	#superclass : #Object,
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #'examples - string and symbol keys' }
NeoJSONSchemaExamples >> accessorsOnBothKinds [
	"The same schema read from JSON, built with String keys and built with Symbol keys"

	<gtExample>
	<return: #NeoJSONSchema>
	| parsed fromStrings fromSymbols |
	parsed := NeoJSONSchema new json: (NeoJSONObject fromString: '{"type":"string","description":"d","$comment":"c","minLength":2}').
	fromStrings := NeoJSONSchema new json: (NeoJSONObject new at: 'type' put: 'string'; at: 'description' put: 'd'; at: '$comment' put: 'c'; at: 'minLength' put: 2; yourself).
	fromSymbols := NeoJSONSchema new json: (NeoJSONObject new at: #type put: 'string'; at: #description put: 'd'; at: #'$comment' put: 'c'; at: #minLength put: 2; yourself).
	{ parsed. fromStrings. fromSymbols } do: [ :each |
		self assert: each type = 'string'.
		self assert: each description = 'd'.
		self assert: each comment = 'c'.
		self assert: each minLength = 2.
		self assert: each maxLength isNil.
		self assert: (each validate: 'abc').
		self assert: (each validate: 'a') not ].
	self assert: fromSymbols = parsed.
	^ parsed
]

{ #category : #'examples - string and symbol keys' }
NeoJSONSchemaExamples >> dependentRequiredValidatesStringKeyedData [
	<gtExample>
	<return: #NeoJSONSchema>
	| schema |
	schema := NeoJSONSchema new json: (NeoJSONObject fromString: '{"type":"object","dependentRequired":{"a":["b"]}}').
	self assert: (schema validate: (STONJSON fromString: '{"a":1}')) not.
	self assert: (schema validate: (STONJSON fromString: '{"a":1,"b":2}')).
	self assert: (schema validate: (STONJSON fromString: '{"c":1}')).
	^ schema
]

{ #category : #'examples - string and symbol keys' }
NeoJSONSchemaExamples >> equalityAndJsonOutput [
	<gtExample>
	<return: #NeoJSONSchema>
	| parsed schema |
	parsed := NeoJSONObject fromString: self stringAndSymbolKeysSchemaJson.
	schema := NeoJSONSchema new json: parsed.
	self assert: schema = (NeoJSONSchema new json: (NeoJSONObject fromString: self stringAndSymbolKeysSchemaJson)).
	self assert: schema json = parsed.
	self assert: parsed = schema json.
	self assert: (NeoJSONWriter toString: schema json) = (NeoJSONWriter toString: parsed).
	self assert: (NeoJSONWriter toStringPretty: schema json) = (NeoJSONWriter toStringPretty: parsed).
	^ schema
]

{ #category : #accessing }
NeoJSONSchemaExamples >> firstSchema [
	<gtExample>
	<return: #NeoJSONSchema>
	| jsonObject schema |
	jsonObject := NeoJSONObject fromString: self firstSchemaJson.
	schema := NeoJSONSchema new json: jsonObject.
	^ schema
]

{ #category : #accessing }
NeoJSONSchemaExamples >> firstSchemaInstanceOneJson [
	^ '{
  "productId": 1,
  "productName": "An ice sculpture",
  "price": 12.50,
  "tags": [ "cold", "ice" ],
  "dimensions": {
    "length": 7.0,
    "width": 12.0,
    "height": 9.5
  },
  "warehouseLocation": {
    "latitude": -78.75,
    "longitude": 20.4
  }
}'
]

{ #category : #accessing }
NeoJSONSchemaExamples >> firstSchemaInstanceTwoJson [
	^ '{
  "productId": 1,
  "productName": "An ice sculpture",
  "price": 12.50,
  "tags": [ "cold", "ice" ],
  "dimensions": {
    "length": 7.0,
    "width": 12.0
  },
  "warehouseLocation": {
    "latitude": -200.4
  }
}'
]

{ #category : #accessing }
NeoJSONSchemaExamples >> firstSchemaJson [
	^ '{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://example.com/product.schema.json",
  "title": "Product",
  "description": "A product from Acme''s catalog",
  "type": "object",
  "$defs": {
    "Coordinates": {
      "title": "Longitude and Latitude",
      "description": "A geographical coordinate on a planet (most commonly Earth).",
      "required": [ "latitude", "longitude" ],
      "type": "object",
      "properties": {
        "latitude": {
          "type": "number",
          "minimum": -90,
          "maximum": 90
        },
        "longitude": {
          "type": "number",
          "minimum": -180,
          "maximum": 180
        }
      }
    }
  },
  "properties": {
    "productId": {
      "description": "The unique identifier for a product",
      "type": "integer"
    },
    "productName": {
      "description": "Name of the product",
      "type": "string"
    },
    "price": {
      "description": "The price of the product",
      "type": "number",
      "exclusiveMinimum": 0
    },
    "tags": {
      "description": "Tags for the product",
      "type": "array",
      "items": {
        "type": "string"
      },
      "minItems": 1,
      "uniqueItems": true
    },
    "dimensions": {
      "type": "object",
      "properties": {
        "length": {
          "type": "number"
        },
        "width": {
          "type": "number"
        },
        "height": {
          "type": "number"
        }
      },
      "required": [ "length", "width", "height" ]
    },
    "warehouseLocation": {
      "description": "Coordinates of the warehouse where the product is located.",
      "$ref": "#/$defs/Coordinates"
    }
  },
  "required": [ "productId", "productName", "price" ]
}'
]

{ #category : #'examples - string and symbol keys' }
NeoJSONSchemaExamples >> parsedSchemaValidatesStringKeyedData [
	<gtExample>
	<return: #NeoJSONSchema>
	| schema |
	schema := NeoJSONSchema new json: (NeoJSONObject fromString: self stringAndSymbolKeysSchemaJson).
	self assert: (schema validate: (STONJSON fromString: '{"name":"x","age":1}')).
	self assert: (schema validate: (STONJSON fromString: '{"name":"x","age":"old"}')) not.
	self assert: (schema validate: (STONJSON fromString: '{"age":1}')) not.
	^ schema
]

{ #category : #'examples - string and symbol keys' }
NeoJSONSchemaExamples >> parsedSchemaValidatesSymbolKeyedData [
	"Data built with Symbol keys in a NeoJSONObject"

	<gtExample>
	<return: #NeoJSONSchema>
	| schema |
	schema := NeoJSONSchema new json: (NeoJSONObject fromString: self stringAndSymbolKeysSchemaJson).
	self assert: (schema validate: (NeoJSONObject new at: #name put: 'x'; at: #age put: 1; yourself)).
	self assert: (schema validate: (NeoJSONObject new at: #name put: 'x'; at: #age put: 'old'; yourself)) not.
	self assert: (schema validate: (NeoJSONObject new at: #age put: 1; yourself)) not.
	^ schema
]

{ #category : #'examples - string and symbol keys' }
NeoJSONSchemaExamples >> refToDefsInParsedSchema [
	<gtExample>
	<return: #NeoJSONSchema>
	| schema |
	schema := NeoJSONSchema new
			json: (NeoJSONObject fromString: '{"$defs":{"positive":{"type":"integer","minimum":1}},"type":"object","properties":{"n":{"$ref":"#/$defs/positive"}}}').
	self assert: (schema validate: (STONJSON fromString: '{"n":3}')).
	self assert: (schema validate: (STONJSON fromString: '{"n":0}')) not.
	self assert: (schema validate: (STONJSON fromString: '{"n":"x"}')) not.
	^ schema
]

{ #category : #'examples - string and symbol keys' }
NeoJSONSchemaExamples >> refToDefsInStringKeyedSchema [
	<gtExample>
	<return: #NeoJSONSchema>
	| schema |
	schema := NeoJSONSchema new
			json: (NeoJSONObject new
					at: '$defs' put: (NeoJSONObject new at: 'positive' put: (NeoJSONObject new at: 'type' put: 'integer'; at: 'minimum' put: 1; yourself); yourself);
					at: 'type' put: 'object';
					at: 'properties' put: (NeoJSONObject new at: 'n' put: (NeoJSONObject new at: '$ref' put: '#/$defs/positive'; yourself); yourself);
					yourself).
	self assert: (schema validate: (STONJSON fromString: '{"n":3}')).
	self assert: (schema validate: (STONJSON fromString: '{"n":0}')) not.
	^ schema
]

{ #category : #accessing }
NeoJSONSchemaExamples >> stringAndSymbolKeysSchemaJson [
	^ '{"type":"object","properties":{"name":{"type":"string"},"age":{"type":"integer"}},"required":["name"]}'
]

{ #category : #'examples - string and symbol keys' }
NeoJSONSchemaExamples >> stringKeyedSchemaValidatesStringKeyedData [
	<gtExample>
	<return: #NeoJSONSchema>
	| schema |
	schema := NeoJSONSchema new
			json: (NeoJSONObject new
					at: 'type' put: 'object';
					at: 'properties'
						put: (NeoJSONObject new
								at: 'name' put: (NeoJSONObject new at: 'type' put: 'string'; yourself);
								at: 'age' put: (NeoJSONObject new at: 'type' put: 'integer'; yourself);
								yourself);
					at: 'required' put: #('name');
					yourself).
	self assert: (schema validate: (STONJSON fromString: '{"name":"x","age":1}')).
	self assert: (schema validate: (STONJSON fromString: '{"name":"x","age":"old"}')) not.
	self assert: (schema validate: (STONJSON fromString: '{"age":1}')) not.
	self assert: schema type = 'object'.
	^ schema
]

{ #category : #'examples - string and symbol keys' }
NeoJSONSchemaExamples >> symbolKeyedSchemaValidatesStringKeyedData [
	"A schema built with Symbol keys, as #putObjectSchemaAt:properties: and #putStringSchemaAt: build it"

	<gtExample>
	<return: #NeoJSONSchema>
	| schema |
	schema := NeoJSONSchema new
			json: (NeoJSONObject new
					at: #type put: 'object';
					at: #properties
						put: (NeoJSONObject new
								putStringSchemaAt: #name;
								at: #age put: (NeoJSONObject new at: #type put: 'integer'; yourself);
								yourself);
					at: #required put: #('name');
					yourself).
	self assert: (schema validate: (STONJSON fromString: '{"name":"x","age":1}')).
	self assert: (schema validate: (STONJSON fromString: '{"name":"x","age":"old"}')) not.
	self assert: (schema validate: (STONJSON fromString: '{"age":1}')) not.
	self assert: (schema json at: 'properties') keys asArray equals: #('name' 'age').
	^ schema
]

{ #category : #accessing }
NeoJSONSchemaExamples >> validateFirstSchemaInstanceOne [
	<gtExample>
	<return: #NeoJSONSchemaValidator>
	| schema instance validator |
	schema := self firstSchema.
	instance := NeoJSONObject fromString: self firstSchemaInstanceOneJson.
	validator := schema validator.
	self assert: (validator validate: instance).
	self assert: validator validationErrors isEmpty.
	^ validator
]

{ #category : #accessing }
NeoJSONSchemaExamples >> validateFirstSchemaInstanceTwo [
	<gtExample>
	<return: #NeoJSONSchemaValidator>
	| schema instance validator |
	schema := self firstSchema.
	instance := NeoJSONObject fromString: self firstSchemaInstanceTwoJson.
	validator := schema validator.
	self assert: (validator validate: instance) not.
	self assert: validator validationErrors notEmpty.
	^ validator
]
