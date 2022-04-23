Class {
	#name : #GtJsonDateAndTimeModel,
	#superclass : #GtJsonModel,
	#instVars : [
		'dateAndTime'
	],
	#category : #'GToolkit4Json-Users'
}

{ #category : #initialization }
GtJsonDateAndTimeModel >> computeDateAndTime [

	self json ifNil: [ ^ GtJsonModelValue defaultValue: nil ].

	[ ^ GtJsonModelValue value: self json jsonObject asDateAndTime ]
		on: Error
		do: [ :anError | 
			^ GtJsonModelValue
				  exception: anError
				  jsonObject: self json jsonObject
				  defaultValue: nil ]
]

{ #category : #accessing }
GtJsonDateAndTimeModel >> dateAndTime [

	^ dateAndTime ifNil: [ dateAndTime := self computeDateAndTime ]
]

{ #category : #accessing }
GtJsonDateAndTimeModel >> dateAndTime: anObject [

	dateAndTime := GtJsonModelValue value: anObject
]

{ #category : #'gt - extensions' }
GtJsonDateAndTimeModel >> gtErrorValueFor: aView [

	<gtView>
	self isValid ifTrue: [ ^ aView empty ].

	^ aView textEditor
		  title: 'Invalid Value';
		  priority: 1;
		  glamorousRegularFontAndSize;
		  text: [ self dateAndTime description ]
]

{ #category : #'gt - extensions' }
GtJsonDateAndTimeModel >> gtPreviewFor: aView [

	<gtView>
	self isValid ifFalse: [ ^ aView empty ].

	^ aView forward
		  title: 'Preview';
		  priority: 1;
		  object: [ self value ];
		  view: #gtPreviewFor:
]

{ #category : #testing }
GtJsonDateAndTimeModel >> isValid [

	^ self dateAndTime exists
]

{ #category : #accessing }
GtJsonDateAndTimeModel >> value [

	^ self dateAndTime value
]
