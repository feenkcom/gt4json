Class {
	#name : #GtJsonModelValue,
	#superclass : #Object,
	#instVars : [
		'value'
	],
	#category : #'GToolkit4Json-Model - Value'
}

{ #category : #'instance creation' }
GtJsonModelValue class >> defaultValue: anObject [

	^ GtJsonModelMissingValue new defaultValue: anObject
]

{ #category : #'instace creation' }
GtJsonModelValue class >> exception: anError jsonObject: aJsonObject defaultValue: aValue [

	^ GtJsonModelErrorValue new
		  exception: anError;
		  jsonObject: aJsonObject;
		  defaultValue: aValue
]

{ #category : #'instance creation' }
GtJsonModelValue class >> value: anObject [

	^ self new value: anObject
]

{ #category : #testing }
GtJsonModelValue >> exists [

	^ true
]

{ #category : #'gt - extensions' }
GtJsonModelValue >> gtLiveFor: aView [

	<gtView>
	^ aView forward
		  title: 'Live';
		  priority: 1;
		  object: [ self value ];
		  view: #gtLiveFor:
]

{ #category : #accessing }
GtJsonModelValue >> value [

	^ value
]

{ #category : #accessing }
GtJsonModelValue >> value: anObject [

	value := anObject
]
