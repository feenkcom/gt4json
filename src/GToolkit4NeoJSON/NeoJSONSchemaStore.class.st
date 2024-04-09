"
I am NeoJSONSchemaStore.

My uniqueInstance acts as a cache for JSON Schema source files retrieved over the network.
"
Class {
	#name : #NeoJSONSchemaStore,
	#superclass : #Object,
	#instVars : [
		'schemas'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #accessing }
NeoJSONSchemaStore class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'gt extensions' }
NeoJSONSchemaStore >> gtViewSchemasFor: composite [
	<gtView>
	^ composite columnedList
		title: 'Schemas';
		priority: 10;
		items: [ self schemas associations ];
		column: #URL text: #key;
		column: #Schema text: #value
]

{ #category : #testing }
NeoJSONSchemaStore >> includesSchema: url [
	^ self schemas includesKey: url
]

{ #category : #private }
NeoJSONSchemaStore >> loadSchema: url [
	| client jsonString  |
	client := ZnClient new 
		beOneShot; 
		enforceHttpSuccess: true.
	jsonString := client get: url.
	^ jsonString
]

{ #category : #accessing }
NeoJSONSchemaStore >> reset [
	self schemas removeAll
]

{ #category : #accessing }
NeoJSONSchemaStore >> schemaAt: url [
	^ (self includesSchema: url)
		ifTrue: [ self schemas at: url ]
		ifFalse: [ | jsonString |
			jsonString := self loadSchema: url.
			self schemaAt: url put: jsonString ]
]

{ #category : #accessing }
NeoJSONSchemaStore >> schemaAt: url put: jsonString [
	^ self schemas at: url put: jsonString
]

{ #category : #accessing }
NeoJSONSchemaStore >> schemas [
	^ schemas ifNil: [ schemas := Dictionary new ]
]
