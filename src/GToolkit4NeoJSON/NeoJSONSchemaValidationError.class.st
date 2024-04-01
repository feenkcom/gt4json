Class {
	#name : #NeoJSONSchemaValidationError,
	#superclass : #Error,
	#instVars : [
		'instance',
		'schema',
		'location',
		'message'
	],
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #'gt extensions' }
NeoJSONSchemaValidationError >> gtViewDetailsIn: composite [
	<gtView>
	^ composite columnedList
		title: 'Details';
		priority: 10;
		items: [ {
			{ #location 
				. self location ifNil: [ '' ] ifNotNil: [ :elements | $/ join: elements ] 
				. self location }.
			{ #message . self message }.
			{ #instance . self instance }.
			{ #schema . self schema }.
		} ];
		column: #key text: #first;
		column: #value text: #second;
		send: #last
]

{ #category : #accessing }
NeoJSONSchemaValidationError >> instance [
	^ instance
]

{ #category : #accessing }
NeoJSONSchemaValidationError >> instance: anObject [
	instance := anObject
]

{ #category : #accessing }
NeoJSONSchemaValidationError >> location [
	^ location
]

{ #category : #accessing }
NeoJSONSchemaValidationError >> message [
	^ message
]

{ #category : #accessing }
NeoJSONSchemaValidationError >> message: anObject [
	message := anObject
]

{ #category : #accessing }
NeoJSONSchemaValidationError >> messageText [
	^ messageText ifNil: [ 
		self location ifNotNil: [ 
			messageText := '@[{1}] ' format: { $/ join: self location } ].
		messageText := messageText , self message ]
]

{ #category : #accessing }
NeoJSONSchemaValidationError >> pushLocation: element [
	location ifNil: [ location := OrderedCollection new ].
	location addFirst: element
]

{ #category : #accessing }
NeoJSONSchemaValidationError >> schema [
	^ schema
]

{ #category : #accessing }
NeoJSONSchemaValidationError >> schema: aNeoJSONSchema [
	schema := aNeoJSONSchema
]
