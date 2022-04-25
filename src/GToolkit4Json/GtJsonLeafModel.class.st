Class {
	#name : #GtJsonLeafModel,
	#superclass : #GtJsonModel,
	#instVars : [
		'defaultValue',
		'modelValue'
	],
	#category : #'GToolkit4Json-Model'
}

{ #category : #'instace creation' }
GtJsonLeafModel class >> forJson: aJson defaultValue: aValue [

	^ (self forJson: aJson) defaultValue: aValue
]

{ #category : #'instace creation' }
GtJsonLeafModel class >> forValue: aValue defaultValue: aDefaultValue [

	^ self new
		  value: aValue;
		  defaultValue: aDefaultValue
]

{ #category : #private }
GtJsonLeafModel >> convertJsonObjectToValue [

	^ self json jsonObject
]

{ #category : #private }
GtJsonLeafModel >> createModelValue [

	self json ifNil: [ 
		^ GtJsonModelValue defaultValue: self defaultValue ].
	self json exists ifFalse: [ 
		^ GtJsonModelValue defaultValue: self defaultValue ].

	^ self secureConvertJsonObjectToValue
]

{ #category : #accessing }
GtJsonLeafModel >> defaultValue [

	^ defaultValue
]

{ #category : #accessing }
GtJsonLeafModel >> defaultValue: anObject [

	defaultValue := anObject
]

{ #category : #'gt - extensions' }
GtJsonLeafModel >> gtErrorDescriptionFor: aView [

	<gtView>
	self valueExists ifTrue: [ ^ aView empty ].

	^ aView textEditor
		  title: 'Invalid Value';
		  priority: 1;
		  glamorousRegularFontAndSize;
		  text: [ self modelValue description ]
]

{ #category : #'gt - extensions' }
GtJsonLeafModel >> gtPreviewFor: aView [

	<gtView>
	self valueExists ifFalse: [ ^ aView empty ].

	^ aView forward
		  title: 'Preview';
		  priority: 55;
		  object: [ self value ];
		  view: #gtLiveFor:
]

{ #category : #private }
GtJsonLeafModel >> modelValue [

	^ modelValue ifNil: [ modelValue := self createModelValue ]
]

{ #category : #private }
GtJsonLeafModel >> secureConvertJsonObjectToValue [

	^ [ GtJsonModelValue value: self convertJsonObjectToValue ]
		  on: Error
		  do: [ :anError | 
			  anError return: (GtJsonModelValue
					   exception: anError
					   jsonObject: self json jsonObject
					   defaultValue: self defaultValue) ]
]

{ #category : #accessing }
GtJsonLeafModel >> value [

	^ self modelValue value
]

{ #category : #accessing }
GtJsonLeafModel >> value: anObject [

	modelValue := GtJsonModelValue value: anObject
]

{ #category : #testing }
GtJsonLeafModel >> valueExists [

	^ self modelValue exists
]
