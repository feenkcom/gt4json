Class {
	#name : #NeoJSONSchemaExamples,
	#superclass : #Object,
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #accessing }
NeoJSONSchemaExamples >> firstSchema [
	<gtExample>
	| jsonObject schema|
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

{ #category : #accessing }
NeoJSONSchemaExamples >> validateFirstSchemaInstanceOne [
	<gtExample>
	| schema instance validator |
	schema := self firstSchema.
	instance := NeoJSONObject fromString: self firstSchemaInstanceOneJson.
	validator := schema validator.
	self assert: (validator validate: instance).
	self assert: validator validationErrors isEmpty.
	^ validator
]
