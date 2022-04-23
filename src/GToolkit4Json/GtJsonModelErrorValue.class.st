Class {
	#name : #GtJsonModelErrorValue,
	#superclass : #Object,
	#instVars : [
		'exception',
		'defaultValue',
		'jsonObject'
	],
	#category : #'GToolkit4Json-Users'
}

{ #category : #accessing }
GtJsonModelErrorValue >> defaultValue [

	^ defaultValue
]

{ #category : #accessing }
GtJsonModelErrorValue >> defaultValue: anObject [

	defaultValue := anObject
]

{ #category : #accessing }
GtJsonModelErrorValue >> description [

	^ 'The initial value `{1}` produces the following error: {2}.' format: { 
			  self jsonObject.
			  self exception messageText }
]

{ #category : #accessing }
GtJsonModelErrorValue >> exception [

	^ exception
]

{ #category : #accessing }
GtJsonModelErrorValue >> exception: anObject [

	exception := anObject
]

{ #category : #testing }
GtJsonModelErrorValue >> exists [

	^ false
]

{ #category : #'gt - extensions' }
GtJsonModelErrorValue >> gtMessageTextFor: aView [

	<gtView>
	self exception ifNil: [ ^ aView empty ].

	^ aView forward
		  title: 'Message';
		  priority: 1;
		  object: [ self exception ];
		  view: #gtMessageTextFor:
]

{ #category : #accessing }
GtJsonModelErrorValue >> jsonObject [

	^ jsonObject
]

{ #category : #accessing }
GtJsonModelErrorValue >> jsonObject: anObject [

	jsonObject := anObject
]

{ #category : #accessing }
GtJsonModelErrorValue >> value [

	^ self defaultValue
]
